---@class ActionWheel アクションホイールを制御するクラス
---@field ActionWheel.MainPages table アクションホイールのメインページ
---@field ActionWheel.WordPage Page セリフ一覧のページ
---@field ActionWheel.ConfigPage Page 設定のページ
---@field ActionWheel.IsOpenWordPage boolean セリフ集のページを開いているかどうか
---@field ActionWheel.ParentPage Page 現在開いているページの親ページ。アクションホイールを閉じた際に設定するページ。
---@field ActionWheel.LanguageList table 利用可能な言語のリスト（セリフ集に使う）
---@field ActionWheel.CurrentWordLanguage integer 現在のセリフの言語
---@field ActionWheel.IsAnimationPlaying boolean アニメーションが再生中かどうか
---@field ActionWheel.IsOpenActionWheelPrev boolean 前チックにアクションホイールを開けていたかどうか
---@field ActionWheel.CurrentCostumeState integer プレイヤーの現在のコスチュームの状態を示す：1. いつもの服, 2. 変装服, 3. メイド服A, 4. メイド服B, 5. 水着, 6. チアリーダーの服, 7. 清めの服, 8. 割烹着
---@field ActionWheel.CostumeState integer プレイヤーのコスチュームの状態を示す：1. いつもの服, 2. 変装服, 3. メイド服A, 4. メイド服B, 5. 水着, 6. チアリーダーの服, 7. 清めの服, 8. 割烹着
---@field ActionWheel.CurrentPlayerNameState integer プレイヤーの現在の表示名の状態を示す：1. プレイヤー名, 2. Senko, 3. 仙狐, 4. Senko_san, 5. 仙狐さん, 6. Sen, 7. 仙, 8. セン
---@field ActionWheel.PlayerNameState integer プレイヤーの表示名の状態を示す：1. プレイヤー名, 2. Senko, 3. 仙狐, 4. Senko_san, 5. 仙狐さん, 6. Sen, 7. 仙, 8. セン
---@field ActionWheel.IsWetPrev boolean 前チックに濡れていたかどうか

ActionWheel = {}

ActionWheel.MainPages = {}
ActionWheel.WordPage = action_wheel:newPage()
ActionWheel.ConfigPage = action_wheel:newPage()
ActionWheel.IsOpenWordPage = false
ActionWheel.ParentPage = nil
ActionWheel.LanguageList = LanguageClass.getLanguages()
ActionWheel.CurrentWordLanguage = General.indexof(ActionWheel.LanguageList, client:getActiveLang())
ActionWheel.IsAnimationPlaying = false
ActionWheel.IsOpenActionWheelPrev = false
ActionWheel.CurrentCostumeState = ConfigClass.loadConfig("costume", 1)
ActionWheel.CostumeState = ActionWheel.CurrentCostumeState
ActionWheel.CurrentPlayerNameState = ConfigClass.loadConfig("name", 1)
ActionWheel.PlayerNameState = ActionWheel.CurrentPlayerNameState
ActionWheel.IsWetPrev = false

---アクションの色の有効色/無効色の切り替え
---@param pageNumber integer メインアクションのページ番号
---@param actionNumber integer pageNumber内のアクションの番号
---@param enabled boolean 有効色か無効色か
function setActionEnabled(pageNumber, actionNumber, enabled)
	if enabled then
		ActionWheel.MainPages[pageNumber]:getAction(actionNumber):title(LanguageClass.getTranslate("action_wheel__main_"..pageNumber.."__action_"..actionNumber.."__title")):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1)
	else
		ActionWheel.MainPages[pageNumber]:getAction(actionNumber):title("§7"..LanguageClass.getTranslate("action_wheel__main_"..pageNumber.."__action_"..actionNumber.."__title")):color(42 / 255, 42 / 255, 42 / 255):hoverColor(1, 85 / 255, 85 / 255)
	end
end

---衣装変更のアクションの名称を変更する。
function setCostumeChangeActionTitle()
	if ActionWheel.CostumeState == ActionWheel.CurrentCostumeState then
		ActionWheel.ConfigPage:getAction(1):title(LanguageClass.getTranslate("action_wheel__config__action_1__title").."§b"..LanguageClass.getTranslate("costume__"..CostumeClass.CostumeList[ActionWheel.CostumeState]))
	else
		ActionWheel.ConfigPage:getAction(1):title(LanguageClass.getTranslate("action_wheel__config__action_1__title").."§b"..LanguageClass.getTranslate("costume__"..CostumeClass.CostumeList[ActionWheel.CostumeState]).."\n§7"..LanguageClass.getTranslate("action_wheel__close_to_confirm"))
	end
end

---名前変更のアクションの名称を変更する。
function setNameChangeActionTitle()
	if ActionWheel.PlayerNameState == ActionWheel.CurrentPlayerNameState then
		ActionWheel.ConfigPage:getAction(2):title(LanguageClass.getTranslate("action_wheel__config__action_2__title").."§b"..NameplateClass.NameList[ActionWheel.PlayerNameState])
	else
		ActionWheel.ConfigPage:getAction(2):title(LanguageClass.getTranslate("action_wheel__config__action_2__title").."§b"..NameplateClass.NameList[ActionWheel.PlayerNameState].."\n§7"..LanguageClass.getTranslate("action_wheel__close_to_confirm"))
	end
end

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

function pings.main1_action7()
	Kotatsu:play()
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
		CostumeClass.resetCostume()
	else
		CostumeClass.setCostume(string.upper(CostumeClass.CostumeList[costumeID]))
	end
	ActionWheel.CurrentCostumeState = costumeID
	if host:isHost() then
		setCostumeChangeActionTitle()
	end
end

function pings.config_action2(nameID)
	NameplateClass.setName(nameID)
	ActionWheel.CurrentPlayerNameState = nameID
	if host:isHost() then
		setNameChangeActionTitle()
	end
end

function pings.config_action3_toggle()
	WetClass.AutoShake = true
end

function pings.config_action3_untoggle()
	WetClass.AutoShake = false
end

function pings.config_action4_toggle()
	ArmorClass.ShowArmor = true
end

function pings.config_action4_untoggle()
	ArmorClass.ShowArmor = false
end

function pings.config_action6_toggle()
	UmbrellaClass.UmbrellaSound = true
end

function pings.config_action6_untoggle()
	UmbrellaClass.UmbrellaSound = false
end

events.TICK:register(function ()
	if host:isHost() then
		local sitDownAction = ActionWheel.MainPages[2]:getAction(1)
		sitDownAction:toggled((ActionWheel.IsAnimationPlaying or General.isAnimationPlaying("models.main", "earpick") or General.isAnimationPlaying("models.main", "tea_time") or General.isAnimationPlaying("models.main", "massage") or (General.isAnimationPlaying("models.main", "sit_down") and General.isAnimationPlaying("models.main", "shake"))) and SitDown:checkAction() and sitDownAction:isToggled())
		local isOpenActionWheel = action_wheel:isEnabled()
		if isOpenActionWheel and not ActionWheel.ParentPage then
			local animationClasses = {{Smile, ShakeBody, BroomCleaning, HairCut, FoxJump, TailBrush, Kotatsu}, {SitDown, TailCuddling, Earpick, TeaTime, Massage}}
			for pageIndex, pageAnimationClasses in ipairs(animationClasses) do
				for actionIndex, actionClass in ipairs(pageAnimationClasses) do
					setActionEnabled(pageIndex, actionIndex, not ActionWheel.IsAnimationPlaying and actionClass:checkAction())
				end
			end
			setActionEnabled(3, 1, not WardenClass.WardenNearby)
		end
		if not isOpenActionWheel and ActionWheel.IsOpenActionWheelPrev then
			if ActionWheel.CostumeState ~= ActionWheel.CurrentCostumeState then
				pings.config_action1(ActionWheel.CostumeState)
				ConfigClass.saveConfig("costume", ActionWheel.CostumeState)
				sounds:playSound("minecraft:item.armor.equip_leather", player:getPos())
				print(LanguageClass.getTranslate("action_wheel__config__action_1__done_first")..LanguageClass.getTranslate("costume__"..CostumeClass.CostumeList[ActionWheel.CostumeState])..LanguageClass.getTranslate("action_wheel__config__action_1__done_last"))
			end
			if ActionWheel.PlayerNameState ~= ActionWheel.CurrentPlayerNameState then
				pings.config_action2(ActionWheel.PlayerNameState)
				ConfigClass.saveConfig("name", ActionWheel.PlayerNameState)
				sounds:playSound("minecraft:ui.cartography_table.take_result", player:getPos(), 1, 1)
				print(LanguageClass.getTranslate("action_wheel__config__action_2__done_first")..NameplateClass.NameList[ActionWheel.PlayerNameState]..LanguageClass.getTranslate("action_wheel__config__action_2__done_last"))
			end
			if ActionWheel.ParentPage then
				action_wheel:setPage(ActionWheel.ParentPage)
				ActionWheel.IsOpenWordPage = false
				ActionWheel.ParentPage = nil
			end
		end
		if WetClass.WetCount > 0 and not ActionWheel.IsWetPrev then
			ActionWheel.MainPages[1]:getAction(2):item("water_bucket")
		elseif WetClass.WetCount == 0 and ActionWheel.IsWetPrev then
			ActionWheel.MainPages[1]:getAction(2):item("bucket")
		end
		if WardenClass.WardenNearby and ActionWheel.IsOpenWordPage then
			action_wheel:setPage(ActionWheel.ParentPage)
			ActionWheel.IsOpenWordPage = false
			ActionWheel.ParentPage = nil
		end
		ActionWheel.IsOpenActionWheelPrev = isOpenActionWheel
		ActionWheel.IsWetPrev = WetClass.WetCount > 0
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
			if WardenClass.WardenNearby then
				pings.refuse_emote()
			else
				pings.main1_action1_left()
			end
		end
	end):onRightClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if WardenClass.WardenNearby then
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
			elseif WardenClass.WardenNearby then
				pings.refuse_emote()
			else
				print(LanguageClass.getTranslate("action_wheel__main_1__action_2__unavailable"))
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
			elseif WardenClass.WardenNearby then
				pings.refuse_emote()
			else
				print(LanguageClass.getTranslate("action_wheel__main_1__action_3__unavailable"))
			end
		end
	end):onRightClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if BroomCleaning:checkAction() then
				pings.main1_action3_right()
			elseif WardenClass.WardenNearby then
				pings.refuse_emote()
			else
				print(LanguageClass.getTranslate("action_wheel__main_1__action_3__unavailable"))
			end
		end
	end)

	--アクション1-4. 散髪
	ActionWheel.MainPages[1]:newAction(4):item("shears"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if BroomCleaning:checkAction() then
				pings.main1_action4()
			elseif WardenClass.WardenNearby then
				pings.refuse_emote()
			else
				print(LanguageClass.getTranslate("action_wheel__main_1__action_4__unavailable"))
			end
		end
	end)

	--アクション1-5. キツネジャンプ
	ActionWheel.MainPages[1]:newAction(5):item("snow_block"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if FoxJump:checkAction() then
				pings.main1_action5()
			elseif WardenClass.WardenNearby then
				pings.refuse_emote()
			else
				print(LanguageClass.getTranslate("action_wheel__main_1__action_5__unavailable"))
			end
		end
	end)

	--アクション1-6. 尻尾の手入れ
	ActionWheel.MainPages[1]:newAction(6):item("sponge"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if TailBrush:checkAction() then
				pings.main1_action6()
			elseif WardenClass.WardenNearby then
				pings.refuse_emote()
			else
				print(LanguageClass.getTranslate("action_wheel__main_1__action_6__unavailable"))
			end
		end
	end)

	--アクション1-7. こたつ
	ActionWheel.MainPages[1]:newAction(7):item("campfire"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if Kotatsu:checkAction() then
				pings.main1_action7()
			elseif WardenClass.WardenNearby then
				pings.refuse_emote()
			else
				print(LanguageClass.getTranslate("action_wheel__main_1__action_7__unavailable"))
			end
		end
	end)

	--アクション2-1. おすわり（正座）
	ActionWheel.MainPages[2]:newAction(1):toggleColor(233 / 255, 160 / 255, 69 / 255):item("oak_stairs"):onToggle(function ()
		if not ActionWheel.IsAnimationPlaying then
			if SitDown:checkAction() then
				pings.main2_action1_toggle()
			elseif WardenClass.WardenNearby then
				pings.refuse_emote()
			else
				print(LanguageClass.getTranslate("action_wheel__main_2__action_1__unavailable"))
			end
		end
	end):onUntoggle(function ()
		pings.main2_action1_untoggle()
	end)

	--アクション2-2. 尻尾モフモフ
	ActionWheel.MainPages[2]:newAction(2):item("yellow_wool"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if TailCuddling:checkAction() then
				pings.main2_action2()
			elseif WardenClass.WardenNearby then
				pings.refuse_emote()
			else
				print(LanguageClass.getTranslate("action_wheel__main_2__action_2__unavailable"))
			end
		end
	end)

	--アクション2-3. 耳かき
	ActionWheel.MainPages[2]:newAction(3):item("feather"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if General.isAnimationPlaying("models.main", "sit_down") then
				pings.main2_action3()
			elseif WardenClass.WardenNearby then
				pings.refuse_emote()
			else
				print(LanguageClass.getTranslate("action_wheel__main_2__action_3__unavailable"))
			end
		end
	end)

	--アクション2-4. ティータイム
	ActionWheel.MainPages[2]:newAction(4):item("flower_pot"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if General.isAnimationPlaying("models.main", "sit_down") then
				pings.main2_action4()
			elseif WardenClass.WardenNearby then
				pings.refuse_emote()
			else
				print(LanguageClass.getTranslate("action_wheel__main_2__action_4__unavailable"))
			end
		end
	end)

	--アクション2-5. マッサージ
	ActionWheel.MainPages[2]:newAction(5):item("yellow_bed"):onLeftClick(function ()
		if not ActionWheel.IsAnimationPlaying then
			if General.isAnimationPlaying("models.main", "sit_down") then
				pings.main2_action5()
			elseif WardenClass.WardenNearby then
				pings.refuse_emote()
			else
				print(LanguageClass.getTranslate("action_wheel__main_2__action_5__unavailable"))
			end
		end
	end)

	--アクション3-1. 仙狐さんセリフ集
	ActionWheel.MainPages[3]:newAction(1):item("book"):onLeftClick(function ()
		if WardenClass.WardenNearby then
			if ActionWheel.IsAnimationPlaying then
				pings.refuse_emote()
			end
		else
			action_wheel:setPage(ActionWheel.WordPage)
			ActionWheel.IsOpenWordPage = true
			ActionWheel.ParentPage = ActionWheel.MainPages[3]
		end
	end)

	--アクション3-2. 設定ページ
	ActionWheel.MainPages[3]:newAction(2):title(LanguageClass.getTranslate("action_wheel__main_3__action_2__title")):item("comparator"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
		action_wheel:setPage(ActionWheel.ConfigPage)
		ActionWheel.ParentPage = ActionWheel.MainPages[3]
	end)

	--アクション8（共通）. ページ切り替え
	for index, mainPage in ipairs(ActionWheel.MainPages) do
		mainPage:newAction(8):title(LanguageClass.getTranslate("action_wheel__main__action_8__title")..index.."/"..#ActionWheel.MainPages):item("arrow"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
			if ActionWheel.MainPages[index - direction] then
				action_wheel:setPage(ActionWheel.MainPages[index - direction])
			elseif index == 1 then
				action_wheel:setPage(ActionWheel.MainPages[#ActionWheel.MainPages])
			else
				action_wheel:setPage(ActionWheel.MainPages[1])
			end
		end)
	end

	ActionWheel.CurrentWordLanguage = ActionWheel.CurrentWordLanguage == -1 and General.indexof(ActionWheel.LanguageList, "en_us") or ActionWheel.CurrentWordLanguage

	--セリフのページのアクション設定
	--アクション1. 「存分に甘やかしてくれよう！」
	ActionWheel.WordPage:newAction(1):title(LanguageClass.getTranslate("action_wheel__word__action_1__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
		host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_1__title", ActionWheel.LanguageList[ActionWheel.CurrentWordLanguage]))
	end)

	--アクション2. 「存分にもふるがよい」
	ActionWheel.WordPage:newAction(2):title(LanguageClass.getTranslate("action_wheel__word__action_2__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
		host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_2__title", ActionWheel.LanguageList[ActionWheel.CurrentWordLanguage]))
	end)

	--アクション3. 「おかえりなのじゃ」
	ActionWheel.WordPage:newAction(3):title(LanguageClass.getTranslate("action_wheel__word__action_3__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
		host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_3__title", ActionWheel.LanguageList[ActionWheel.CurrentWordLanguage]))
	end)

	--アクション4. 「お疲れ様じゃ」
	ActionWheel.WordPage:newAction(4):title(LanguageClass.getTranslate("action_wheel__word__action_4__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
		host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_4__title", ActionWheel.LanguageList[ActionWheel.CurrentWordLanguage]))
	end)

	--アクション5. 「今日も大変だったのう」
	ActionWheel.WordPage:newAction(5):title(LanguageClass.getTranslate("action_wheel__word__action_5__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
		host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_5__title", ActionWheel.LanguageList[ActionWheel.CurrentWordLanguage]))
	end)

	--アクション6. 「うやん♪」
	ActionWheel.WordPage:newAction(6):title(LanguageClass.getTranslate("action_wheel__word__action_6__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
		host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_6__title", ActionWheel.LanguageList[ActionWheel.CurrentWordLanguage]))
	end)

	--アクション7. 「わらわはただの動く毛玉じゃ...」
	ActionWheel.WordPage:newAction(7):title(LanguageClass.getTranslate("action_wheel__word__action_7__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
		host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_7__title", ActionWheel.LanguageList[ActionWheel.CurrentWordLanguage]))
	end)

	--アクション8. 言語切り替え
	ActionWheel.WordPage:newAction(8):title(LanguageClass.getTranslate("action_wheel__word__action_8__title")..LanguageClass.getTranslate("language__"..ActionWheel.LanguageList[ActionWheel.CurrentWordLanguage])):item("paper"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
		if ActionWheel.LanguageList[ActionWheel.CurrentWordLanguage - direction] then
			ActionWheel.CurrentWordLanguage = ActionWheel.CurrentWordLanguage - direction
		elseif ActionWheel.CurrentWordLanguage == 1 then
			ActionWheel.CurrentWordLanguage = #ActionWheel.LanguageList
		else
			ActionWheel.CurrentWordLanguage = 1
		end
		local motherLanguage = General.indexof(ActionWheel.LanguageList, client:getActiveLang())
		motherLanguage = motherLanguage == -1 and General.indexof(ActionWheel.LanguageList, "en_us") or motherLanguage
		for i = 1, 7 do
			ActionWheel.WordPage:getAction(i):title(ActionWheel.CurrentWordLanguage == motherLanguage and LanguageClass.getTranslate("action_wheel__word__action_"..i.."__title", ActionWheel.LanguageList[ActionWheel.CurrentWordLanguage]) or LanguageClass.getTranslate("action_wheel__word__action_"..i.."__title", ActionWheel.LanguageList[ActionWheel.CurrentWordLanguage]).."\n§7"..LanguageClass.getTranslate("action_wheel__word__action_8__bracket_begin")..LanguageClass.getTranslate("action_wheel__word__action_"..i.."__title")..LanguageClass.getTranslate("action_wheel__word__action_8__bracket_end"))
		end
		ActionWheel.WordPage:getAction(8):title(LanguageClass.getTranslate("action_wheel__word__action_8__title")..LanguageClass.getTranslate("language__"..ActionWheel.LanguageList[ActionWheel.CurrentWordLanguage]))
	end)

	--設定のページのアクション設定
	--アクション1. 着替え
	ActionWheel.ConfigPage:newAction(1):item("leather_chestplate"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
		if direction == -1 then
			ActionWheel.CostumeState = ActionWheel.CostumeState == #CostumeClass.CostumeList and 1 or ActionWheel.CostumeState + 1
		else
			ActionWheel.CostumeState = ActionWheel.CostumeState == 1 and #CostumeClass.CostumeList or ActionWheel.CostumeState - 1
		end
		setCostumeChangeActionTitle()
	end):onLeftClick(function ()
		ActionWheel.CostumeState = ActionWheel.CurrentCostumeState
		setCostumeChangeActionTitle()
	end)

	--アクション2. プレイヤーの表示名変更
	ActionWheel.ConfigPage:newAction(2):item("name_tag"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
		if direction == -1 then
			ActionWheel.PlayerNameState = ActionWheel.PlayerNameState == #NameplateClass.NameList and 1 or ActionWheel.PlayerNameState + 1
		else
			ActionWheel.PlayerNameState = ActionWheel.PlayerNameState == 1 and #NameplateClass.NameList or ActionWheel.PlayerNameState - 1
		end
		setNameChangeActionTitle()
	end):onLeftClick(function ()
		ActionWheel.PlayerNameState = ActionWheel.CurrentPlayerNameState
		setNameChangeActionTitle()
	end)

	--アクション3. 自動ブルブル
	ActionWheel.ConfigPage:newAction(3):title(LanguageClass.getTranslate("action_wheel__config__action_3__title")..LanguageClass.getTranslate("action_wheel__toggle_off")):toggleTitle(LanguageClass.getTranslate("action_wheel__config__action_3__title")..LanguageClass.getTranslate("action_wheel__toggle_on")):item("water_bucket"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
		pings.config_action3_toggle()
		ActionWheel.ConfigPage:getAction(3):hoverColor(85 / 255, 1, 85 / 255)
		ConfigClass.saveConfig("autoShake", true)
	end):onUntoggle(function ()
		pings.config_action3_untoggle()
		ActionWheel.ConfigPage:getAction(3):hoverColor(1, 85 / 255, 85 / 255)
		ConfigClass.saveConfig("autoShake", false)
	end)
	if ConfigClass.loadConfig("autoShake", true) then
		local action = ActionWheel.ConfigPage:getAction(3)
		action:toggled(true)
		action:hoverColor(85 / 255, 1, 85 / 255)
	end

	--アクション4. 防具の非表示
	ActionWheel.ConfigPage:newAction(4):title(LanguageClass.getTranslate("action_wheel__config__action_4__title")..LanguageClass.getTranslate("action_wheel__toggle_off")):toggleTitle(LanguageClass.getTranslate("action_wheel__config__action_4__title")..LanguageClass.getTranslate("action_wheel__toggle_on")):item("iron_chestplate"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
		pings.config_action4_toggle()
		ActionWheel.ConfigPage:getAction(4):hoverColor(85 / 255, 1, 85 / 255)
		ConfigClass.saveConfig("showArmor", true)
	end):onUntoggle(function ()
		pings.config_action4_untoggle()
		ActionWheel.ConfigPage:getAction(4):hoverColor(1, 85 / 255, 85 / 255)
		ConfigClass.saveConfig("showArmor", false)
	end)
	if ConfigClass.loadConfig("showArmor", false) then
		local action = ActionWheel.ConfigPage:getAction(4)
		action:toggled(true)
		action:hoverColor(85 / 255, 1, 85 / 255)
	end

	--アクション5. 一人称視点での狐火の表示の切り替え
	ActionWheel.ConfigPage:newAction(5):title(LanguageClass.getTranslate("action_wheel__config__action_5__title")..LanguageClass.getTranslate("action_wheel__toggle_off")):toggleTitle(LanguageClass.getTranslate("action_wheel__config__action_5__title")..LanguageClass.getTranslate("action_wheel__toggle_on")):item("soul_torch"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
		FoxFireClass.FoxFireInFirstPerson = true
		ActionWheel.ConfigPage:getAction(5):hoverColor(85 / 255, 1, 85 / 255)
		ConfigClass.saveConfig("foxFireInFirstPerson", true)
	end):onUntoggle(function ()
		FoxFireClass.FoxFireInFirstPerson = false
		ActionWheel.ConfigPage:getAction(5):hoverColor(1, 85 / 255, 85 / 255)
		ConfigClass.saveConfig("foxFireInFirstPerson", false)
	end)
	if ConfigClass.loadConfig("foxFireInFirstPerson", true) then
		local action = ActionWheel.ConfigPage:getAction(5)
		action:toggled(true)
		action:hoverColor(85 / 255, 1, 85 / 255)
	end

	--アクション6. 傘の開閉音
	ActionWheel.ConfigPage:newAction(6):title(LanguageClass.getTranslate("action_wheel__config__action_6__title")..LanguageClass.getTranslate("action_wheel__toggle_off")):toggleTitle(LanguageClass.getTranslate("action_wheel__config__action_6__title")..LanguageClass.getTranslate("action_wheel__toggle_on")):item("red_carpet"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
		pings.config_action6_toggle()
		ActionWheel.ConfigPage:getAction(6):hoverColor(85 / 255, 1, 85 / 255)
		ConfigClass.saveConfig("umbrellaSound", true)
	end):onUntoggle(function ()
		pings.config_action6_untoggle()
		ActionWheel.ConfigPage:getAction(6):hoverColor(1, 85 / 255, 85 / 255)
		ConfigClass.saveConfig("umbrellaSound", false)
	end)
	if ConfigClass.loadConfig("umbrellaSound", true) then
		local action = ActionWheel.ConfigPage:getAction(6)
		action:toggled(true)
		action:hoverColor(85 / 255, 1, 85 / 255)
	end

	setCostumeChangeActionTitle()
	setNameChangeActionTitle()
	action_wheel:setPage(ActionWheel.MainPages[1])
end

return ActionWheel