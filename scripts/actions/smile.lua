---@class Smile 笑顔のアニメーションを制御するクラス

Smile = General.instance({
	---笑顔アニメーションを再生する。
	---@param playSoundParticle boolean パーティクルと効果音を再生するかどうか
	play = function (self, playSoundParticle)
		FaceParts.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
		if playSoundParticle then
			local playerPos = player:getPos()
			sounds:playSound("entity.player.levelup", playerPos, 1, 1.5)
			for _ = 1, 30 do
				particles:newParticle("happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
			end
		end
		self.IsAnimationPlaying = true
		ActionWheel.IsAnimationPlaying = true
		self.AnimationCount = self.AnimationLength
	end,

	---笑顔アニメーションを停止する。
	stop = function (self)
		FaceParts.resetEmotion()
		self.IsAnimationPlaying = false
		ActionWheel.IsAnimationPlaying = false
		self.AnimationCount = 0
	end
}, AnimationAction, function ()
	return not player:isUsingItem() and not Warden.WardenNearby and not Kotatsu.IsAnimationPlaying
end, nil, nil, nil, nil, 40)

return Smile