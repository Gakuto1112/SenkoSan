---@class ActionWheelClass アクションホイールを制御するクラス
---@field MainPage Page アクションホイールのメインページ
---@field ActionCount integer アクション再生中は0より大きくなるカウンター
---@field ActionCancelFunction function 現在再生中のアクションをキャンセルする処理
---@field IsOpenActionWheelPrev boolean 前チックにアクションホイールを開けていたかどうか
---@field ShakeSplashCount integer ブルブル時の水しぶきを出すタイミングを計るカウンター
---@field CurrentPlayerNameState integer プレイヤーの現在の表示名の状態を示す：0. プレイヤー名, 1. Senko_san, 2. 仙狐さん
---@field PlayerNameState integer プレイヤーの表示名の状態を示す：0. プレイヤー名, 1. Senko_san, 2. 仙狐さん

ActionWheelClass = {}

MainPage = action_wheel:createPage("main_page")
ActionCount = 0
ActionCancelFunction = nil
IsOpenActionWheelPrev = false
ShakeSplashCount = 0
CurrentPlayerNameState = ConfigClass.DefaultName
PlayerNameState = ConfigClass.DefaultName

---アクションの色の有効色/無効色の切り替え
---@param actionNumber integer pageNumber内のアクションの番号
---@param enabled boolean 有効色か無効色か
function setActionEnabled(actionNumber, enabled)
	if enabled then
		MainPage:getAction(actionNumber):title(LanguageClass.getTranslate("action_wheel__main__action_"..actionNumber.."__title")):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1)
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

--ブルブル
function ActionWheelClass.bodyShake()
	ActionCancelFunction = function()
		General.setAnimations("STOP", "shake")
		ShakeSplashCount = 0
	end
	General.setAnimations("PLAY", "shake")
	sounds:playSound("minecraft:entity.wolf.shake", player:getPos(), 1, 1.5)
	FacePartsClass.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 20, true)
	if WetClass.WetCount > 0 and not player:isWet() then
		ShakeSplashCount = 20
		WetClass.WetCount = 20
	end
	ActionCount = 20
end

--ping関数
function pings.main_action1()
	runAction(function()
		ActionWheelClass.bodyShake()
	end, function()
		General.setAnimations("STOP", "shake")
		ShakeSplashCount = 0
	end, false)
end

function pings.main_action2_toggle()
	SitDownClass.sitDown()
end

function pings.main_action2_untoggle()
	SitDownClass.standUp()
end

function pings.main_action3()
	runAction(function ()
		EarpickClass.play()
		ActionCount = 200
	end, function ()
		EarpickClass.stop()
		ActionCount = 0
	end, false)
end

function pings.main_action4_name_change(nameID)
	NameplateClass.setName(nameID == 0 and player:getName() or (nameID == 1 and "Senko_san" or "仙狐さん"))
	CurrentPlayerNameState = nameID
end

events.TICK:register(function ()
	local displayName = PlayerNameState == 0 and player:getName() or (PlayerNameState == 1 and "Senko_san" or "仙狐さん")
	MainPage:getAction(4):title(LanguageClass.getTranslate("action_wheel__main__action_4__title").."§b"..displayName)
	setActionEnabled(1, ActionCount == 0)
	setActionEnabled(2, SitDownClass.CanSitDown)
	setActionEnabled(3, animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" and ActionCount == 0)
	local sitDownAction = MainPage:getAction(2)
	sitDownAction:toggled(SitDownClass.CanSitDown and sitDownAction:isToggled())
	if (HurtClass.Damaged ~= "NONE" and ActionCount > 0) or (animations["models.main"]["earpick"]:getPlayState() == "PLAYING" and animations["models.main"]["sit_down"]:getPlayState() ~= "PLAYING") then
		ActionCancelFunction();
		ActionCount = 0
	end
	local isOpenActionWheel = action_wheel:isEnabled()
	if not isOpenActionWheel and IsOpenActionWheelPrev then
		if PlayerNameState ~= CurrentPlayerNameState then
			pings.main_action4_name_change(PlayerNameState)
			print(LanguageClass.getTranslate("action_wheel__main__action_4__name_change_done_first")..displayName..LanguageClass.getTranslate("action_wheel__main__action_4__name_change_done_last"))
			sounds:playSound("minecraft:entity.player.levelup", player:getPos(), 1, 2)
		end
	end
	if ShakeSplashCount > 0 then
		if ShakeSplashCount % 5 == 0 then
			local playerPos = player:getPos()
			for _ = 1, math.min(avatar:getMaxParticles() / 4, 4) do
				particles:addParticle("minecraft:splash", playerPos.x + math.random() - 0.5, playerPos.y + math.random() + 0.5, playerPos.z + math.random() - 0.5)
			end
		end
		ShakeSplashCount = ShakeSplashCount - 1
	end
	ActionCount = ActionCount > 0 and ActionCount - 1 or ActionCount
	IsOpenActionWheelPrev = isOpenActionWheel
end)

--メインページのアクション設定
--アクション1. ブルブル
MainPage:newAction(1):item("water_bucket"):onLeftClick(function()
	pings.main_action1()
end)

--アクション2. おすわり（正座）
MainPage:newToggle(2):toggleColor(233 / 255, 160 / 255, 69 / 255):item("oak_stairs"):onToggle(function ()
	if SitDownClass.CanSitDown then
		pings.main_action2_toggle()
	else
		print(LanguageClass.getTranslate("action_wheel__main__action_2__unavailable"))
	end
end):onUntoggle(function ()
	pings.main_action2_untoggle()
end)

--アクション3. 耳かき
MainPage:newAction(3):item("feather"):onLeftClick(function ()
	if animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" then
		pings.main_action3()
	else
		print(LanguageClass.getTranslate("action_wheel__main__action_3__unavailable"))
	end
end)

--アクション4. プレイヤーの表示名変更
MainPage:newScroll(4):item("name_tag"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
	if direction == -1 then
		PlayerNameState = PlayerNameState == 2 and 0 or PlayerNameState + 1
	else
		PlayerNameState = PlayerNameState == 0 and 2 or PlayerNameState - 1
	end
end)

action_wheel:setPage(MainPage)

return ActionWheelClass