---@class FaceParts 目と口を制御するクラス
---@field FaceParts.EyeTypeID table EyeTypeとIDを紐付けるテーブル
---@field FaceParts.MouthTypeID table MouthTypeとIDを紐付けるテーブル
---@field FaceParts.ComplexionID table 顔色とIDを紐付けるテーブル
---@field FaceParts.EmotionCount integer エモートの時間を計るカウンター
---@field FaceParts.ComplexionCount integer 顔色の時間を計るカウンター
---@field FaceParts.BlinkCount integer 瞬きのタイミングを計るカウンター
---@field FaceParts.Drowned boolean 溺れているかどうか
---@field FaceParts.DrownedPrev boolean 前チックに溺れていたかどうか

---@alias FaceParts.EyeType
---| "NONE"
---| "NORMAL"
---| "NORMAL_INVERSED"
---| "SURPLISED"
---| "TIRED"
---| "TIRED_INVERSED"
---| "ANGRY"
---| "TEAR"
---| "CLOSED"
---| "UNEQUAL"

---@alias FaceParts.MouthType
---| "NONE"
---| "CLOSED"
---| "OPENED"
---| "TRIANGLE"

---@alias FaceParts.ComplexionType
---| "NORMAL"
---| "PALE"
---| "BLUSH"

FaceParts = {
	EyeTypeID = {NONE = -1, NORMAL = 0, SURPLISED = 1, TIRED = 2, ANGRY = 3, TEAR = 4, CLOSED = 5, UNEQUAL = 6, NORMAL_INVERSED = 7, TIRED_INVERSED = 8},
	MouthTypeID = {NONE = -1, CLOSED = 0, OPENED = 1, TRIANGLE = 2},
	ComplexionID = {NORMAL = 0, PALE = 1, BLUSH = 2},
	EmotionCount = 0,
	ComplexionCount = 0,
	BlinkCount = 0,
	Drowned = false,
	DrownedPrev = false,

	---表情を設定する。
	---@param rightEye FaceParts.EyeType 設定する右目の名前（"NONE"にすると変更されない）
	---@param leftEye FaceParts.EyeType 設定する左目の名前（"NONE"にすると変更されない）
	---@param mouth FaceParts.MouthType 設定する口の名前（"NONE"にすると変更されない）
	---@param duration integer この表情を有効にする時間
	---@param force boolean trueにすると以前のエモーションが再生中でも強制的に現在のエモーションを適用させる。
	setEmotion = function (rightEye, leftEye, mouth, duration, force)
		local rightEyePart = models.models.main.Avatar.Head.FaceParts.Eyes.RightEye.RightEye
		local leftEyePart = models.models.main.Avatar.Head.FaceParts.Eyes.LeftEye.LeftEye
		if FaceParts.EmotionCount == 0 or force then
			--右目
			if FaceParts.EyeTypeID[rightEye] >= 0 then
				rightEyePart:setUVPixels(FaceParts.EyeTypeID[rightEye] * 6, 0)
			end
			--左目
			if FaceParts.EyeTypeID[leftEye] >= 7 then
				leftEyePart:setUVPixels((FaceParts.EyeTypeID[leftEye] - 6) * 6, 6)
			elseif FaceParts.EyeTypeID[leftEye] >= 0 then
				leftEyePart:setUVPixels(FaceParts.EyeTypeID[leftEye] * 6, (FaceParts.EyeTypeID[leftEye] == 0 or FaceParts.EyeTypeID[leftEye] == 3 or FaceParts.EyeTypeID[leftEye] == 4) and 6 or 0)
			end
			--口
			if FaceParts.MouthTypeID[mouth] >= 0 then
				models.models.main.Avatar.Head.FaceParts.Mouth:setUVPixels(FaceParts.MouthTypeID[mouth] * 4, 0)
			end
			FaceParts.EmotionCount = duration
		end
	end,

	---顔色を設定する。
	---@param complextion FaceParts.ComplexionType 設定する顔色の名前
	---@param duration integer この顔色を有効にする時間
	---@param force boolean trueにすると以前の顔色が再生中でも強制的に現在の顔色を適用させる。
	setComplexion = function (complextion, duration, force)
		if FaceParts.ComplexionCount == 0 or force then
			models.models.main.Avatar.Head.FaceParts.Complexion:setUVPixels(FaceParts.ComplexionID[complextion] * 8, 0)
			FaceParts.ComplexionCount = duration
		end
	end,

	---表情をリセットする。
	resetEmotion = function ()
		FaceParts.EmotionCount = 0
		FaceParts.ComplexionCount = 0
	end
}

--ping関数
function pings.setDrowned(newValue)
	FaceParts.Drowned = newValue
end

events.TICK:register(function ()
	if FaceParts.EmotionCount == 0 then
		if FaceParts.Drowned then
			FaceParts.setEmotion("SURPLISED", "SURPLISED", "CLOSED", 0, false)
		elseif General.PlayerCondition == "LOW" then
			FaceParts.setEmotion("TIRED", "TIRED", "CLOSED", 0, false)
		else
			FaceParts.setEmotion("NORMAL", "NORMAL", "CLOSED", 0, false)
		end
	end
	if FaceParts.BlinkCount == 200 then
		if not Warden.WardenNearby then
			FaceParts.setEmotion("CLOSED", "CLOSED", "NONE", 2, false)
		end
		FaceParts.BlinkCount = 0
	elseif not client.isPaused() then
		FaceParts.BlinkCount = FaceParts.BlinkCount + 1
	end
	if FaceParts.ComplexionCount == 0 then
		FaceParts.setComplexion((Warden.WardenNearby or player:getFrozenTicks() == 140) and "PALE" or "NORMAL", 0, false)
	end
	if host:isHost() then
		FaceParts.Drowned = player:getAir() <= 0 and type(General.getTargetEffect("water_breathing")) == "nil"
		if FaceParts.Drowned ~= FaceParts.DrownedPrev then
			pings.setDrowned(FaceParts.Drowned)
			FaceParts.DrownedPrev = FaceParts.Drowned
		end
	end
	FaceParts.EmotionCount = (FaceParts.EmotionCount > 0 and not client:isPaused()) and FaceParts.EmotionCount - 1 or FaceParts.EmotionCount
	FaceParts.ComplexionCount = (FaceParts.ComplexionCount > 0 and not client:isPaused()) and FaceParts.ComplexionCount - 1 or FaceParts.ComplexionCount
end)

return FaceParts