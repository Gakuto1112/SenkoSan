---@class SitDown おすわりアクションを制御するクラス

SitDown = General.instance({
	---おすわりアニメーションを再生する。
	play = function (self)
		PermanentAnimationAction.play(self)
		Kotatsu:stop()
		Umbrella.EnableUmbrella = true
		Camera.CameraOffset = -0.5
		Nameplate.NamePlateOffset = -0.5
	end,

	---おすわりアニメーションを停止する。
	stop = function (self)
		PermanentAnimationAction.stop(self)
		for _, animation in ipairs({animations["models.main"]["stand_up"], animations["models.costume_maid_a"]["stand_up"], animations["models.costume_maid_b"]["stand_up"], animations["models.costume_mini_skirt"]["stand_up"]}) do
			animation:play()
		end
		ActionWheel.onStandUp()
		Camera.CameraOffset = 0
		Nameplate.NamePlateOffset = 0
	end
}, PermanentAnimationAction, function ()
	return player:getPose() == "STANDING" and player:isOnGround() and not player:isInWater() and not player:isInLava() and player:getFrozenTicks() == 0 and not player:getVehicle() and player:getVelocity():length() == 0 and Hurt.Damaged == "NONE" and not Warden.WardenNearby
end, nil, nil, animations["models.main"]["sit_down"], {animations["models.costume_maid_a"]["sit_down"], animations["models.costume_maid_b"]["sit_down"], animations["models.costume_mini_skirt"]["sit_down"]})

return SitDown