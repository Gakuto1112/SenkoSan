---@class ShakeBody ブルブルアニメーションを制御するクラス
---@field SnowParticle boolean 雪のパーティクルを表示するかどうか
ShakeBody = General.instance({
	SnowParticle = false,

	---ブルブルアニメーションを再生する。
	---@param snowParticle boolean 雪のパーティクルを表示するかどうか
	play = function (self, snowParticle)
		AnimationAction.play(self)
		Umbrella.Enabled = true
		sounds:playSound("entity.wolf.shake", player:getPos(), 1, 1.5)
		FaceParts.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 20, true)
		ShakeBody.SnowParticle = snowParticle
	end,

	---ブルブルアニメーションを停止する。
	stop = function (self)
		for _, modelPart in ipairs(self.PartToHide) do
			modelPart:setVisible(false)
		end
		for _, animationElement in ipairs(self.Animations) do
			animationElement:stop()
		end
		FaceParts.resetEmotion()
		if not Wet.IsWet then
			Wet.WetCount = 0
		end
		self.IsAnimationPlaying = false
		ActionWheel.IsAnimationPlaying = false
		self.AnimationCount = -1
	end,

	---アニメーション再生中に毎チック実行される関数
	onAnimationTick = function (self)
		AnimationAction.onAnimationTick(self)
		if self.AnimationCount % 5 == 0 then
			if ShakeBody.SnowParticle then
				for _ = 1, 6 do
					particles:newParticle("block snow_block", player:getPos():add(math.random() - 0.5, math.random() + 0.5, math.random() - 0.5))
				end
			elseif not Wet.IsWet and Wet.WetCount > 0 then
				for _ = 1, 4 do
					particles:newParticle("splash", player:getPos():add(math.random() - 0.5, math.random() + 0.5, math.random() - 0.5))
				end
			end
		end
	end
}, AnimationAction, function ()
	return not player:isUnderwater() and not player:isInLava() and not Warden.WardenNearby and not Kotatsu.IsAnimationPlaying
end, nil, nil, animations["models.main"]["shake"], nil, 0)

return ShakeBody