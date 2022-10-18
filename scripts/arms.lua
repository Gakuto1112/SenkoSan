---@class ArmsClass 腕を制御するクラス
---@field ArmsClass.ItemHeldContradicts table アイテムを手に持った際の腕のズレを打ち消すかどうか：1. 右腕, 2. 左腕

ArmsClass = {}
ArmsClass.ItemHeldContradicts = {false, false}

events.TICK:register(function()
	local rightArms = {models.models.main.Avatar.Body.Arms.RightArm, models.models.costume_cheerleader.Avatar.Body.Arms.RightArm}
	local leftArms = {models.models.main.Avatar.Body.Arms.LeftArm, models.models.costume_cheerleader.Avatar.Body.Arms.LeftArm}
	local playerPose = player:getPose()
	local leftHanded = player:isLeftHanded()
	if not renderer:isFirstPerson() then
		local rightArmHeldContradict = General.hasItem(player:getHeldItem(leftHanded)) ~= "none" and ArmsClass.ItemHeldContradicts[1]
		local leftArmHeldContradict = General.hasItem(player:getHeldItem(not leftHanded)) ~= "none" and ArmsClass.ItemHeldContradicts[2]
		if playerPose == "CROUCHING" then
			for _, rightArm in ipairs(rightArms) do
				rightArm:setPos(0, 3, 0)
				rightArm:setRot(30 - (rightArmHeldContradict and 15 or 0), 0, 0)
			end
			for _, leftArm in ipairs(leftArms) do
				leftArm:setPos(0, 3, 0)
				leftArm:setRot(30 - (leftArmHeldContradict and 15 or 0), 0, 0)
			end
		else
			for _, rightArm in ipairs(rightArms) do
				rightArm:setPos(0, 0, 0)
				rightArm:setRot(rightArmHeldContradict and -15 or 0, 0, 0)
			end
			for _, leftArm in ipairs(leftArms) do
				leftArm:setPos(0, 0, 0)
				leftArm:setRot(leftArmHeldContradict and -15 or 0, 0, 0)
			end
		end
	else
		for _, rightArm in ipairs(rightArms) do
			rightArm:setPos(0, 0, 0)
			rightArm:setRot(0, 0, 0)
		end
		for _, leftArm in ipairs(leftArms) do
			leftArm:setPos(0, 0, 0)
			leftArm:setRot(0, 0, 0)
		end
	end
end)

return ArmsClass