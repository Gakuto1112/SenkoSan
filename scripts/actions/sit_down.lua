---@class SitDown おすわりアクションを制御するクラス

SitDown = General.instance({}, PermanentAnimationAction, function ()
	return player:getPose() == "STANDING" and player:isOnGround() and not player:isInWater() and not player:isInLava() and player:getFrozenTicks() == 0 and not player:getVehicle() and player:getVelocity():length() == 0 and Hurt.Damaged == "NONE" and not Warden.WardenNearby
end, nil, nil, animations["models.main"]["sit_down"], {animations["models.costume_maid_a"]["sit_down"], animations["models.costume_maid_b"]["sit_down"], animations["models.costume_mini_skirt"]["sit_down"]})

---おすわりアニメーションが再生する。
function SitDown.play(self)
	PermanentAnimationAction.play(self)
	Umbrella.EnableUmbrella = true
	Camera.CameraOffset = -0.5
	Nameplate.NamePlateOffset = -0.5
end

---おすわりアニメーションが停止する。
function SitDown.stop(self)
	PermanentAnimationAction.stop(self)
	for _, animation in ipairs({animations["models.main"]["stand_up"], animations["models.costume_maid_a"]["stand_up"], animations["models.costume_maid_b"]["stand_up"], animations["models.costume_mini_skirt"]["stand_up"]}) do
		animation:play()
	end
	ActionWheel.onStandUp()
	Camera.CameraOffset = 0
	Nameplate.NamePlateOffset = 0
end

return SitDown