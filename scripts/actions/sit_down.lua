---@class SitDown おすわりアクションを制御するクラス

SitDown = General.instance({
	StandUpCount = -1, --完全に立ち上がるまでのカウント

	---おすわりアニメーションを再生する。
	play = function (self)
		for _, animation in ipairs(self.Animations) do
			animation:setLoop("HOLD")
			animation:setSpeed(1)
		end
		PermanentAnimationAction.play(self)
		Kotatsu:stop()
		Physics.EnablePyhsics[3] = false
		Umbrella.EnableUmbrella = true
		Camera.CameraOffset = -0.5
		Nameplate.NamePlateOffset = -0.5
	end,

	---おすわりアニメーションを停止する。
	stop = function (self)
		PermanentAnimationAction.stop(self)
		for _, animation in ipairs(self.Animations) do
			animation:setLoop("ONCE")
			animation:setSpeed(-1)
			animation:play()
		end
		ActionWheel.onStandUp()
		Camera.CameraOffset = 0
		Nameplate.NamePlateOffset = 0
		self.StandUpCount = math.floor(animations["models.main"]["sit_down"]:getLength() * 20) + 1
	end,

	onTickEvent = function (self)
		PermanentAnimationAction.onTickEvent(self)
		if self.StandUpCount >= 0 then
			if self.StandUpCount == 0 then
				Physics.EnablePyhsics[3] = true
			end
			self.StandUpCount = self.StandUpCount - 1
		end
	end
}, PermanentAnimationAction, function ()
	return player:getPose() == "STANDING" and player:isOnGround() and not player:isInWater() and not player:isInLava() and player:getFrozenTicks() == 0 and not player:getVehicle() and player:getVelocity():length() == 0 and Hurt.Damaged == "NONE" and not Warden.WardenNearby
end, nil, nil, animations["models.main"]["sit_down"], {animations["models.costume_maid_a"]["sit_down"], animations["models.costume_maid_b"]["sit_down"], animations["models.costume_mini_skirt"]["sit_down"]})

return SitDown