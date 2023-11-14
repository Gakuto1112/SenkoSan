---@alias FaceParts.EyeType
---| "NONE"
---| "NORMAL"
---| "SURPLISED"
---| "TIRED"
---| "CLOSED"
---| "ANGRY"

---@alias FaceParts.MouthType
---| "NONE"
---| "CLOSED"
---| "OPENED"

---@alias FaceParts.ComplexionType
---| "NORMAL"
---| "PALE"

---@class FaceParts 目と口を制御するクラス
---@field EyeTypeID { [string]: integer } EyeTypeとIDを紐付けるテーブル
---@field MouthTypeID { [string]: integer } MouthTypeとIDを紐付けるテーブル
---@field ComplexionID { [string]: integer } 顔色とIDを紐付けるテーブル
---@field RightEyeStatus FaceParts.EyeType 現在の右目の状態
---@field EmotionCount integer エモートの時間を計るカウンター
---@field ComplexionCount integer 顔色の時間を計るカウンター
---@field BlinkCount integer 瞬きのタイミングを計るカウンター
---@field Drowned boolean 溺れているかどうか
---@field DrownedPrev boolean 前チックに溺れていたかどうか
FaceParts = {
	EyeTypeID = {NONE = 0, NORMAL = 1, ANGRY = 2, SURPLISED = 3, TIRED = 4, CLOSED = 5},
	MouthTypeID = {NONE = 0, CLOSED = 1, OPENED = 2},
	ComplexionID = {NORMAL = 1, PALE = 2},
	RightEyeStatus = "NORMAL",
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
			if FaceParts.EyeTypeID[rightEye] > 0 then
				rightEyePart:setUVPixels((FaceParts.EyeTypeID[rightEye] - 1) * 6, 0)
			end
			FaceParts.RightEyeStatus = rightEye
			--左目
			if FaceParts.EyeTypeID[leftEye] <= 2 then
				leftEyePart:setUVPixels((FaceParts.EyeTypeID[leftEye] - 1) * 6, 6)
			elseif FaceParts.EyeTypeID[leftEye] > 0 then
				leftEyePart:setUVPixels((FaceParts.EyeTypeID[leftEye] - 1) * 6, 0)
			end
			--口
			if FaceParts.MouthTypeID[mouth] > 0 then
				models.models.main.Avatar.Head.FaceParts.Mouth:setUVPixels((FaceParts.MouthTypeID[mouth] - 1) * 2, 0)
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
			models.models.main.Avatar.Head.FaceParts.Complexion:setUVPixels((FaceParts.ComplexionID[complextion] - 1) * 8, 0)
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
		FaceParts.setEmotion("CLOSED", "CLOSED", "NONE", 2, false)
		FaceParts.BlinkCount = 0
	elseif not client.isPaused() then
		FaceParts.BlinkCount = FaceParts.BlinkCount + 1
	end
	if FaceParts.ComplexionCount == 0 then
		FaceParts.setComplexion(player:getFrozenTicks() > 0 and "PALE" or "NORMAL", 0, false)
	end
	if host:isHost() then
		FaceParts.Drowned = host:getAir() <= 0 and General.getTargetEffect("minecraft.water_breathing") == nil
		if FaceParts.Drowned ~= FaceParts.DrownedPrev then
			pings.setDrowned(FaceParts.Drowned)
			FaceParts.DrownedPrev = FaceParts.Drowned
		end
	end
	FaceParts.EmotionCount = (FaceParts.EmotionCount > 0 and not client:isPaused()) and FaceParts.EmotionCount - 1 or FaceParts.EmotionCount
	FaceParts.ComplexionCount = (FaceParts.ComplexionCount > 0 and not client:isPaused()) and FaceParts.ComplexionCount - 1 or FaceParts.ComplexionCount
end)

return FaceParts