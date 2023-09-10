---@class ActionWheel アクションホイールを制御するクラス
---@field Pages table<Page> アクションホイールのページのリスト
---@field CurrentPage integer アクションホイールの現在のページ
---@field IsAnimationPlaying boolean アニメーションが再生中かどうか
---@field IsOpenActionWheelPrev boolean 前チックにアクションホイールを開けていたかどうか
---@field CurrentCostumeState integer プレイヤーの現在のコスチュームの状態を示す：1. いつもの服, 2. 変装服, 3. メイド服A, 4. メイド服B, 5. 水着, 6. チアリーダーの服, 7. 清めの服, 8. 割烹着
---@field CostumeState integer プレイヤーのコスチュームの状態を示す：1. いつもの服, 2. 変装服, 3. メイド服A, 4. メイド服B, 5. 水着, 6. チアリーダーの服, 7. 清めの服, 8. 割烹着
---@field CurrentPlayerNameState integer プレイヤーの現在の表示名の状態を示す：1. プレイヤー名, 2. Senko, 3. 仙狐, 4. Senko_san, 5. 仙狐さん, 6. Sen, 7. 仙, 8. セン
---@field PlayerNameState integer プレイヤーの表示名の状態を示す：1. プレイヤー名, 2. Senko, 3. 仙狐, 4. Senko_san, 5. 仙狐さん, 6. Sen, 7. 仙, 8. セン
---@field CurrentSKullState integer 現在の頭モデルの状態を示す：1. デフォルト, 2. フィギュアA, 3. フィギュアB
---@field SkullState integer 頭モデルの状態を示す：1. デフォルト, 2. フィギュアA, 3. フィギュアB
ActionWheel = {
	Pages = {},
	CurrentPage = 1,
	IsAnimationPlaying = false,
	IsOpenActionWheelPrev = false,
	CurrentCostumeState = Config.loadConfig("costume", 1),
	CostumeState = Config.loadConfig("costume", 1),
	CurrentPlayerNameState = Config.loadConfig("name", 1),
	PlayerNameState = Config.loadConfig("name", 1),
	CurrentSkullState = Config.loadConfig("skull", 1),
	SkullState = Config.loadConfig("skull", 1),

	---アクションの色の有効色/無効色の切り替え
	---@param pageNumber integer メインアクションのページ番号
	---@param actionNumber integer pageNumber内のアクションの番号
	---@param enabled boolean 有効色か無効色か
	setActionEnabled = function(pageNumber, actionNumber, enabled)
		if enabled then
			ActionWheel.Pages[pageNumber]:getAction(actionNumber):title(Language.getTranslate("action_wheel__main_"..pageNumber.."__action_"..actionNumber.."__title")):color(0.91, 0.67, 0.27):hoverColor(1, 1, 1)
		else
			ActionWheel.Pages[pageNumber]:getAction(actionNumber):title("§7"..Language.getTranslate("action_wheel__main_"..pageNumber.."__action_"..actionNumber.."__title")):color(0.16, 0.16, 0.16):hoverColor(1, 0.33, 0.33)
		end
	end,

	---衣装変更のアクションの名称を変更する。
	setCostumeChangeActionTitle = function ()
		if ActionWheel.CostumeState == ActionWheel.CurrentCostumeState then
			ActionWheel.Pages[4]:getAction(1):title(Language.getTranslate("action_wheel__main_4__action_1__title").."§b"..Language.getTranslate("costume__"..Costume.CostumeList[ActionWheel.CostumeState]))
		else
			ActionWheel.Pages[4]:getAction(1):title(Language.getTranslate("action_wheel__main_4__action_1__title").."§b"..Language.getTranslate("costume__"..Costume.CostumeList[ActionWheel.CostumeState]).."\n§7"..Language.getTranslate("action_wheel__close_to_confirm"))
		end
	end,

	---名前変更のアクションの名称を変更する。
	setNameChangeActionTitle = function ()
		if ActionWheel.PlayerNameState == ActionWheel.CurrentPlayerNameState then
			ActionWheel.Pages[4]:getAction(2):title(Language.getTranslate("action_wheel__main_4__action_2__title").."§b"..Nameplate.NameList[ActionWheel.PlayerNameState])
		else
			ActionWheel.Pages[4]:getAction(2):title(Language.getTranslate("action_wheel__main_4__action_2__title").."§b"..Nameplate.NameList[ActionWheel.PlayerNameState].."\n§7"..Language.getTranslate("action_wheel__close_to_confirm"))
		end
	end,

	---頭変更のアクションの名称を変更する。
	setSkullChangeActionTitle = function ()
		if ActionWheel.SkullState == ActionWheel.CurrentSkullState then
			ActionWheel.Pages[4]:getAction(3):title(Language.getTranslate("action_wheel__main_4__action_3__title").."§b"..Language.getTranslate("skull__"..Skull.SkullList[ActionWheel.SkullState]))
		else
			ActionWheel.Pages[4]:getAction(3):title(Language.getTranslate("action_wheel__main_4__action_3__title").."§b"..Language.getTranslate("skull__"..Skull.SkullList[ActionWheel.SkullState]).."\n§7"..Language.getTranslate("action_wheel__close_to_confirm"))
		end
	end,

	---こたつアニメーションのトグルを切り替える。
	---@param toggleValue boolean 切り替える値
	setKotatsuToggle = function (toggleValue)
		if host:isHost() then
			ActionWheel.Pages[1]:getAction(7):toggled(toggleValue)
		end
	end,

	---立ち上がった時に呼ばれる関数（SitDownから呼び出し）
	onStandUp = function ()
		if host:isHost() then
			ActionWheel.Pages[2]:getAction(1):toggled(false)
		end
	end,

	---ポーズのトグルをオフにする（PhotoPoseから呼び出し）
	---@param poseID integer 対象のポーズID
	untogglePose = function (poseID)
		if host:isHost() then
			ActionWheel.Pages[3]:getAction(poseID):toggled(false)
		end
	end
}

--ping関数
function pings.refuse_emote()
	RefuseEmote:play()
end

function pings.main1_action1_left()
	Smile:play(false)
end

function pings.main1_action1_right()
	Smile:play(true)
end

function pings.main1_action2()
	ShakeBody:play(false)
end

function pings.main1_action3_left()
	BroomCleaning:play()
end

function pings.main1_action3_left_alt()
	VacuumCleaning:play()
end

function pings.main1_action3_right()
	ClothCleaning:play()
end

function pings.main1_action4()
	HairCut:play()
end

function pings.main1_action5()
	FoxJump:play()
end

function pings.main1_action6()
	TailBrush:play()
end

function pings.main1_action7_toggle()
	Kotatsu:play()
end

function pings.main1_action7_untoggle()
	Kotatsu:stop()
end

function pings.main2_action1_toggle()
	SitDown:play()
end

function pings.main2_action1_untoggle()
	SitDown:stop()
end

function pings.main2_action2()
	TailCuddling:play()
end

function pings.main2_action3()
	EarCuddling:play()
end

function pings.main2_action4()
	Earpick:play()
end

function pings.main2_action5()
	TeaTime:play()
end

function pings.main2_action6()
	Massage:play()
end

function pings.setPose(poseID)
	if PhotoPose.CurrentPose == poseID then
		PhotoPose.stopPose()
	else
		PhotoPose.setPose(poseID)
	end
end

function pings.main4_action1(costumeID)
	if costumeID == 1 then
		Costume.resetCostume()
	else
		Costume.setCostume(string.upper(Costume.CostumeList[costumeID]))
	end
	ActionWheel.CurrentCostumeState = costumeID
	if host:isHost() then
		ActionWheel.setCostumeChangeActionTitle()
	end
end

function pings.main4_action2(nameID)
	nameplate.ALL:setText(Nameplate.NameList[nameID])
	ActionWheel.CurrentPlayerNameState = nameID
	if host:isHost() then
		ActionWheel.setNameChangeActionTitle()
	end
end

function pings.main4_action3(skullID)
	Skull.CurrentSkull = skullID
	ActionWheel.CurrentSkullState = skullID
	if host:isHost() then
		ActionWheel.setSkullChangeActionTitle()
	end
end

function pings.main4_action4_toggle()
	Wet.AutoShake = true
end

function pings.main4_action4_untoggle()
	Wet.AutoShake = false
end

function pings.main4_action5_toggle()
	Armor.ShowArmor = true
end

function pings.main4_action5_untoggle()
	Armor.ShowArmor = false
end

function pings.main4_action7_toggle()
	Umbrella.Sound = true
end

function pings.main4_action7_untoggle()
	Umbrella.Sound = false
end

function pings.main5_action1_toggle()
	Umbrella.AlwaysUse = true
end

function pings.main5_action1_untoggle()
	Umbrella.AlwaysUse = false
end

events.TICK:register(function ()
	if host:isHost() then
		local isOpenActionWheel = action_wheel:isEnabled()
		if isOpenActionWheel then
			if ActionWheel.CurrentPage <= 2 then
				local animationClasses = ActionWheel.CurrentPage == 1 and {Smile, ShakeBody, BroomCleaning, HairCut, FoxJump, TailBrush, Kotatsu} or {SitDown, TailCuddling, EarCuddling, Earpick, TeaTime, Massage}
				for actionIndex, actionClass in ipairs(animationClasses) do
					ActionWheel.setActionEnabled(ActionWheel.CurrentPage, actionIndex, not ActionWheel.IsAnimationPlaying and actionClass:checkAction())
				end
				if ActionWheel.CurrentPage == 1 then
					if Wet.WetCount > 0 then
						ActionWheel.Pages[1]:getAction(2):item("water_bucket")
					else
						ActionWheel.Pages[1]:getAction(2):item("bucket")
					end
				end
			elseif  ActionWheel.CurrentPage == 3 then
				for i = 1, 7 do
					ActionWheel.setActionEnabled(3, i, PhotoPose.check())
				end
			end
		end
		if not isOpenActionWheel and ActionWheel.IsOpenActionWheelPrev then
			if ActionWheel.CostumeState ~= ActionWheel.CurrentCostumeState then
				pings.main4_action1(ActionWheel.CostumeState)
				Config.saveConfig("costume", ActionWheel.CostumeState)
				sounds:playSound("minecraft:item.armor.equip_leather", player:getPos())
				print(Language.getTranslate("action_wheel__main_4__action_1__done_first")..Language.getTranslate("costume__"..Costume.CostumeList[ActionWheel.CostumeState])..Language.getTranslate("action_wheel__main_4__action_1__done_last"))
			end
			if ActionWheel.PlayerNameState ~= ActionWheel.CurrentPlayerNameState then
				pings.main4_action2(ActionWheel.PlayerNameState)
				Config.saveConfig("name", ActionWheel.PlayerNameState)
				sounds:playSound("minecraft:ui.cartography_table.take_result", player:getPos())
				print(Language.getTranslate("action_wheel__main_4__action_2__done_first")..Nameplate.NameList[ActionWheel.PlayerNameState]..Language.getTranslate("action_wheel__main_4__action_2__done_last"))
			end
			if ActionWheel.SkullState ~= ActionWheel.CurrentSkullState then
				pings.main4_action3(ActionWheel.SkullState)
				Config.saveConfig("skull", ActionWheel.SkullState)
				sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
				print(Language.getTranslate("action_wheel__main_4__action_3__done_first")..Language.getTranslate("skull__"..Skull.SkullList[ActionWheel.SkullState])..Language.getTranslate("action_wheel__main_4__action_3__done_last"))
			end
		end
		ActionWheel.IsOpenActionWheelPrev = isOpenActionWheel
	end
end)

if host:isHost() then
	for _ = 1, 5 do
		table.insert(ActionWheel.Pages, action_wheel:newPage())
	end

	--メインページのアクション設定
	--アクション1-1. にっこり
	ActionWheel.Pages[1]:newAction(1):item("emerald"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if Smile:checkAction() then
				pings.main1_action1_left()
			elseif Warden.WardenNearby then
				pings.refuse_emote()
			end
		end
	end):onRightClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if Warden.WardenNearby then
				pings.refuse_emote()
			else
				pings.main1_action1_right()
			end
		end
	end)

	--アクション1-2. ブルブル
	ActionWheel.Pages[1]:newAction(2):item("bucket"):onLeftClick(function()
		if not ActionWheel.IsAnimationPlaying then
			if ShakeBody:checkAction() then
				pings.main1_action2()
			elseif Warden.WardenNearby then
				pings.refuse_emote()
			else
				print(Language.getTranslate("action_wheel__main_1__action_2__unavailable"))
			end
		end
	end)

	--アクション1-3. お掃除
	ActionWheel.Pages[1]:newAction(3):item("amethyst_shard"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if BroomCleaning:checkAction() then
				if math.random() > 0.9 then
					pings.main1_action3_left_alt()
				else
					pings.main1_action3_left()
				end
			elseif Warden.WardenNearby then
				pings.refuse_emote()
			else
				print(Language.getTranslate("action_wheel__main_1__action_3__unavailable"))
			end
		end
	end):onRightClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if BroomCleaning:checkAction() then
				pings.main1_action3_right()
			elseif Warden.WardenNearby then
				pings.refuse_emote()
			else
				print(Language.getTranslate("action_wheel__main_1__action_3__unavailable"))
			end
		end
	end)

	--アクション1-4. 散髪
	ActionWheel.Pages[1]:newAction(4):item("shears"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if BroomCleaning:checkAction() then
				pings.main1_action4()
			elseif Warden.WardenNearby then
				pings.refuse_emote()
			else
				print(Language.getTranslate("action_wheel__main_1__action_4__unavailable"))
			end
		end
	end)

	--アクション1-5. キツネジャンプ
	ActionWheel.Pages[1]:newAction(5):item("snow_block"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if FoxJump:checkAction() then
				pings.main1_action5()
			elseif Warden.WardenNearby then
				pings.refuse_emote()
			else
				print(Language.getTranslate("action_wheel__main_1__action_5__unavailable"))
			end
		end
	end)

	--アクション1-6. 尻尾の手入れ
	ActionWheel.Pages[1]:newAction(6):item("sponge"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if TailBrush:checkAction() then
				pings.main1_action6()
			elseif Warden.WardenNearby then
				pings.refuse_emote()
			else
				print(Language.getTranslate("action_wheel__main_1__action_6__unavailable"))
			end
		end
	end)

	--アクション1-7. こたつ
	ActionWheel.Pages[1]:newAction(7):toggleColor(0.91, 0.67, 0.27):item("campfire"):onToggle(function (_, action)
		if not ActionWheel.IsAnimationPlaying then
			if Kotatsu:checkAction() then
				pings.main1_action7_toggle()
			else
				if Warden.WardenNearby then
					pings.refuse_emote()
				else
					print(Language.getTranslate("action_wheel__main_1__action_7__unavailable"))
				end
				action:toggled(false)
			end
		else
			action:toggled(false)
		end
	end):onUntoggle(function ()
		pings.main1_action7_untoggle()
	end)

	--アクション2-1. おすわり（正座）
	ActionWheel.Pages[2]:newAction(1):toggleColor(0.91, 0.67, 0.27):item("oak_stairs"):onToggle(function (_, action)
		if not ActionWheel.IsAnimationPlaying then
			if SitDown:checkAction() then
				pings.main2_action1_toggle()
			else
				if Warden.WardenNearby then
					pings.refuse_emote()
				else
					print(Language.getTranslate("action_wheel__main_2__action_1__unavailable"))
				end
				action:toggled(false)
			end
		else
			action:toggled(false)
		end
	end):onUntoggle(function ()
		pings.main2_action1_untoggle()
	end)

	--アクション2-2. 尻尾モフモフ
	ActionWheel.Pages[2]:newAction(2):item("yellow_wool"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if TailCuddling:checkAction() then
				pings.main2_action2()
			elseif Warden.WardenNearby then
				pings.refuse_emote()
			else
				print(Language.getTranslate("action_wheel__main_2__action_2__unavailable"))
			end
		end
	end)

	--アクション2-3. お耳モフモフ
	ActionWheel.Pages[2]:newAction(3):item("white_wool"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if EarCuddling:checkAction() then
				pings.main2_action3()
			elseif Warden.WardenNearby then
				pings.refuse_emote()
			else
				print(Language.getTranslate("action_wheel__main_2__action_3__unavailable"))
			end
		end
	end)

	--アクション2-4. 耳かき
	ActionWheel.Pages[2]:newAction(4):item("feather"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if SitDown.IsAnimationPlaying then
				pings.main2_action4()
			elseif Warden.WardenNearby then
				pings.refuse_emote()
			else
				print(Language.getTranslate("action_wheel__main_2__action_4__unavailable"))
			end
		end
	end)

	--アクション2-5. ティータイム
	ActionWheel.Pages[2]:newAction(5):item("flower_pot"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if SitDown.IsAnimationPlaying then
				pings.main2_action5()
			elseif Warden.WardenNearby then
				pings.refuse_emote()
			else
				print(Language.getTranslate("action_wheel__main_2__action_5__unavailable"))
			end
		end
	end)

	--アクション2-6. マッサージ
	ActionWheel.Pages[2]:newAction(6):item("yellow_bed"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if SitDown.IsAnimationPlaying then
				pings.main2_action6()
			elseif Warden.WardenNearby then
				pings.refuse_emote()
			else
				print(Language.getTranslate("action_wheel__main_2__action_6__unavailable"))
			end
		end
	end)

	local function poseToggle(action, index)
		if not ActionWheel.IsAnimationPlaying then
			if PhotoPose.check() then
				pings.setPose(index)
			else
				if Warden.WardenNearby then
					pings.refuse_emote()
				else
					print(Language.getTranslate("action_wheel__main_3__action__unavailable"))
				end
				action:toggled(not action:isToggled())
			end
		else
			action:toggled(not action:isToggled())
		end
	end

	--アクション3-x. 撮影用ポーズ
	for i = 1, 7 do
		ActionWheel.Pages[3]:newAction(i):item("armor_stand"):toggleColor(255, 255, 0.33):onToggle(function (_, action)
		poseToggle(action, i)
		end):onUntoggle(function (_, action)
			poseToggle(action, i)
		end)
	end

	--アクション4-1. 着替え
	ActionWheel.Pages[4]:newAction(1):item("leather_chestplate"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onScroll(function (direction)
		if direction < 0 then
			ActionWheel.CostumeState = ActionWheel.CostumeState == #Costume.CostumeList and 1 or ActionWheel.CostumeState + 1
		else
			ActionWheel.CostumeState = ActionWheel.CostumeState == 1 and #Costume.CostumeList or ActionWheel.CostumeState - 1
		end
		ActionWheel.setCostumeChangeActionTitle()
	end):onLeftClick(function ()
		ActionWheel.CostumeState = ActionWheel.CurrentCostumeState
		ActionWheel.setCostumeChangeActionTitle()
	end):onRightClick(function ()
		ActionWheel.CostumeState = 1
		ActionWheel.setCostumeChangeActionTitle()
	end)

	--アクション4-2. プレイヤーの表示名変更
	ActionWheel.Pages[4]:newAction(2):item("name_tag"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onScroll(function (direction)
		if direction < 0 then
			ActionWheel.PlayerNameState = ActionWheel.PlayerNameState == #Nameplate.NameList and 1 or ActionWheel.PlayerNameState + 1
		else
			ActionWheel.PlayerNameState = ActionWheel.PlayerNameState == 1 and #Nameplate.NameList or ActionWheel.PlayerNameState - 1
		end
		ActionWheel.setNameChangeActionTitle()
	end):onLeftClick(function ()
		ActionWheel.PlayerNameState = ActionWheel.CurrentPlayerNameState
		ActionWheel.setNameChangeActionTitle()
	end):onRightClick(function ()
		ActionWheel.PlayerNameState = 1
		ActionWheel.setNameChangeActionTitle()
	end)

	---アクション4-3. プレイヤーの頭のタイプ変更
	ActionWheel.Pages[4]:newAction(3):item("player_head{SkullOwner: \""..player:getName().."\"}"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onScroll(function (direction)
		if direction < 0 then
			ActionWheel.SkullState = ActionWheel.SkullState == #Skull.SkullList and 1 or ActionWheel.SkullState + 1
		else
			ActionWheel.SkullState = ActionWheel.SkullState == 1 and #Skull.SkullList or ActionWheel.SkullState - 1
		end
		ActionWheel.setSkullChangeActionTitle()
	end):onLeftClick(function ()
		ActionWheel.SkullState = ActionWheel.CurrentSkullState
		ActionWheel.setSkullChangeActionTitle()
	end):onRightClick(function ()
		ActionWheel.SkullState = 1
		ActionWheel.setSkullChangeActionTitle()
	end)

	--アクション4-4. 自動ブルブル
	ActionWheel.Pages[4]:newAction(4):title(Language.getTranslate("action_wheel__main_4__action_4__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__main_4__action_4__title")..Language.getTranslate("action_wheel__toggle_on")):item("water_bucket"):color(0.67, 0, 0):hoverColor(1, 0.33, 0.33):toggleColor(0, 0.67, 0):onToggle(function (_, action)
		pings.main4_action4_toggle()
		action:hoverColor(0.33, 1, 0.33)
		Config.saveConfig("autoShake", true)
	end):onUntoggle(function (_, action)
		pings.main4_action4_untoggle()
		action:hoverColor(1, 0.33, 0.33)
		Config.saveConfig("autoShake", false)
	end)
	if Config.loadConfig("autoShake", true) then
		local action = ActionWheel.Pages[4]:getAction(4)
		action:toggled(true)
		action:hoverColor(0.33, 1, 0.33)
	end

	--アクション4-5. 防具の非表示
	ActionWheel.Pages[4]:newAction(5):title(Language.getTranslate("action_wheel__main_4__action_5__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__main_4__action_5__title")..Language.getTranslate("action_wheel__toggle_on")):item("iron_chestplate"):color(0.67, 0, 0):hoverColor(1, 0.33, 0.33):toggleColor(0, 0.67, 0):onToggle(function (_, action)
		pings.main4_action5_toggle()
		action:hoverColor(0.33, 1, 0.33)
		Config.saveConfig("showArmor", true)
	end):onUntoggle(function (_, action)
		pings.main4_action5_untoggle()
		action:hoverColor(1, 0.33, 0.33)
		Config.saveConfig("showArmor", false)
	end)
	if Config.loadConfig("showArmor", false) then
		local action = ActionWheel.Pages[4]:getAction(5)
		action:toggled(true)
		action:hoverColor(0.33, 1, 0.33)
	end

	--アクション4-6. 一人称視点での狐火の表示の切り替え
	ActionWheel.Pages[4]:newAction(6):title(Language.getTranslate("action_wheel__main_4__action_6__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__main_4__action_6__title")..Language.getTranslate("action_wheel__toggle_on")):item("soul_torch"):color(0.67, 0, 0):hoverColor(1, 0.33, 0.33):toggleColor(0, 0.67, 0):onToggle(function (_, action)
		FoxFire.FoxFireInFirstPerson = true
		action:hoverColor(0.33, 1, 0.33)
		Config.saveConfig("foxFireInFirstPerson", true)
	end):onUntoggle(function (_, action)
		FoxFire.FoxFireInFirstPerson = false
		action:hoverColor(1, 0.33, 0.33)
		Config.saveConfig("foxFireInFirstPerson", false)
	end)
	if Config.loadConfig("foxFireInFirstPerson", true) then
		local action = ActionWheel.Pages[4]:getAction(6)
		action:toggled(true)
		action:hoverColor(0.33, 1, 0.33)
	end

	--アクション4-7. 傘の開閉音
	ActionWheel.Pages[4]:newAction(7):title(Language.getTranslate("action_wheel__main_4__action_7__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__main_4__action_7__title")..Language.getTranslate("action_wheel__toggle_on")):item("note_block"):color(0.67, 0, 0):hoverColor(1, 0.33, 0.33):toggleColor(0, 0.67, 0):onToggle(function (_, action)
		pings.main4_action7_toggle()
		action:hoverColor(0.33, 1, 0.33)
		Config.saveConfig("umbrellaSound", true)
	end):onUntoggle(function (_, action)
		pings.main4_action7_untoggle()
		action:hoverColor(1, 0.33, 0.33)
		Config.saveConfig("umbrellaSound", false)
	end)
	if Config.loadConfig("umbrellaSound", true) then
		local action = ActionWheel.Pages[4]:getAction(7)
		action:toggled(true)
		action:hoverColor(0.33, 1, 0.33)
	end

	--アクション5-1. 傘を常にさす
	ActionWheel.Pages[5]:newAction(1):title(Language.getTranslate("action_wheel__main_5__action_1__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__main_5__action_1__title")..Language.getTranslate("action_wheel__toggle_on")):item("red_carpet"):color(0.67, 0, 0):hoverColor(1, 0.33, 0.33):toggleColor(0, 0.67, 0):onToggle(function (_, action)
		pings.main5_action1_toggle()
		action:hoverColor(0.33, 1, 0.33)
		Config.saveConfig("alwaysUmbrella", true)
	end):onUntoggle(function (_, action)
		pings.main5_action1_untoggle()
		action:hoverColor(1, 0.33, 0.33)
		Config.saveConfig("alwaysUmbrella", false)
	end)
	if Config.loadConfig("alwaysUmbrella", false) then
		local action = ActionWheel.Pages[5]:getAction(1)
		action:toggled(true)
		action:hoverColor(0.33, 1, 0.33)
	end

	--アクション5-2. メッセージの表示
	ActionWheel.Pages[5]:newAction(2):title(Language.getTranslate("action_wheel__main_5__action_2__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__main_5__action_2__title")..Language.getTranslate("action_wheel__toggle_on")):item("cake"):color(0.67, 0, 0):hoverColor(1, 0.33, 0.33):toggleColor(0, 0.67, 0):onToggle(function (_, action)
		General.ShowMessage = true
		action:hoverColor(0.33, 1, 0.33)
		Config.saveConfig("showMessage", true)
	end):onUntoggle(function (_, action)
		General.ShowMessage = false
		action:hoverColor(1, 0.33, 0.33)
		Config.saveConfig("showMessage", false)
	end)
	if Config.loadConfig("showMessage", true) then
		local action = ActionWheel.Pages[5]:getAction(2)
		action:toggled(true)
		action:hoverColor(0.33, 1, 0.33)
	else
		General.ShowMessage = false
	end

	--アクション8（共通）. ページ切り替え
	for index, mainPage in ipairs(ActionWheel.Pages) do
		mainPage:newAction(8):title(Language.getTranslate("action_wheel__main__action_8__title")..index.."/"..#ActionWheel.Pages.."\n§6"..Language.getTranslate("action_wheel__main_"..index.."__title")):item("arrow"):color(0, 0.67, 0.67):hoverColor(0.33, 1, 1):onScroll(function (direction)
			local normalizedDirection = direction > 0 and 1 or (direction < 0 and -1 or 0)
			ActionWheel.CurrentPage = ActionWheel.Pages[index - normalizedDirection] and (index - normalizedDirection) or (index == 1 and #ActionWheel.Pages or 1)
			action_wheel:setPage(ActionWheel.Pages[ActionWheel.CurrentPage])
		end)
	end

	ActionWheel.setCostumeChangeActionTitle()
	ActionWheel.setNameChangeActionTitle()
	ActionWheel.setSkullChangeActionTitle()
	action_wheel:setPage(ActionWheel.Pages[1])
end

return ActionWheel