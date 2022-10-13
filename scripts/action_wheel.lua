---@class ActionWheelClass アクションホイールを制御するクラス
---@field MainPage table アクションホイールのメインページ
---@field ActionCount integer アクション再生中は0より大きくなるカウンター
---@field ActionCancelFunction function 現在再生中のアクションをキャンセルする処理
---@field IsOpenActionWheelPrev boolean 前チックにアクションホイールを開けていたかどうか
---@field ShakeSplashCount integer ブルブル時の水しぶきを出すタイミングを計るカウンター
---@field SweatCount integer 汗のタイミングを計るカウンター
---@field CurrentPlayerNameState integer プレイヤーの現在の表示名の状態を示す：0. プレイヤー名, 1. Senko_san, 2. 仙狐さん
---@field PlayerNameState integer プレイヤーの表示名の状態を示す：0. プレイヤー名, 1. Senko_san, 2. 仙狐さん

ActionWheelClass = {}

MainPages = {action_wheel:createPage(), action_wheel:createPage()}
ActionCount = 0
ActionCancelFunction = nil
IsOpenActionWheelPrev = false
ShakeSplashCount = 0
SweatCount = 0
CurrentCostumeState = ConfigClass.DefaultCostume
CostumeState = ConfigClass.DefaultCostume
CurrentPlayerNameState = ConfigClass.DefaultName
PlayerNameState = ConfigClass.DefaultName

---アニメーションが再生中かどうかを返す
---@param modelName string モデル名
---@param animationName string アニメーションが名
---@return boolean
function isAnimationPlaying(modelName, animationName)
	return animations[modelName][animationName]:getPlayState() == "PLAYING"
end

---アクションの色の有効色/無効色の切り替え
---@param pageNumber integer メインアクションのページ番号
---@param actionNumber integer pageNumber内のアクションの番号
---@param enabled boolean 有効色か無効色か
function setActionEnabled(pageNumber, actionNumber, enabled)
	if enabled then
		MainPages[pageNumber]:getAction(actionNumber):title(LanguageClass.getTranslate("action_wheel__main_"..pageNumber.."__action_"..actionNumber.."__title")):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1)
	else
		MainPages[pageNumber]:getAction(actionNumber):title("§7"..LanguageClass.getTranslate("action_wheel__main_"..pageNumber.."__action_"..actionNumber.."__title")):color(42 / 255, 42 / 255, 42 / 255):hoverColor(1, 85 / 255, 85 / 255)
	end
end

---アクションを実行する。
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
function pings.refuse_emote()
	General.setAnimations("PLAY", "refuse_emote")
	FacePartsClass.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 30, true)
	ActionCancelFunction = nil
	ActionCount = 30
	SweatCount = 30
	if host:isHost() then
		print(LanguageClass.getTranslate("action_wheel__refuse_action"))
	end
end

function pings.main1_action1_left()
	runAction(function ()
		BroomCleaningClass.play()
		ActionCount = 168
	end, function ()
		BroomCleaningClass.stop()
		ActionCount = 0
	end, false)
end

function pings.main1_action1_left_alt()
	runAction(function ()
		VacuumCleaningClass.play()
		ActionCount = 281
	end, function ()
		VacuumCleaningClass.stop()
		ActionCount = 0
	end, false)
end

function pings.main1_action1_right()
	runAction(function ()
		ClothCleaningClass.play()
		ActionCount = 198
	end, function ()
		ClothCleaningClass.stop()
		ActionCount = 0
	end, false)
end

function pings.main1_action2()
	runAction(function()
		ActionWheelClass.bodyShake()
	end, function()
		General.setAnimations("STOP", "shake")
		ShakeSplashCount = 0
	end, false)
end

function pings.main1_action3_toggle()
	runAction(function ()
		SitDownClass.sitDown()
	end, nil, true)
end

function pings.main1_action3_untoggle()
	SitDownClass.standUp()
end

function pings.main1_action4()
	runAction(function ()
		EarpickClass.play()
		ActionCount = 238
	end, function ()
		EarpickClass.stop()
		ActionCount = 0
	end, false)
end

function pings.main1_action5()
	runAction(function ()
		TeaTimeClass.play()
		ActionCount = 250
	end, function ()
		TeaTimeClass.stop()
		ActionCount = 0
	end, false)
end

function pings.main2_action1_custume_change(costumeID)
	if costumeID == 1 then
		CostumeClass.resetCostume()
	else
		CostumeClass.setCostume(string.upper(CostumeClass.CostumeList[costumeID]))
	end
	CurrentCostumeState = costumeID
end

function pings.main2_action2_name_change(nameID)
	NameplateClass.setName(nameID == 1 and player:getName() or (nameID == 2 and "Senko_san" or "仙狐さん"))
	CurrentPlayerNameState = nameID
end

events.TICK:register(function ()
	local costumeName = LanguageClass.getTranslate("costume__"..CostumeClass.CostumeList[CostumeState])
	MainPages[2]:getAction(1):title(LanguageClass.getTranslate("action_wheel__main_2__action_1__title").."§b"..costumeName)
	local displayName = PlayerNameState == 1 and player:getName() or (PlayerNameState == 2 and "Senko_san" or "仙狐さん")
	MainPages[2]:getAction(2):title(LanguageClass.getTranslate("action_wheel__main_2__action_2__title").."§b"..displayName)
	setActionEnabled(1, 1, ActionCount == 0 and BroomCleaningClass.CanBroomCleaning)
	setActionEnabled(1, 2, ActionCount == 0 and not WardenClass.WardenNearby)
	setActionEnabled(1, 3, ActionCount == 0 and SitDownClass.CanSitDown)
	for i = 4, 5 do
		setActionEnabled(1, i, isAnimationPlaying("models.main", "sit_down") and ActionCount == 0 and not WardenClass.WardenNearby)
	end
	local sitDownAction = MainPages[1]:getAction(3)
	sitDownAction:toggled((ActionCount == 0 or isAnimationPlaying("models.main", "earpick") or isAnimationPlaying("models.main", "tea_time") or (isAnimationPlaying("models.main", "sit_down") and isAnimationPlaying("models.main", "shake"))) and SitDownClass.CanSitDown and sitDownAction:isToggled())
	if (HurtClass.Damaged ~= "NONE" and ActionCount > 0 and WardenClass.WardenNearby) or ((isAnimationPlaying("models.main", "earpick") or isAnimationPlaying("models.main", "tea_time")) and not isAnimationPlaying("models.main", "sit_down")) or ((isAnimationPlaying("models.main", "broom_cleaning") or isAnimationPlaying("models.main", "vacuum_cleaning") or isAnimationPlaying("models.main", "cloth_cleaning")) and not BroomCleaningClass.CanBroomCleaning) then
		ActionCancelFunction();
		ActionCount = 0
	end
	local isOpenActionWheel = action_wheel:isEnabled()
	if not isOpenActionWheel and IsOpenActionWheelPrev then
		if CostumeState ~= CurrentCostumeState then
			pings.main2_action1_custume_change(CostumeState)
			if host:isHost() then
				sounds:playSound("minecraft:item.armor.equip_leather", player:getPos())
				print(LanguageClass.getTranslate("action_wheel__main_2__action_1__done_first")..costumeName..LanguageClass.getTranslate("action_wheel__main_2__action_1__done_last"))
			end
		end
		if PlayerNameState ~= CurrentPlayerNameState then
			pings.main2_action2_name_change(PlayerNameState)
			if host:isHost() then
				sounds:playSound("minecraft:ui.cartography_table.take_result", player:getPos(), 1, 1)
				print(LanguageClass.getTranslate("action_wheel__main_2__action_2__done_first")..displayName..LanguageClass.getTranslate("action_wheel__main_2__action_2__done_last"))
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
--アクション1-1. お掃除
MainPages[1]:newAction(1):item("amethyst_shard"):onLeftClick(function ()
	if ActionCount == 0 then
		if BroomCleaningClass.CanBroomCleaning then
			if math.random() > 0.9 then
				pings.main1_action1_left_alt()
			else
				pings.main1_action1_left()
			end
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_1__unavailable"))
		end
	end
end):onRightClick(function ()
	if ActionCount == 0 then
		if BroomCleaningClass.CanBroomCleaning then
			pings.main1_action1_right()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_1__unavailable"))
		end
	end
end)

--アクション1-2. ブルブル
MainPages[1]:newAction(2):item("water_bucket"):onLeftClick(function()
	if ActionCount == 0 then
		if WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			pings.main1_action2()
		end
	end
end)

--アクション1-3. おすわり（正座）
MainPages[1]:newToggle(3):toggleColor(233 / 255, 160 / 255, 69 / 255):item("oak_stairs"):onToggle(function ()
	if ActionCount == 0 then
		if SitDownClass.CanSitDown then
			pings.main1_action3_toggle()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_3__unavailable"))
		end
	end
end):onUntoggle(function ()
	pings.main1_action3_untoggle()
end)

--アクション1-4. 耳かき
MainPages[1]:newAction(4):item("feather"):onLeftClick(function ()
	if ActionCount == 0 then
		if isAnimationPlaying("models.main", "sit_down") then
			pings.main1_action4()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_4__unavailable"))
		end
	end
end)

--アクション1-5. ティータイム
MainPages[1]:newAction(5):item("flower_pot"):onLeftClick(function ()
	if ActionCount == 0 then
		if isAnimationPlaying("models.main", "sit_down") then
			pings.main1_action5()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_5__unavailable"))
		end
	end
end)

--アクション2-1. 着替え
MainPages[2]:newScroll(1):item("leather_chestplate"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
	if direction == -1 then
		CostumeState = CostumeState == #CostumeClass.CostumeList and 1 or CostumeState + 1
	else
		CostumeState = CostumeState == 1 and #CostumeClass.CostumeList or CostumeState - 1
	end
end)

--アクション2-2. プレイヤーの表示名変更
MainPages[2]:newScroll(2):item("name_tag"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
	if direction == -1 then
		PlayerNameState = PlayerNameState == 3 and 1 or PlayerNameState + 1
	else
		PlayerNameState = PlayerNameState == 1 and 3 or PlayerNameState - 1
	end
end)

--アクション8（共通）. ページ切り替え
for index, mainPage in ipairs(MainPages) do
	mainPage:newScroll(8):title(LanguageClass.getTranslate("action_wheel__main__action_8__title")..index.."/"..#MainPages):item("arrow"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
		if MainPages[index - direction] then
			action_wheel:setPage(MainPages[index - direction])
		elseif index == 1 then
			action_wheel:setPage(MainPages[#MainPages])
		else
			action_wheel:setPage(MainPages[1])
		end
	end)
end

action_wheel:setPage(MainPages[1])

return ActionWheelClass