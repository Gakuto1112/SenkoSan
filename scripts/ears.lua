---@alias EarsRotType
---| "STAND"
---| "SLIGHTLY_DROOPING"
---| "DROOPING"

---@class Ears けも耳を制御するクラス
---@field EyeTypeID { [string]: integer } EarsRotTupeと角度を紐付けるテーブル
---@field EarsRotCount integer 耳の角度を変更するの時間を計るカウンター
---@field EnableJerkEar boolean 耳を動かす機能を有効にするかどうか
---@field JerkEarsCount integer 耳を動かす時間を計るカウンター
Ears = {
	EarsRotTypeID = {STAND = 0, SLIGHTLY_DROOPING = -20, DROOPING = -40},
	EarsRotCount = 0,
	EnableJerkEar = true,
	JerkEarsCount = 0,

	---耳の角度を設定する。
	---@param earRot EarsRotType 設定する耳の垂れ具合
	---@param duration integer この耳の角度をを有効にする時間
	---@param force boolean trueにすると以前のタイマーが残っていても強制的に適用する。
	setEarsRot = function (earRot, duration, force)
		if Ears.EarsRotCount == 0 or force then
			for _, modelPart in ipairs({models.models.main.Avatar.Head.Ears, models.models.main.Avatar.Head.ArmorH.Helmet.Ears}) do
				modelPart:setRot(Ears.EarsRotTypeID[earRot])
			end
			Ears.EarsRotCount = duration
		end
	end
}

--ping関数
function pings.jerk_ears()
	for _, modelAnimation in ipairs({animations["models.main"], animations["models.armor"]}) do
		modelAnimation["jerk_ears"]:play()
	end
	sounds:playSound("entity.egg.throw", player:getPos(), 0.25, 2)
	Ears.JerkEarsCount = 5
end

events.TICK:register(function ()
	if Ears.EarsRotCount == 0 then
		Ears.setEarsRot((General.PlayerCondition == "LOW" or player:getFrozenTicks() == 140) and "DROOPING" or (General.PlayerCondition == "MEDIUM" and "SLIGHTLY_DROOPING" or "STAND"), 0, false)
	end
	Ears.EarsRotCount = Ears.EarsRotCount > 0 and (client:isPaused() and Ears.EarsRotCount or Ears.EarsRotCount - 1) or 0
	Ears.JerkEarsCount = Ears.JerkEarsCount > 0 and (client:isPaused() and Ears.JerkEarsCount or Ears.JerkEarsCount - 1) or 0
end)

KeyManager.register("jerk_ears", "key.keyboard.x", function ()
	if Ears.JerkEarsCount == 0 and Ears.EnableJerkEar then
		pings.jerk_ears()
	end
end)

return Ears