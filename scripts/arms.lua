---@class ArmsClass 腕を制御するクラス
---@field ArmsClass.ItemHeldContradicts table アイテムを手に持った際の腕のズレを打ち消すかどうか：1. 右腕, 2. 左腕

ArmsClass = {}
ArmsClass.ItemHeldContradicts = {false, false}

events.TICK:register(function()
	local rightArm = models.models.main.Avatar.Body.Arms.RightArm
	local leftArm = models.models.main.Avatar.Body.Arms.LeftArm
	local playerPose = player:getPose()
	local leftHanded = player:isLeftHanded()
	if not renderer:isFirstPerson() then
		local rightArmHeldContradict = General.hasItem(player:getHeldItem(leftHanded)) ~= "none" and ArmsClass.ItemHeldContradicts[1]
		local leftArmHeldContradict = General.hasItem(player:getHeldItem(not leftHanded)) ~= "none" and ArmsClass.ItemHeldContradicts[2]
		if playerPose == "CROUCHING" then
			rightArm:setPos(0, 3, 0)
			rightArm:setRot(30 - (rightArmHeldContradict and 15 or 0), 0, 0)
			leftArm:setPos(0, 3, 0)
			leftArm:setRot(30 - (leftArmHeldContradict and 15 or 0), 0, 0)
		else
			rightArm:setPos(0, 0, 0)
			rightArm:setRot(rightArmHeldContradict and -15 or 0, 0, 0)
			leftArm:setPos(0, 0, 0)
			leftArm:setRot(leftArmHeldContradict and -15 or 0, 0, 0)
		end
	else
		rightArm:setPos(0, 0, 0)
		rightArm:setRot(0, 0, 0)
		leftArm:setPos(0, 0, 0)
		leftArm:setRot(0, 0, 0)
	end
end)

return ArmsClass