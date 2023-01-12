---@class Ears けも耳を制御するクラス
---@field EyeTypeID table EarsRotTupeと角度を紐付けるテーブル
---@field Ears.EarsRotCount integer 耳の角度を変更するの時間を計るカウンター
---@field Ears.JerkEarsKey Keybind 耳を動かすキー
---@field Ears.EnableJerkEar boolean 耳を動かす機能を有効にするかどうか
---@field Ears.JerkEarsCount integer 耳を動かす時間を計るカウンター

---@alias EarsRotType
---| "STAND"
---| "SLIGHTLY_DROOPING"
---| "DROOPING"

Ears = {
	EarsRotTypeID = {STAND = 0, SLIGHTLY_DROOPING = -20, DROOPING = -40},
	EarsRotCount = 0,
	JerkEarsKey = keybinds:newKeybind(Language.getTranslate("key_name__jerk_ears"), Config.loadConfig("keybind.jerkEars", "key.keyboard.x")),
	EnableJerkEar = true,
	JerkEarsCount = 0,

	---耳の角度を設定する。
	---@param earRot EarsRotType 設定する耳の垂れ具合
	---@param duration integer この耳の角度をを有効にする時間
	---@param force boolean trueにすると以前のタイマーが残っていても強制的に適用する。
	setEarsRot = function (earRot, duration, force)
		if Ears.EarsRotCount == 0 or force then
			models.models.main.Avatar.Head.Ears:setRot(Ears.EarsRotTypeID[earRot], 0, 0)
			Ears.EarsRotCount = duration
		end
	end
}

--ping関数
function pings.jerk_ears()
	for _, animation in ipairs({animations["models.main"]["jerk_ears"], animations["models.costume_knit"]["jerk_ears"], animations["models.costume_fox_hood"]["jerk_ears"]}) do
		animation:play()
	end
	sounds:playSound("entity.egg.throw", player:getPos(), 0.25, 2)
	Ears.JerkEarsCount = 5
end

events.TICK:register(function ()
	if Ears.EarsRotCount == 0 then
		Ears.setEarsRot((General.PlayerCondition == "LOW" or player:getFrozenTicks() == 140) and "DROOPING" or (General.PlayerCondition == "MEDIUM" and "SLIGHTLY_DROOPING" or "STAND"), 0, false)
	end
	if not Ears.JerkEarsKey:isDefault() then
		local newKey = Ears.JerkEarsKey:getKey()
		Config.saveConfig("keybind.jerkEars", newKey)
		Ears.JerkEarsKey:setKey(newKey)
	end
	Ears.EarsRotCount = Ears.EarsRotCount > 0 and (client:isPaused() and Ears.EarsRotCount or Ears.EarsRotCount - 1) or 0
	Ears.JerkEarsCount = Ears.JerkEarsCount > 0 and (client:isPaused() and Ears.JerkEarsCount or Ears.JerkEarsCount - 1) or 0
end)

Ears.JerkEarsKey:onPress(function ()
	if Ears.JerkEarsCount == 0 and Ears.EnableJerkEar then
		pings.jerk_ears()
	end
end)

return Ears