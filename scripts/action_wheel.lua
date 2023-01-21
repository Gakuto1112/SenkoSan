---@class ActionWheel アクションホイールを制御するクラス
---@field ActionWheel.MainPages table アクションホイールのメインページ
---@field ActionWheel.ConfigPage Page 設定のページ
---@field ActionWheel.ParentPage Page 現在開いているページの親ページ。アクションホイールを閉じた際に設定するページ。
---@field ActionWheel.LanguageList table 利用可能な言語のリスト（セリフ集に使う）
---@field ActionWheel.IsAnimationPlaying boolean アニメーションが再生中かどうか
---@field ActionWheel.IsOpenActionWheelPrev boolean 前チックにアクションホイールを開けていたかどうか
---@field ActionWheel.CurrentCostumeState integer プレイヤーの現在のコスチュームの状態を示す：1. いつもの服, 2. 変装服, 3. メイド服A, 4. メイド服B, 5. 水着, 6. チアリーダーの服, 7. 清めの服, 8. 割烹着
---@field ActionWheel.CostumeState integer プレイヤーのコスチュームの状態を示す：1. いつもの服, 2. 変装服, 3. メイド服A, 4. メイド服B, 5. 水着, 6. チアリーダーの服, 7. 清めの服, 8. 割烹着
---@field ActionWheel.CurrentPlayerNameState integer プレイヤーの現在の表示名の状態を示す：1. プレイヤー名, 2. Senko, 3. 仙狐, 4. Senko_san, 5. 仙狐さん, 6. Sen, 7. 仙, 8. セン
---@field ActionWheel.PlayerNameState integer プレイヤーの表示名の状態を示す：1. プレイヤー名, 2. Senko, 3. 仙狐, 4. Senko_san, 5. 仙狐さん, 6. Sen, 7. 仙, 8. セン
---@field ActionWheel.CurrentSKullState integer 現在の頭モデルの状態を示す：1. デフォルト, 2. フィギュアA, 3. フィギュアB
---@field ActionWheel.SkullState integer 頭モデルの状態を示す：1. デフォルト, 2. フィギュアA, 3. フィギュアB

ActionWheel = {
	MainPages = {},
	ConfigPage = action_wheel:newPage(),
	ParentPage = nil,
	LanguageList = Language.getLanguages(),
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
			ActionWheel.MainPages[pageNumber]:getAction(actionNumber):title(Language.getTranslate("action_wheel__main_"..pageNumber.."__action_"..actionNumber.."__title")):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1)
		else
			ActionWheel.MainPages[pageNumber]:getAction(actionNumber):title("§7"..Language.getTranslate("action_wheel__main_"..pageNumber.."__action_"..actionNumber.."__title")):color(42 / 255, 42 / 255, 42 / 255):hoverColor(1, 85 / 255, 85 / 255)
		end
	end,

	---衣装変更のアクションの名称を変更する。
	setCostumeChangeActionTitle = function ()
		if ActionWheel.CostumeState == ActionWheel.CurrentCostumeState then
			ActionWheel.ConfigPage:getAction(1):title(Language.getTranslate("action_wheel__config__action_1__title").."§b"..Language.getTranslate("costume__"..Costume.CostumeList[ActionWheel.CostumeState]))
		else
			ActionWheel.ConfigPage:getAction(1):title(Language.getTranslate("action_wheel__config__action_1__title").."§b"..Language.getTranslate("costume__"..Costume.CostumeList[ActionWheel.CostumeState]).."\n§7"..Language.getTranslate("action_wheel__close_to_confirm"))
		end
	end,

	---名前変更のアクションの名称を変更する。
	setNameChangeActionTitle = function ()
		if ActionWheel.PlayerNameState == ActionWheel.CurrentPlayerNameState then
			ActionWheel.ConfigPage:getAction(2):title(Language.getTranslate("action_wheel__config__action_2__title").."§b"..Nameplate.NameList[ActionWheel.PlayerNameState])
		else
			ActionWheel.ConfigPage:getAction(2):title(Language.getTranslate("action_wheel__config__action_2__title").."§b"..Nameplate.NameList[ActionWheel.PlayerNameState].."\n§7"..Language.getTranslate("action_wheel__close_to_confirm"))
		end
	end,

	---頭変更のアクションの名称を変更する。
	setSkullChangeActionTitle = function ()
		if ActionWheel.SkullState == ActionWheel.CurrentSkullState then
			ActionWheel.ConfigPage:getAction(3):title(Language.getTranslate("action_wheel__config__action_3__title").."§b"..Language.getTranslate("skull__"..Skull.SkullList[ActionWheel.SkullState]))
		else
			ActionWheel.ConfigPage:getAction(3):title(Language.getTranslate("action_wheel__config__action_3__title").."§b"..Language.getTranslate("skull__"..Skull.SkullList[ActionWheel.SkullState]).."\n§7"..Language.getTranslate("action_wheel__close_to_confirm"))
		end
	end,

	---こたつアニメーションのトグルを切り替える。
	---@param toggleValue boolean 切り替える値
	setKotatsuToggle = function (toggleValue)
		if host:isHost() then
			ActionWheel.MainPages[1]:getAction(7):toggled(toggleValue)
		end
	end,

	---立ち上がった時に呼ばれる関数（SitDownから呼び出し）
	onStandUp = function ()
		if host:isHost() then
			ActionWheel.MainPages[2]:getAction(1):toggled(false)
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
	Earpick:play()
end

function pings.main2_action4()
	TeaTime:play()
end

function pings.main2_action5()
	Massage:play()
end

function pings.config_action1(costumeID)
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

function pings.config_action2(nameID)
	nameplate.ALL:setText(Nameplate.NameList[nameID])
	ActionWheel.CurrentPlayerNameState = nameID
	if host:isHost() then
		ActionWheel.setNameChangeActionTitle()
	end
end

function pings.config_action3(skullID)
	Skull.CurrentSkull = skullID
	ActionWheel.CurrentSkullState = skullID
	if host:isHost() then
		ActionWheel.setSkullChangeActionTitle()
	end
end

function pings.config_action4_toggle()
	Wet.AutoShake = true
end

function pings.config_action4_untoggle()
	Wet.AutoShake = false
end

function pings.config_action5_toggle()
	Armor.ShowArmor = true
end

function pings.config_action5_untoggle()
	Armor.ShowArmor = false
end

function pings.config_action7_toggle()
	Umbrella.UmbrellaSound = true
end

function pings.config_action7_untoggle()
	Umbrella.UmbrellaSound = false
end

events.TICK:register(function ()
	if host:isHost() then
		local isOpenActionWheel = action_wheel:isEnabled()
		if isOpenActionWheel then
			if not ActionWheel.ParentPage then
				local animationClasses = {{Smile, ShakeBody, BroomCleaning, HairCut, FoxJump, TailBrush, Kotatsu}, {SitDown, TailCuddling, Earpick, TeaTime, Massage}}
				for pageIndex, pageAnimationClasses in ipairs(animationClasses) do
					for actionIndex, actionClass in ipairs(pageAnimationClasses) do
						ActionWheel.setActionEnabled(pageIndex, actionIndex, not ActionWheel.IsAnimationPlaying and actionClass:checkAction())
					end
				end
				if Wet.WetCount > 0 then
					ActionWheel.MainPages[1]:getAction(2):item("water_bucket")
				else
					ActionWheel.MainPages[1]:getAction(2):item("bucket")
				end
			end
		end
		if not isOpenActionWheel and ActionWheel.IsOpenActionWheelPrev then
			if ActionWheel.CostumeState ~= ActionWheel.CurrentCostumeState then
				pings.config_action1(ActionWheel.CostumeState)
				Config.saveConfig("costume", ActionWheel.CostumeState)
				sounds:playSound("minecraft:item.armor.equip_leather", player:getPos())
				print(Language.getTranslate("action_wheel__config__action_1__done_first")..Language.getTranslate("costume__"..Costume.CostumeList[ActionWheel.CostumeState])..Language.getTranslate("action_wheel__config__action_1__done_last"))
			end
			if ActionWheel.PlayerNameState ~= ActionWheel.CurrentPlayerNameState then
				pings.config_action2(ActionWheel.PlayerNameState)
				Config.saveConfig("name", ActionWheel.PlayerNameState)
				sounds:playSound("minecraft:ui.cartography_table.take_result", player:getPos(), 1, 1)
				print(Language.getTranslate("action_wheel__config__action_2__done_first")..Nameplate.NameList[ActionWheel.PlayerNameState]..Language.getTranslate("action_wheel__config__action_2__done_last"))
			end
			if ActionWheel.SkullState ~= ActionWheel.CurrentSkullState then
				pings.config_action3(ActionWheel.SkullState)
				Config.saveConfig("skull", ActionWheel.SkullState)
				sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
				print(Language.getTranslate("action_wheel__config__action_3__done_first")..Language.getTranslate("skull__"..Skull.SkullList[ActionWheel.SkullState])..Language.getTranslate("action_wheel__config__action_3__done_last"))
			end
			if ActionWheel.ParentPage then
				action_wheel:setPage(ActionWheel.ParentPage)
				ActionWheel.ParentPage = nil
			end
		end
		ActionWheel.IsOpenActionWheelPrev = isOpenActionWheel
	end
end)

if host:isHost() then
	for _ = 1, 3 do
		table.insert(ActionWheel.MainPages, action_wheel:newPage())
	end

	--メインページのアクション設定
	--アクション1-1. にっこり
	ActionWheel.MainPages[1]:newAction(1):item("emerald"):onLeftClick(function ()
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
	ActionWheel.MainPages[1]:newAction(2):item("bucket"):onLeftClick(function()
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
	ActionWheel.MainPages[1]:newAction(3):item("amethyst_shard"):onLeftClick(function ()
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
	ActionWheel.MainPages[1]:newAction(4):item("shears"):onLeftClick(function ()
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
	ActionWheel.MainPages[1]:newAction(5):item("snow_block"):onLeftClick(function ()
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
	ActionWheel.MainPages[1]:newAction(6):item("sponge"):onLeftClick(function ()
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
	ActionWheel.MainPages[1]:newAction(7):toggleColor(233 / 255, 160 / 255, 69 / 255):item("campfire"):onToggle(function ()
		if not ActionWheel.IsAnimationPlaying then
			if Kotatsu:checkAction() then
				pings.main1_action7_toggle()
			else
				if Warden.WardenNearby then
					pings.refuse_emote()
				else
					print(Language.getTranslate("action_wheel__main_1__action_7__unavailable"))
				end
				ActionWheel.MainPages[1]:getAction(7):toggled(false)
			end
		else
			ActionWheel.MainPages[1]:getAction(7):toggled(false)
		end
	end):onUntoggle(function ()
		pings.main1_action7_untoggle()
	end)

	--アクション2-1. おすわり（正座）
	ActionWheel.MainPages[2]:newAction(1):toggleColor(233 / 255, 160 / 255, 69 / 255):item("oak_stairs"):onToggle(function ()
		if not ActionWheel.IsAnimationPlaying then
			if SitDown:checkAction() then
				pings.main2_action1_toggle()
			else
				if Warden.WardenNearby then
					pings.refuse_emote()
				else
					print(Language.getTranslate("action_wheel__main_2__action_1__unavailable"))
				end
				ActionWheel.MainPages[2]:getAction(1):toggled(false)
			end
		else
			ActionWheel.MainPages[2]:getAction(1):toggled(false)
		end
	end):onUntoggle(function ()
		pings.main2_action1_untoggle()
	end)

	--アクション2-2. 尻尾モフモフ
	ActionWheel.MainPages[2]:newAction(2):item("yellow_wool"):onLeftClick(function ()
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

	--アクション2-3. 耳かき
	ActionWheel.MainPages[2]:newAction(3):item("feather"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if SitDown.IsAnimationPlaying then
				pings.main2_action3()
			elseif Warden.WardenNearby then
				pings.refuse_emote()
			else
				print(Language.getTranslate("action_wheel__main_2__action_3__unavailable"))
			end
		end
	end)

	--アクション2-4. ティータイム
	ActionWheel.MainPages[2]:newAction(4):item("flower_pot"):onLeftClick(function ()
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

	--アクション2-5. マッサージ
	ActionWheel.MainPages[2]:newAction(5):item("yellow_bed"):onLeftClick(function ()
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

	--アクション3-1. 設定ページ
	ActionWheel.MainPages[3]:newAction(1):title(Language.getTranslate("action_wheel__main_3__action_1__title")):item("comparator"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
		action_wheel:setPage(ActionWheel.ConfigPage)
		ActionWheel.ParentPage = ActionWheel.MainPages[3]
	end)

	--アクション8（共通）. ページ切り替え
	for index, mainPage in ipairs(ActionWheel.MainPages) do
		mainPage:newAction(8):title(Language.getTranslate("action_wheel__main__action_8__title")..index.."/"..#ActionWheel.MainPages):item("arrow"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
			if ActionWheel.MainPages[index - direction] then
				action_wheel:setPage(ActionWheel.MainPages[index - direction])
			elseif index == 1 then
				action_wheel:setPage(ActionWheel.MainPages[#ActionWheel.MainPages])
			else
				action_wheel:setPage(ActionWheel.MainPages[1])
			end
		end)
	end

	--設定のページのアクション設定
	--アクション1. 着替え
	ActionWheel.ConfigPage:newAction(1):item("leather_chestplate"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
		if direction == -1 then
			ActionWheel.CostumeState = ActionWheel.CostumeState == #Costume.CostumeList and 1 or ActionWheel.CostumeState + 1
		else
			ActionWheel.CostumeState = ActionWheel.CostumeState == 1 and #Costume.CostumeList or ActionWheel.CostumeState - 1
		end
		ActionWheel.setCostumeChangeActionTitle()
	end):onLeftClick(function ()
		ActionWheel.CostumeState = ActionWheel.CurrentCostumeState
		ActionWheel.setCostumeChangeActionTitle()
	end)

	--アクション2. プレイヤーの表示名変更
	ActionWheel.ConfigPage:newAction(2):item("name_tag"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
		if direction == -1 then
			ActionWheel.PlayerNameState = ActionWheel.PlayerNameState == #Nameplate.NameList and 1 or ActionWheel.PlayerNameState + 1
		else
			ActionWheel.PlayerNameState = ActionWheel.PlayerNameState == 1 and #Nameplate.NameList or ActionWheel.PlayerNameState - 1
		end
		ActionWheel.setNameChangeActionTitle()
	end):onLeftClick(function ()
		ActionWheel.PlayerNameState = ActionWheel.CurrentPlayerNameState
		ActionWheel.setNameChangeActionTitle()
	end)

	---アクション3. プレイヤーの頭のタイプ変更
	ActionWheel.ConfigPage:newAction(3):item("player_head{SkullOwner: \""..player:getName().."\"}"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
		if direction == -1 then
			ActionWheel.SkullState = ActionWheel.SkullState == #Skull.SkullList and 1 or ActionWheel.SkullState + 1
		else
			ActionWheel.SkullState = ActionWheel.SkullState == 1 and #Skull.SkullList or ActionWheel.SkullState - 1
		end
		ActionWheel.setSkullChangeActionTitle()
	end):onLeftClick(function ()
		ActionWheel.SkullState = ActionWheel.CurrentSkullState
		ActionWheel.setSkullChangeActionTitle()
	end)

	--アクション4. 自動ブルブル
	ActionWheel.ConfigPage:newAction(4):title(Language.getTranslate("action_wheel__config__action_4__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__config__action_4__title")..Language.getTranslate("action_wheel__toggle_on")):item("water_bucket"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
		pings.config_action4_toggle()
		ActionWheel.ConfigPage:getAction(4):hoverColor(85 / 255, 1, 85 / 255)
		Config.saveConfig("autoShake", true)
	end):onUntoggle(function ()
		pings.config_action4_untoggle()
		ActionWheel.ConfigPage:getAction(4):hoverColor(1, 85 / 255, 85 / 255)
		Config.saveConfig("autoShake", false)
	end)
	if Config.loadConfig("autoShake", true) then
		local action = ActionWheel.ConfigPage:getAction(4)
		action:toggled(true)
		action:hoverColor(85 / 255, 1, 85 / 255)
	end

	--アクション5. 防具の非表示
	ActionWheel.ConfigPage:newAction(5):title(Language.getTranslate("action_wheel__config__action_5__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__config__action_5__title")..Language.getTranslate("action_wheel__toggle_on")):item("iron_chestplate"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
		pings.config_action5_toggle()
		ActionWheel.ConfigPage:getAction(5):hoverColor(85 / 255, 1, 85 / 255)
		Config.saveConfig("showArmor", true)
	end):onUntoggle(function ()
		pings.config_action5_untoggle()
		ActionWheel.ConfigPage:getAction(5):hoverColor(1, 85 / 255, 85 / 255)
		Config.saveConfig("showArmor", false)
	end)
	if Config.loadConfig("showArmor", false) then
		local action = ActionWheel.ConfigPage:getAction(5)
		action:toggled(true)
		action:hoverColor(85 / 255, 1, 85 / 255)
	end

	--アクション6. 一人称視点での狐火の表示の切り替え
	ActionWheel.ConfigPage:newAction(6):title(Language.getTranslate("action_wheel__config__action_6__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__config__action_6__title")..Language.getTranslate("action_wheel__toggle_on")):item("soul_torch"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
		FoxFire.FoxFireInFirstPerson = true
		ActionWheel.ConfigPage:getAction(6):hoverColor(85 / 255, 1, 85 / 255)
		Config.saveConfig("foxFireInFirstPerson", true)
	end):onUntoggle(function ()
		FoxFire.FoxFireInFirstPerson = false
		ActionWheel.ConfigPage:getAction(6):hoverColor(1, 85 / 255, 85 / 255)
		Config.saveConfig("foxFireInFirstPerson", false)
	end)
	if Config.loadConfig("foxFireInFirstPerson", true) then
		local action = ActionWheel.ConfigPage:getAction(6)
		action:toggled(true)
		action:hoverColor(85 / 255, 1, 85 / 255)
	end

	--アクション7. 傘の開閉音
	ActionWheel.ConfigPage:newAction(7):title(Language.getTranslate("action_wheel__config__action_7__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__config__action_7__title")..Language.getTranslate("action_wheel__toggle_on")):item("red_carpet"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
		pings.config_action7_toggle()
		ActionWheel.ConfigPage:getAction(7):hoverColor(85 / 255, 1, 85 / 255)
		Config.saveConfig("umbrellaSound", true)
	end):onUntoggle(function ()
		pings.config_action7_untoggle()
		ActionWheel.ConfigPage:getAction(7):hoverColor(1, 85 / 255, 85 / 255)
		Config.saveConfig("umbrellaSound", false)
	end)
	if Config.loadConfig("umbrellaSound", true) then
		local action = ActionWheel.ConfigPage:getAction(7)
		action:toggled(true)
		action:hoverColor(85 / 255, 1, 85 / 255)
	end

	ActionWheel.setCostumeChangeActionTitle()
	ActionWheel.setNameChangeActionTitle()
	ActionWheel.setSkullChangeActionTitle()
	action_wheel:setPage(ActionWheel.MainPages[1])
end

return ActionWheel