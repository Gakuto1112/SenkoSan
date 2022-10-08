---@class FacePartsClass 目と口を制御するクラス
---@field EyeTypeID table EyeTypeとIDを紐付けるテーブル
---@field MouthTypeID table MouthTypeとIDを紐付けるテーブル
---@field EmotionCount integer エモートの時間を計るカウンター
---@field BlinkCount integer 瞬きのタイミングを計るカウンター

FacePartsClass = {}

EyeTypeID = {NONE = -1, NORMAL = 0, SURPLISED = 1, TIRED = 2, SLEEPY = 3, CLOSED = 4, UNEQUAL = 5}
MouthTypeID = {NONE = -1, CLOSED = 0, OPENED = 1}
EmotionCount = 0
BlinkCount = 0

---@alias EyeType
---| "NONE"
---| "NORMAL"
---| "SURPLISED"
---| "TIRED"
---| "SLEEPY"
---| "CLOSED"
---| "UNEQUAL"

---@alias MouthType
---| "NONE"
---| "CLOSED"
---| "OPENED"

---表情を設定する。
---@param rightEye EyeType 設定する右目の名前（"NONE"にすると変更されない）
---@param leftEye EyeType 設定する左目の名前（"NONE"にすると変更されない）
---@param mouth MouthType 設定する口の名前（"NONE"にすると変更されない）
---@param duration integer この表情を有効にする時間
---@param force boolean trueにすると以前のエモーションが再生中でも強制的に現在のエモーションを適用させる。
function FacePartsClass.setEmotion(rightEye, leftEye, mouth, duration, force)
	local rightEyePart = models.models.main.Avatar.Head.FaceParts.Eyes.RightEye.RightEye
	local leftEyePart = models.models.main.Avatar.Head.FaceParts.Eyes.LeftEye.LeftEye
	local mouthPart = models.models.main.Avatar.Head.FaceParts.Mouth
	if EmotionCount == 0 or force then
		--右目
		if EyeTypeID[rightEye] >= 0 then
			rightEyePart:setUVPixels(0, EyeTypeID[rightEye] * 6)
		end
		--左目
		if EyeTypeID[leftEye] >= 0 then
			leftEyePart:setUVPixels(EyeTypeID[leftEye] == 0 and -6 or 0, EyeTypeID[rightEye] * 6)
		end
		--口
		if MouthTypeID[mouth] >= 0 then
			mouthPart:setUVPixels(0, MouthTypeID[mouth] * 2)
		end
		EmotionCount = duration
	end
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
	EmotionCount = EmotionCount > 0 and not client:isPaused() and EmotionCount - 1 or EmotionCount
end)

return FacePartsClass