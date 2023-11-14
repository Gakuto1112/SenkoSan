---@class Umbrella 傘を制御するクラス
---@field Enabled boolean 傘をさせるかどうか（他のクラスから操作）
---@field AlwaysUse boolean （傘をさせる時に）雨が降っていなくても常に傘をさすかどうか
---@field IsUsing boolean 傘をさしているかどうか
---@field IsUsingPrev boolean 前チックに傘をさしていたかどうか
---@field Sound boolean 傘の開閉音を再生するかどうか
Umbrella = {
	Enabled = true,
	AlwaysUse = Config.loadConfig("alwaysUmbrella", false),
	IsUsing = false,
	IsUsingPrev = false,
	Sound = Config.loadConfig("umbrellaSound", true)
}

events.TICK:register(function ()
	local playerPose = player:getPose()
	local activeItem = player:getActiveItem()
	local mainHeldItem = player:getHeldItem()
	local leftHanded = player:isLeftHanded()
	Umbrella.IsUsing = ((player:isInRain() or Umbrella.AlwaysUse) and not player:getHeldItem().id:find("^minecraft:.+_sword$") and player:getHeldItem(true).id == "minecraft:air" and (mainHeldItem.id ~= "minecraft:crossbow" or mainHeldItem.tag["Charged"] == 0)) and not player:isUnderwater() and activeItem.id ~= "minecraft:bow" and activeItem.id ~= "minecraft:crossbow" and not player:getVehicle() and playerPose ~= "FALL_FLYING" and playerPose ~= "SWIMMING" and Umbrella.Enabled
	if Umbrella.IsUsing then
		if not Umbrella.IsUsingPrev and Umbrella.Sound then
			sounds:playSound("minecraft:entity.bat.takeoff", player:getPos(), 0.5, 1.5)
		end
		if Naginata.State[1] <= 1 and Naginata.State[2] <= 1 then
			if leftHanded then
				models.models.main.Avatar.UpperBody.Body.UmbrellaB:setPos(5.5)
				Arms.RightArmRotOffset = SitDown.IsAnimationPlaying and vectors.vec3(0, -10, 15) or vectors.vec3()
			else
				models.models.main.Avatar.UpperBody.Body.UmbrellaB:setPos(-5.5)
				Arms.LeftArmRotOffset = SitDown.IsAnimationPlaying and vectors.vec3(0, 10, -15) or vectors.vec3()
			end
		end
		models.models.main.Avatar.UpperBody.Body.UmbrellaB:setVisible(true)
	else
		if Umbrella.IsUsingPrev and Umbrella.Sound then
			sounds:playSound("minecraft:entity.bat.takeoff", player:getPos(), 0.5, 1.5)
		end
		models.models.main.Avatar.UpperBody.Body.UmbrellaB:setVisible(false)
	end
	Umbrella.IsUsingPrev = Umbrella.IsUsing
end)


return Umbrella