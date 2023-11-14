---@class ActionWheel アクションホイールを制御するクラス
---@field MainPage Page アクションホイールのメインページ
---@field IsAnimationPlaying boolean アニメーションが再生中かどうか
ActionWheel = {
    MainPage = action_wheel:newPage();
    IsAnimationPlaying = false,

    ---立ち上がった時に呼ばれる関数（SitDownから呼び出し）
	onStandUp = function ()
		if host:isHost() then
			ActionWheel.MainPage:getAction(1):toggled(false)
		end
	end
}

---前チックにアクションホイールを開けていたかどうか
---@type boolean
local isOpenActionWheelPrev = false

---プレイヤーの表示名の状態を示す：1. プレイヤー名, 2. Sora, 3. 夜空
---@type string
local playerNameState = Config.loadConfig("name", 1)

---プレイヤーの現在の表示名の状態を示す：1. プレイヤー名, 2. Sora, 3. 夜空
---@type string
local currentPlayerNameState = playerNameState

---名前変更のアクションの名称を変更する。
local function setNameChangeActionTitle()
    if playerNameState == currentPlayerNameState then
        ActionWheel.MainPage:getAction(2):title(Language.getTranslate("action_wheel__main__action_2__title").."§b"..Nameplate.NameList[playerNameState])
    else
        ActionWheel.MainPage:getAction(2):title(Language.getTranslate("action_wheel__main__action_2__title").."§b"..Nameplate.NameList[playerNameState].."\n§7"..Language.getTranslate("action_wheel__close_to_confirm"))
    end
end

--ping関数
function pings.main_action1_toggle()
	SitDown:play()
end

function pings.main_action1_untoggle()
	SitDown:stop()
end

function pings.main_action2(nameID)
	nameplate.ALL:setText(Nameplate.NameList[nameID])
	currentPlayerNameState = nameID
	if host:isHost() then
		setNameChangeActionTitle()
	end
end

function pings.main_action3_toggle()
	Armor.ShowArmor = true
end

function pings.main_action3_untoggle()
	Armor.ShowArmor = false
end

function pings.main_action5_toggle()
	Umbrella.Sound = true
end

function pings.main_action5_untoggle()
	Umbrella.Sound = false
end

function pings.main_action6_toggle()
	Umbrella.AlwaysUse = true
end

function pings.main_action6_untoggle()
	Umbrella.AlwaysUse = false
end

events.TICK:register(function ()
    if host:isHost() then
		local isOpenActionWheel = action_wheel:isEnabled()
        if isOpenActionWheel then
            if not ActionWheel.IsAnimationPlaying and SitDown:checkAction() then
                ActionWheel.MainPage:getAction(1):title(Language.getTranslate("action_wheel__main__action_1__title")):color(0.91, 0.67, 0.27):hoverColor(1, 1, 1)
            else
                ActionWheel.MainPage:getAction(1):title("§7"..Language.getTranslate("action_wheel__main__action_1__title")):color(0.16, 0.16, 0.16):hoverColor(1, 0.33, 0.33)
            end
        end
        if not isOpenActionWheel and isOpenActionWheelPrev then
            if playerNameState ~= currentPlayerNameState then
                pings.main_action2(playerNameState)
                Config.saveConfig("name", playerNameState)
				sounds:playSound("minecraft:ui.cartography_table.take_result", player:getPos())
				print(Language.getTranslate("action_wheel__main__action_2__done_first")..Nameplate.NameList[playerNameState]..Language.getTranslate("action_wheel__main__action_2__done_last"))
            end
        end
        isOpenActionWheelPrev = isOpenActionWheel
    end
end)


if host:isHost() then
    --メインページのアクション設定
    --アクション1-1. 座る
    ActionWheel.MainPage:newAction(1):toggleColor(0.91, 0.67, 0.27):item("oak_stairs"):onToggle(function(_, action)
		if not ActionWheel.IsAnimationPlaying then
			if SitDown:checkAction() then
				pings.main_action1_toggle()
			else print(Language.getTranslate("action_wheel__main__action_1__unavailable"))
				action:toggled(false)
			end
		else
			action:toggled(false)
		end
    end):onUntoggle(function ()
		pings.main_action1_untoggle()
    end)

    --アクション1-2. 名前変更
	ActionWheel.MainPage:newAction(2):title(Language.getTranslate("action_wheel__main__action_2__title")):color(0.91, 0.67, 0.27):hoverColor(1, 1, 1):item("name_tag"):color(0.78, 0.78, 0.78):hoverColor(1, 1, 1):onScroll(function (direction)
        if direction < 0 then
            playerNameState = playerNameState == #Nameplate.NameList and 1 or playerNameState + 1
        else
            playerNameState = playerNameState == 1 and #Nameplate.NameList or playerNameState - 1
        end
        setNameChangeActionTitle()
    end):onLeftClick(function ()
        playerNameState = currentPlayerNameState
        setNameChangeActionTitle()
    end):onRightClick(function ()
        playerNameState = 1
        setNameChangeActionTitle()
    end)

    --アクション1-3. 防具の表示
	ActionWheel.MainPage:newAction(3):title(Language.getTranslate("action_wheel__main__action_3__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__main__action_3__title")..Language.getTranslate("action_wheel__toggle_on")):item("iron_chestplate"):color(0.67, 0, 0):hoverColor(1, 0.33, 0.33):onToggle(function (_, action)
		pings.main_action3_toggle()
		action:hoverColor(0.33, 1, 0.33)
		Config.saveConfig("showArmor", true)
	end):onUntoggle(function (_, action)
		pings.main_action3_untoggle()
		action:hoverColor(1, 0.33, 0.33)
		Config.saveConfig("showArmor", false)
	end)
	if Config.loadConfig("showArmor", false) then
		local action = ActionWheel.MainPage:getAction(3)
		action:toggled(true)
		action:hoverColor(0.33, 1, 0.33)
	end

    --アクション1-4. 一人称視点での狐火の表示
    ActionWheel.MainPage:newAction(4):title(Language.getTranslate("action_wheel__main__action_4__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__main__action_4__title")..Language.getTranslate("action_wheel__toggle_on")):item("soul_torch"):color(0.67, 0, 0):hoverColor(1, 0.33, 0.33):toggleColor(0, 0.67, 0):onToggle(function (_, action)
		FoxFire.FoxFireInFirstPerson = true
		action:hoverColor(0.33, 1, 0.33)
		Config.saveConfig("foxFireInFirstPerson", true)
	end):onUntoggle(function (_, action)
		FoxFire.FoxFireInFirstPerson = false
		action:hoverColor(1, 0.33, 0.33)
		Config.saveConfig("foxFireInFirstPerson", false)
	end)
	if Config.loadConfig("foxFireInFirstPerson", true) then
		local action = ActionWheel.MainPage:getAction(4)
		action:toggled(true)
		action:hoverColor(0.33, 1, 0.33)
	end

    --アクション1-5. 傘の開閉音
	ActionWheel.MainPage:newAction(5):title(Language.getTranslate("action_wheel__main__action_5__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__main__action_5__title")..Language.getTranslate("action_wheel__toggle_on")):item("note_block"):color(0.67, 0, 0):hoverColor(1, 0.33, 0.33):toggleColor(0, 0.67, 0):onToggle(function (_, action)
		pings.main_action5_toggle()
		action:hoverColor(0.33, 1, 0.33)
		Config.saveConfig("umbrellaSound", true)
	end):onUntoggle(function (_, action)
		pings.main_action5_untoggle()
		action:hoverColor(1, 0.33, 0.33)
		Config.saveConfig("umbrellaSound", false)
	end)
	if Config.loadConfig("umbrellaSound", true) then
		local action = ActionWheel.MainPage:getAction(5)
		action:toggled(true)
		action:hoverColor(0.33, 1, 0.33)
	end

    --アクション1-6. 常に傘をさす
	ActionWheel.MainPage:newAction(6):title(Language.getTranslate("action_wheel__main__action_6__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__main__action_6__title")..Language.getTranslate("action_wheel__toggle_on")):item("red_carpet"):color(0.67, 0, 0):hoverColor(1, 0.33, 0.33):toggleColor(0, 0.67, 0):onToggle(function (_, action)
		pings.main_action6_toggle()
		action:hoverColor(0.33, 1, 0.33)
		Config.saveConfig("alwaysUmbrella", true)
	end):onUntoggle(function (_, action)
		pings.main_action6_untoggle()
		action:hoverColor(1, 0.33, 0.33)
		Config.saveConfig("alwaysUmbrella", false)
	end)
	if Config.loadConfig("alwaysUmbrella", false) then
		local action = ActionWheel.MainPage:getAction(6)
		action:toggled(true)
		action:hoverColor(0.33, 1, 0.33)
	end

    --アクション1-7. 頻出メッセージの表示
	ActionWheel.MainPage:newAction(7):title(Language.getTranslate("action_wheel__main__action_7__title")..Language.getTranslate("action_wheel__toggle_off")):toggleTitle(Language.getTranslate("action_wheel__main__action_7__title")..Language.getTranslate("action_wheel__toggle_on")):item("cake"):color(0.67, 0, 0):hoverColor(1, 0.33, 0.33):toggleColor(0, 0.67, 0):onToggle(function (_, action)
		General.ShowMessage = true
		action:hoverColor(0.33, 1, 0.33)
		Config.saveConfig("showMessage", true)
	end):onUntoggle(function (_, action)
		General.ShowMessage = false
		action:hoverColor(1, 0.33, 0.33)
		Config.saveConfig("showMessage", false)
	end)
	if Config.loadConfig("showMessage", true) then
		local action = ActionWheel.MainPage:getAction(7)
		action:toggled(true)
		action:hoverColor(0.33, 1, 0.33)
	else
		General.ShowMessage = false
	end

    setNameChangeActionTitle()
    action_wheel:setPage(ActionWheel.MainPage)
end

return ActionWheel