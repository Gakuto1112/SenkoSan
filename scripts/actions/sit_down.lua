---@class SitDown おすわりアクションを制御するクラス
SitDown = General.instance({
	StandUpCount = -1, --完全に立ち上がるまでのカウント

	---おすわりアニメーションを再生する。
	play = function (self)
		for _, animation in ipairs(self.Animations) do
			animation:loop("HOLD")
			animation:speed(1)
		end
		PermanentAnimationAction.play(self)
		Sleeve.Moving = false
		Umbrella.Enabled = true
		Camera.CameraOffset = -0.5
		Nameplate.NamePlateOffset = -0.5
	end,

	---おすわりアニメーションを停止する。
	stop = function (self)
		for _, modelPart in ipairs(self.PartToHide) do
			modelPart:setVisible(false)
		end
		for _, animationElement in ipairs(self.Animations) do
			animationElement:stop()
		end
		for _, animation in ipairs(self.Animations) do
			animation:loop("ONCE")
			animation:speed(-1)
			animation:play()
		end
		ActionWheel.onStandUp()
		FaceParts.resetEmotion()
		Camera.CameraOffset = 0
		Nameplate.NamePlateOffset = 0
		self.IsAnimationPlaying = false
		self.StandUpCount = math.floor(animations["models.main"]["sit_down"]:getLength() * 20) + 1
	end,

	onTickEvent = function (self)
		PermanentAnimationAction.onTickEvent(self)
		if self.StandUpCount >= 0 then
			if self.StandUpCount == 0 then
				Sleeve.Moving = true
			end
			self.StandUpCount = self.StandUpCount - 1
		end
	end
}, PermanentAnimationAction, function ()
	return player:getPose() == "STANDING" and player:isOnGround() and not player:isInWater() and not player:isInLava() and player:getFrozenTicks() == 0 and not player:getVehicle() and player:getVelocity():length() < 0.001 and Hurt.Damaged == "NONE"
end, nil, nil, animations["models.main"]["sit_down"], nil)

return SitDown