---@class SitDownClass おすわりアクションを制御するクラス
---@field SitDownClass.CanSitDown boolean 現在座れる状況かを返す。

SitDownClass = {}
SitDownClass.CanSitDown = false

---座る
function SitDownClass.sitDown()
	General.setAnimations("PLAY", "sit_down")
	CameraClass.CameraOffset = -0.5
	NameplateClass.NamePlateOffset = -0.5
end

--座っている状態から立ち上がる
function SitDownClass.standUp()
	General.setAnimations("PLAY", "stand_up")
	General.setAnimations("STOP", "sit_down")
	CameraClass.CameraOffset = 0
	NameplateClass.NamePlateOffset = 0
end

events.TICK:register(function ()
	SitDownClass.CanSitDown = player:getPose() == "STANDING" and player:isOnGround() and not player:isInWater() and not player:isInLava() and player:getFrozenTicks() == 0 and not player:getVehicle() and player:getVelocity():length() == 0 and HurtClass.Damaged == "NONE" and not WardenClass.WardenNearby
	if General.isAnimationPlaying("models.main", "sit_down") and not SitDownClass.CanSitDown then
		SitDownClass.standUp()
	end
end)

return SitDownClass