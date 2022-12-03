---@class SitDown おすわりアクションを制御するクラス
---@field SitDownClass.CanSitDown boolean 現在座れる状況かを返す。

SitDown = General.instance({}, PermanentAnimationAction, function ()
	return player:getPose() == "STANDING" and player:isOnGround() and not player:isInWater() and not player:isInLava() and player:getFrozenTicks() == 0 and not player:getVehicle() and player:getVelocity():length() == 0 and HurtClass.Damaged == "NONE" and not WardenClass.WardenNearby
end, nil, nil, animations["models.main"]["sit_down"], General.getAnimationsOutOfMain("sit_down"))

---おすわりアニメーションが再生する。
function SitDown.play(self)
	PermanentAnimationAction.play(self)
	CameraClass.CameraOffset = -0.5
	NameplateClass.NamePlateOffset = -0.5
end

---おすわりアニメーションが停止する。
function SitDown.stop(self)
	PermanentAnimationAction.stop(self)
	General.setAnimations("PLAY", "stand_up")
	CameraClass.CameraOffset = 0
	NameplateClass.NamePlateOffset = 0
end

return SitDown