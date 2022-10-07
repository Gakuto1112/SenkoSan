---@class SitDownClass おすわりアクションを制御するクラス
---@field SitDownClass.CanSitDown boolean 現在座れる状況かを返す。
---@field CameraYOffset number 視点のY方向のずれ

SitDownClass = {}
SitDownClass.CanSitDown = false
CameraYOffset = 0

---座る
function SitDownClass.sitDown()
	General.setAnimations("PLAY", "sit_down")
	General.setAnimations("STOP", "stand_up")
end

--座っている状態から立ち上がる
function SitDownClass.standUp()
	General.setAnimations("PLAY", "stand_up")
	General.setAnimations("STOP", "sit_down")
end

events.TICK:register(function ()
	local velocity = player:getVelocity()
	SitDownClass.CanSitDown = player:getPose() == "STANDING" and player:isOnGround() and not player:getVehicle() and math.sqrt(math.abs(velocity.x ^ 2 + velocity.z ^ 2)) == 0 and HurtClass.Damaged == "NONE" and not WardenClass.WardenNearby
	if animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" and not SitDownClass.CanSitDown then
		SitDownClass.standUp()
	end
	if animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" and renderer:isFirstPerson() then
		General.setAnimations("PLAY", "sit_down_first_person_fix")
	else
		General.setAnimations("STOP", "sit_down_first_person_fix")
	end
end)

events.WORLD_RENDER:register(function ()
	if animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" and CameraYOffset > -0.5 then
		CameraYOffset = math.max(CameraYOffset - 0.5 / client:getFPS() * 6, -0.5)
	elseif animations["models.main"]["sit_down"]:getPlayState() ~= "PLAYING" and CameraYOffset < 0 then
		CameraYOffset = math.min(CameraYOffset + 0.5 / client:getFPS() * 6, 0)
	end
	renderer:offsetCameraPivot(0, CameraYOffset, 0)
end)

return SitDownClass