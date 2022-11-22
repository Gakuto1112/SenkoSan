---@class FacePartsClass 目と口を制御するクラス
---@field EyeTypeID table EyeTypeとIDを紐付けるテーブル
---@field MouthTypeID table MouthTypeとIDを紐付けるテーブル
---@field ComplexionID ComplexionType 顔色とIDを紐付けるテーブル
---@field EmotionCount integer エモートの時間を計るカウンター
---@field ComplexionCount integer 顔色の時間を計るカウンター
---@field BlinkCount integer 瞬きのタイミングを計るカウンター

---@alias EyeType
---| "NONE"
---| "NORMAL"
---| "SURPLISED"
---| "TIRED"
---| "CLOSED"
---| "UNEQUAL"
---| "NORMAL_INVERSED"
---| "TIRED_INVERSED"

---@alias MouthType
---| "NONE"
---| "CLOSED"
---| "OPENED"

---@alias ComplexionType
---| "NORMAL"
---| "PALE"
---| "BLUSH"

FacePartsClass = {}

EyeTypeID = {NONE = -1, NORMAL = 0, SURPLISED = 1, TIRED = 2, CLOSED = 3, UNEQUAL = 4, NORMAL_INVERSED = 5, TIRED_INVERSED = 6}
MouthTypeID = {NONE = -1, CLOSED = 0, OPENED = 1}
ComplexionID = {NORMAL = 0, PALE = 1, BLUSH = 2}
EmotionCount = 0
ComplexionCount = 0
BlinkCount = 0

---表情を設定する。
---@param rightEye EyeType 設定する右目の名前（"NONE"にすると変更されない）
---@param leftEye EyeType 設定する左目の名前（"NONE"にすると変更されない）
---@param mouth MouthType 設定する口の名前（"NONE"にすると変更されない）
---@param duration integer この表情を有効にする時間
---@param force boolean trueにすると以前のエモーションが再生中でも強制的に現在のエモーションを適用させる。
function FacePartsClass.setEmotion(rightEye, leftEye, mouth, duration, force)
	local rightEyePart = models.models.main.Avatar.Head.FaceParts.Eyes.RightEye.RightEye
	local leftEyePart = models.models.main.Avatar.Head.FaceParts.Eyes.LeftEye.LeftEye
	if EmotionCount == 0 or force then
		--右目
		if EyeTypeID[rightEye] >= 0 then
			rightEyePart:setUVPixels(EyeTypeID[rightEye] * 6, 0)
		end
		--左目
		if EyeTypeID[leftEye] >= 5 then
			leftEyePart:setUVPixels((EyeTypeID[leftEye] - 4) * 6, 6)
		elseif EyeTypeID[leftEye] >= 0 then
			leftEyePart:setUVPixels(EyeTypeID[leftEye] * 6, EyeTypeID[leftEye] == 0 and 6 or 0)
		end
		--口
		if MouthTypeID[mouth] >= 0 then
			models.models.main.Avatar.Head.FaceParts.Mouth:setUVPixels(MouthTypeID[mouth] * 2, 0)
		end
		EmotionCount = duration
	end
end

---顔色を設定する。
---@param complextion ComplexionType 設定する顔色の名前
---@param duration integer この顔色を有効にする時間
---@param force boolean trueにすると以前の顔色が再生中でも強制的に現在の顔色を適用させる。
function FacePartsClass.setComplexion(complextion, duration, force)
	if ComplexionCount == 0 or force then
		models.models.main.Avatar.Head.FaceParts.Complexion:setUVPixels(ComplexionID[complextion] * 8, 0)
		ComplexionCount = duration
	end
end

---表情をリセットする。
function FacePartsClass.resetEmotion()
	EmotionCount = 0
	ComplexionCount = 0
end

events.TICK:register(function ()
	if EmotionCount == 0 then
		if General.PlayerCondition == "LOW" then
			FacePartsClass.setEmotion("TIRED", "TIRED", "CLOSED", 0, false)
		else
			FacePartsClass.setEmotion("NORMAL", "NORMAL", "CLOSED", 0, false)
		end
	end
	if BlinkCount == 200 then
		if not WardenClass.WardenNearby then
			FacePartsClass.setEmotion("CLOSED", "CLOSED", "NONE", 2, false)
		end
		BlinkCount = 0
	elseif not client.isPaused() then
		BlinkCount = BlinkCount + 1
	end
	if ComplexionCount == 0 then
		FacePartsClass.setComplexion(WardenClass.WardenNearby and "PALE" or "NORMAL", 0, false)
	end
	EmotionCount = (EmotionCount > 0 and not client:isPaused()) and EmotionCount - 1 or EmotionCount
	ComplexionCount = (ComplexionCount > 0 and not client:isPaused()) and ComplexionCount - 1 or ComplexionCount
end)

return FacePartsClass