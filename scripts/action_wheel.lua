---@class ActionWheelClass アクションホイールを制御するクラス
---@field MainPage Page アクションホイールのメインページ
---@field ActionCount integer アクション再生中は0より大きくなるカウンター
---@field ActionCancelFunction function 現在再生中のアクションをキャンセルする処理

ActionWheelClass = {}

MainPage = action_wheel:createPage("main_page")
ActionCount = 0
ActionCancelFunction = nil

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
	if ActionCount == 0 or ignoreCooldown then
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

function pings.main_action2()
	runAction(function ()
		EarpickClass.play()
		ActionCount = 200
	end, function ()
		EarpickClass.stop()
		ActionCount = 0
	end, false)
end

events.TICK:register(function ()
	setActionEnabled(1, SitDownClass.CanSitDown)
	setActionEnabled(2, animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" and ActionCount == 0)
	local sitDownAction = MainPage:getAction(1)
	sitDownAction:toggled(SitDownClass.CanSitDown and sitDownAction:isToggled())
	if (HurtClass.Damaged ~= "NONE" and ActionCount > 0) or (animations["models.main"]["earpick"]:getPlayState() == "PLAYING" and animations["models.main"]["sit_down"]:getPlayState() ~= "PLAYING") then
		ActionCancelFunction();
		ActionCount = 0
	end
	ActionCount = ActionCount > 0 and ActionCount - 1 or ActionCount
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

--アクション2. 耳かき
MainPage:newAction(2):item("feather"):onLeftClick(function ()
	if animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" then
		pings.main_action2()
	end
end)

action_wheel:setPage(MainPage)

return ActionWheelClass