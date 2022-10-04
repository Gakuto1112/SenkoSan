---@class ActionWheelClass アクションホイールを制御するクラス
---@field MainPage Page アクションホイールのメインページ
---@field ActionWheelClass.ActionCount integer アクション再生中は0より大きくなるカウンター
---@field ActionCancelFunction function 現在再生中のアクションをキャンセルする処理

ActionWheelClass = {}

MainPage = action_wheel:createPage("main_page")
ActionCancelFunction = nil
ShakeSplashCount = 0

---アクションの色の有効色/無効色の切り替え
---@param actionNumber integer pageNumber内のアクションの番号
---@param enabled boolean 有効色か無効色か
function setActionEnabled(actionNumber, enabled)
	if enabled then
		MainPage:getAction(actionNumber):title(LanguageClass.getTranslate("action_wheel__main__action_"..actionNumber.."__title")):color(1, 85 / 255, 1):hoverColor(1, 1, 1)
	else
		MainPage:getAction(actionNumber):title("§7"..LanguageClass.getTranslate("action_wheel__main__action_"..actionNumber.."__title")):color(42 / 255, 42 / 255, 42 / 255):hoverColor(1, 85 / 255, 85 / 255)
	end
end

---アクションを実行する。ウォーデンが近くにいる時は拒否アクションを実行する。
---@param action function 実行するアクションの関数
---@param actionCancelFunction function アクションのキャンセル処理の関数
---@param ignoreCooldown boolean アニメーションのクールダウンを無視するかどうか
function runAction(action, actionCancelFunction, ignoreCooldown)
	if ActionWheelClass.ActionCount == 0 or ignoreCooldown then
		action()
		ActionCancelFunction = actionCancelFunction
	end
end

--ping関数
function pings.main_action1_toggle()
	SitDownClass.sitDown()
end

function pings.main_action1_untoggle()
	SitDownClass.standUp()
end

events.TICK:register(function ()
	setActionEnabled(1, SitDownClass.CanSitDown)
end)

events.WORLD_TICK:register(function ()
	local sitDownAction = MainPage:getAction(1)
	sitDownAction:toggled(SitDownClass.CanSitDown and sitDownAction:isToggled())
end)

--メインページのアクション設定
--アクション1. おすわり（正座）
MainPage:newToggle(1):item("oak_stairs"):onToggle(function ()
	if SitDownClass.CanSitDown then
		pings.main_action1_toggle()
	end
end):onUntoggle(function ()
	pings.main_action1_untoggle()
end)

action_wheel:setPage(MainPage)

return ActionWheelClass