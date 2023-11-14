---@class EmotionAction 表情のアニメーションの抽象クラス
EmotionAction = {
    ---コンストラクタ
	---@param rightEye FaceParts.EyeType 右目の名前（"NONE"にすると変更されない）
	---@param leftEye FaceParts.EyeType 左目の名前（"NONE"にすると変更されない）
	---@param tiredRightEye FaceParts.EyeType 疲弊時の右目の名前（"NONE"にすると変更されない）
	---@param tiredLeftEye FaceParts.EyeType 疲弊時の左目の名前（"NONE"にすると変更されない）
	---@param mouth FaceParts.MouthType 口の名前（"NONE"にすると変更されない）
    ---@param animationCount integer 表情を継続する時間
    new = function (rightEye, leftEye, tiredRightEye, tiredLeftEye, mouth, animationCount)
        local instance = General.instance(EmotionAction, AnimationAction, function ()
            return true
        end, nil, nil, nil, nil, 0)
		instance.AnimationLength = animationCount
        instance.RightEye = rightEye
        instance.LeftEye = leftEye
        instance.TiredRightEye = tiredRightEye
        instance.TiredLeftEye = tiredLeftEye
        instance.Mouth = mouth
        return instance
    end,

    ---表情アクションを再生する。
    play = function (self)
        if General.PlayerCondition == "LOW" then
            FaceParts.setEmotion(self.TiredRightEye, self.TiredLeftEye, self.Mouth, self.AnimationCount, true)
        else
            FaceParts.setEmotion(self.RightEye, self.LeftEye, self.Mouth, self.AnimationCount, true)
        end
		self.IsAnimationPlaying = true
		ActionWheel.IsAnimationPlaying = true
		self.AnimationCount = self.AnimationLength
    end,

    ---表情アクションを停止する。
    stop = function (self)
		FaceParts.resetEmotion()
		self.IsAnimationPlaying = false
		ActionWheel.IsAnimationPlaying = false
		self.AnimationCount = -1
    end
}

return EmotionAction