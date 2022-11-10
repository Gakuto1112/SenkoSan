---@class EarsClass けも耳を制御するクラス
---@field EyeTypeID table EarsRotTupeと角度を紐付けるテーブル
---@field EarsRotCount integer 耳の角度を変更するの時間を計るカウンター
---@field JerkEarsKey Keybind 耳を動かすキー
---@field JerkEarsCount integer 耳を動かす時間を計るカウンター

---@alias EarsRotType
---| "STAND"
---| "SLIGHTLY_DROOPING"
---| "DROOPING"

EarsClass = {}

EarsRotTypeID = {STAND = 0, SLIGHTLY_DROOPING = -20, DROOPING = -40}
EarsRotCount = 0
JerkEarsKey = keybind:create(LanguageClass.getTranslate("key_name__jerk_ears"), ConfigClass.loadConfig("keybind.jerkEars", "key.keyboard.x"))
JerkEarsCount = 0

---耳の角度を設定する。
---@param earRot EarsRotType 設定する耳の垂れ具合
---@param duration integer この耳の角度をを有効にする時間
---@param force boolean trueにすると以前のタイマーが残っていても強制的に適用する。
function EarsClass.setEarsRot(earRot, duration, force)
	if EarsRotCount == 0 or force then
		models.models.main.Avatar.Head.Ears:setRot(EarsRotTypeID[earRot], 0, 0)
		EarsRotCount = duration
	end
end

---耳の角度をリセットする。
function EarsClass.resetEarsRot()
	EarsRotCount = 0
end

--ping関数
function pings.jerk_ears()
	General.setAnimations("PLAY", "jerk_ears")
	sounds:playSound("entity.egg.throw", player:getPos(), 0.25, 2)
	JerkEarsCount = 5
end

events.TICK:register(function ()
	if EarsRotCount == 0 then
		EarsClass.setEarsRot((General.PlayerCondition == "LOW" or player:getFrozenTicks() == 140) and "DROOPING" or (General.PlayerCondition == "MEDIUM" and "SLIGHTLY_DROOPING" or "STAND"), 0, false)
	end
	if not JerkEarsKey:isDefault() then
		local newKey = JerkEarsKey:getKey()
		ConfigClass.saveConfig("keybind.jerkEars", newKey)
		JerkEarsKey:setKey(newKey)
	end
	EarsRotCount = EarsRotCount > 0 and (client:isPaused() and EarsRotCount or EarsRotCount - 1) or 0
	JerkEarsCount = JerkEarsCount > 0 and (client:isPaused() and JerkEarsCount or JerkEarsCount - 1) or 0
end)

JerkEarsKey.onPress = function ()
	if JerkEarsCount == 0 and CostumeClass.CurrentCostume ~= "DISGUISE" then
		pings.jerk_ears()
	end
end

return EarsClass