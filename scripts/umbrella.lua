---@class Umbrella 傘を制御するクラス
---@field Umbrella.Umbrella boolean 傘をさしているかどうか
---@field Umbrella.EnableUmbrella boolean 傘をさせるかどうか（他のクラスから操作）
---@field Umbrella.UmbrellaPrev boolean 前チックに傘をさしていたかどうか
---@field Umbrella.UmbrellaSound boolean 傘の開閉音を再生するかどうか

Umbrella = {}
Umbrella.Umbrella = false
Umbrella.EnableUmbrella = true
Umbrella.UmbrellaPrev = false
Umbrella.UmbrellaSound = Config.loadConfig("umbrellaSound", true)

events.TICK:register(function ()
	local playerPose = player:getPose()
	local activeItem = player:getActiveItem()
	local mainHeldItem = player:getHeldItem()
	Umbrella.Umbrella = player:isInRain() and not player:isUnderwater() and activeItem.id ~= "minecraft:bow" and activeItem.id ~= "minecraft:crossbow" and (mainHeldItem.id ~= "minecraft:crossbow" or mainHeldItem.tag["Charged"] == 0) and not player:getVehicle() and playerPose ~= "FALL_FLYING" and playerPose ~= "SWIMMING" and player:getHeldItem(true).id == "minecraft:air" and Umbrella.EnableUmbrella
	local umbrella = models.models.umbrella
	local rightArm = models.models.main.Avatar.Body.Arms.RightArm
	local leftArm = models.models.main.Avatar.Body.Arms.LeftArm
	if Umbrella.Umbrella then
		if not Umbrella.UmbrellaPrev and Umbrella.UmbrellaSound then
			sounds:playSound("minecraft:entity.bat.takeoff", player:getPos(), 0.5, 1.5)
		end
		if player:isLeftHanded() then
			rightArm:setParentType("Body")
			leftArm:setParentType("LeftArm")
			umbrella:setPos(5.5, 0, 0)
			General.setAnimations(SitDown.IsAnimationPlaying and "PLAY" or "STOP", "sit_down_right_umbrella")
		else
			leftArm:setParentType("Body")
			rightArm:setParentType("RightArm")
			umbrella:setPos(-5.5, 0, 0)
			General.setAnimations(SitDown.IsAnimationPlaying and "PLAY" or "STOP", "sit_down_left_umbrella")
		end
		umbrella:setVisible(true)
	else
		if Umbrella.UmbrellaPrev and Umbrella.UmbrellaSound then
			sounds:playSound("minecraft:entity.bat.takeoff", player:getPos(), 0.5, 1.5)
		end
		rightArm:setParentType("RightArm")
		leftArm:setParentType("LeftArm")
		for _, animationName in ipairs({"sit_down_right_umbrella", "sit_down_left_umbrella"}) do
			General.setAnimations("STOP", animationName)
		end
		umbrella:setVisible(false)
	end
	Umbrella.UmbrellaPrev = Umbrella.Umbrella
end)


return Umbrella