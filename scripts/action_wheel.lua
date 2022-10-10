---@class ActionWheelClass アクションホイールを制御するクラス
---@field MainPage Page アクションホイールのメインページ
---@field ActionCount integer アクション再生中は0より大きくなるカウンター
---@field ActionCancelFunction function 現在再生中のアクションをキャンセルする処理
---@field IsOpenActionWheelPrev boolean 前チックにアクションホイールを開けていたかどうか
---@field ShakeSplashCount integer ブルブル時の水しぶきを出すタイミングを計るカウンター
---@field SweatCount integer 汗のタイミングを計るカウンター
---@field CurrentPlayerNameState integer プレイヤーの現在の表示名の状態を示す：0. プレイヤー名, 1. Senko_san, 2. 仙狐さん
---@field PlayerNameState integer プレイヤーの表示名の状態を示す：0. プレイヤー名, 1. Senko_san, 2. 仙狐さん

ActionWheelClass = {}

MainPage = action_wheel:createPage("main_page")
ActionCount = 0
ActionCancelFunction = nil
IsOpenActionWheelPrev = false
ShakeSplashCount = 0
SweatCount = 0
CurrentCostumeState = ConfigClass.DefaultCostume
CostumeState = ConfigClass.DefaultCostume
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
		if WardenClass.WardenNearby then
			General.setAnimations("PLAY", "refuse_emote")
			FacePartsClass.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 30, true)
			ActionCancelFunction = nil
			ActionCount = 30
			SweatCount = 30
		else
			action()
			ActionCancelFunction = actionCancelFunction
		end
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
function pings.main_action1_left()
	runAction(function ()
		if BroomCleaningClass.CanBroomCleaning then
			BroomCleaningClass.play()
			ActionCount = 168
		elseif host:isHost() then
			print(LanguageClass.getTranslate("action_wheel__main__action_1__unavailable"))
		end
	end, function ()
		BroomCleaningClass.stop()
		ActionCount = 0
	end, false)
end

function pings.main_action1_right()
	runAction(function ()
		if BroomCleaningClass.CanBroomCleaning then
			ClothCleaningClass.play()
			ActionCount = 198
		elseif host:isHost() then
			print(LanguageClass.getTranslate("action_wheel__main__action_1__unavailable"))
		end
	end, function ()
		ClothCleaningClass.stop()
		ActionCount = 0
	end, false)
end

function pings.main_action2()
	runAction(function()
		ActionWheelClass.bodyShake()
	end, function()
		General.setAnimations("STOP", "shake")
		ShakeSplashCount = 0
	end, false)
end

function pings.main_action3_toggle()
	runAction(function ()
		if SitDownClass.CanSitDown then
			SitDownClass.sitDown()
		elseif host:isHost() then
			print(LanguageClass.getTranslate("action_wheel__main__action_3__unavailable"))
		end
	end, nil, true)
end

function pings.main_action3_untoggle()
	SitDownClass.standUp()
end

function pings.main_action4()
	runAction(function ()
		if animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" then
			EarpickClass.play()
			ActionCount = 238
		elseif host:isHost() then
			print(LanguageClass.getTranslate("action_wheel__main__action_4__unavailable"))
		end
	end, function ()
		EarpickClass.stop()
		ActionCount = 0
	end, false)
end

function pings.main_action5_custume_change(costumeID)
	if costumeID == 1 then
		CostumeClass.resetCostume()
	else
		CostumeClass.setCostume(string.upper(CostumeClass.CostumeList[costumeID]))
	end
	CurrentCostumeState = costumeID
end

function pings.main_action6_name_change(nameID)
	NameplateClass.setName(nameID == 1 and player:getName() or (nameID == 2 and "Senko_san" or "仙狐さん"))
	CurrentPlayerNameState = nameID
end

events.TICK:register(function ()
	local costumeName = LanguageClass.getTranslate("costume__"..CostumeClass.CostumeList[CostumeState])
	MainPage:getAction(5):title(LanguageClass.getTranslate("action_wheel__main__action_5__title").."§b"..costumeName)
	local displayName = PlayerNameState == 1 and player:getName() or (PlayerNameState == 2 and "Senko_san" or "仙狐さん")
	MainPage:getAction(6):title(LanguageClass.getTranslate("action_wheel__main__action_6__title").."§b"..displayName)
	setActionEnabled(1, ActionCount == 0 and BroomCleaningClass.CanBroomCleaning)
	setActionEnabled(2, ActionCount == 0 and not WardenClass.WardenNearby)
	setActionEnabled(3, SitDownClass.CanSitDown)
	setActionEnabled(4, animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" and ActionCount == 0 and not WardenClass.WardenNearby)
	local sitDownAction = MainPage:getAction(3)
	sitDownAction:toggled(SitDownClass.CanSitDown and sitDownAction:isToggled())
	if (HurtClass.Damaged ~= "NONE" and ActionCount > 0 and WardenClass.WardenNearby) or (animations["models.main"]["earpick"]:getPlayState() == "PLAYING" and animations["models.main"]["sit_down"]:getPlayState() ~= "PLAYING") or ((animations["models.main"]["broom_cleaning"]:getPlayState() == "PLAYING" or animations["models.main"]["cloth_cleaning"]:getPlayState() == "PLAYING") and not BroomCleaningClass.CanBroomCleaning) then
		ActionCancelFunction();
		ActionCount = 0
	end
	local isOpenActionWheel = action_wheel:isEnabled()
	if not isOpenActionWheel and IsOpenActionWheelPrev then
		if CostumeState ~= CurrentCostumeState then
			pings.main_action5_custume_change(CostumeState)
			if host:isHost() then
				sounds:playSound("minecraft:item.armor.equip_leather", player:getPos())
				print(LanguageClass.getTranslate("action_wheel__main__action_5__name_change_done_first")..costumeName..LanguageClass.getTranslate("action_wheel__main__action_5__name_change_done_last"))
			end
		end
		if PlayerNameState ~= CurrentPlayerNameState then
			pings.main_action6_name_change(PlayerNameState)
			if host:isHost() then
				sounds:playSound("minecraft:entity.player.levelup", player:getPos(), 1, 2)
				print(LanguageClass.getTranslate("action_wheel__main__action_6__name_change_done_first")..displayName..LanguageClass.getTranslate("action_wheel__main__action_6__name_change_done_last"))
			end
		end
	end
	if ShakeSplashCount > 0 then
		if ShakeSplashCount % 5 == 0 then
			for _ = 1, math.min(avatar:getMaxParticles() / 4, 4) do
				particles:addParticle("minecraft:splash", player:getPos():add(math.random() - 0.5, math.random() + 0.5, math.random() - 0.5))
			end
		end
		ShakeSplashCount = ShakeSplashCount - 1
	end
	if SweatCount > 0 then
		if SweatCount % 5 == 0 then
			for _ = 1, math.min(avatar:getMaxParticles() / 4, 4) do
				particles:addParticle("minecraft:splash", player:getPos():add(0, 2, 0))
			end
		end
		SweatCount = SweatCount - 1
	end
	ActionCount = ActionCount > 0 and ActionCount - 1 or ActionCount
	IsOpenActionWheelPrev = isOpenActionWheel
end)

--メインページのアクション設定
--アクション1. お掃除
MainPage:newAction(1):item("amethyst_shard"):onLeftClick(function ()
	pings.main_action1_left()
end):onRightClick(function ()
	pings.main_action1_right()
end)

--アクション2. ブルブル
MainPage:newAction(2):item("water_bucket"):onLeftClick(function()
	pings.main_action2()
end)

--アクション3. おすわり（正座）
MainPage:newToggle(3):toggleColor(233 / 255, 160 / 255, 69 / 255):item("oak_stairs"):onToggle(function ()
	pings.main_action3_toggle()
end):onUntoggle(function ()
	pings.main_action3_untoggle()
end)

--アクション4. 耳かき
MainPage:newAction(4):item("feather"):onLeftClick(function ()
	pings.main_action4()
end)

MainPage:newScroll(5):item("leather_chestplate"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
	if direction == -1 then
		CostumeState = CostumeState == #CostumeClass.CostumeList and 1 or CostumeState + 1
	else
		CostumeState = CostumeState == 1 and #CostumeClass.CostumeList or CostumeState - 1
	end
end)

--アクション6. プレイヤーの表示名変更
MainPage:newScroll(6):item("name_tag"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
	if direction == -1 then
		PlayerNameState = PlayerNameState == 3 and 1 or PlayerNameState + 1
	else
		PlayerNameState = PlayerNameState == 1 and 3 or PlayerNameState - 1
	end
end)

action_wheel:setPage(MainPage)

return ActionWheelClass