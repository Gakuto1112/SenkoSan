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
		if playerPose == "CROUCHING" then
			for _, armPart in ipairs({rightArm, leftArm}) do
				armPart:setPos(0, 3, 0)
			end
			rightArm:setRot(30 - ((General.hasItem(player:getHeldItem(leftHanded)) ~= "none" and ArmsClass.ItemHeldContradicts[1]) and 15 or 0), 0, 0)
			leftArm:setRot(30 - ((General.hasItem(player:getHeldItem(not leftHanded)) ~= "none" and ArmsClass.ItemHeldContradicts[2]) and 15 or 0), 0, 0)
		else
			for _, armPart in ipairs({rightArm, leftArm}) do
				armPart:setPos(0, 0, 0)
			end
			rightArm:setRot((General.hasItem(player:getHeldItem(leftHanded)) ~= "none" and ArmsClass.ItemHeldContradicts[1]) and -15 or 0, 0, 0)
			leftArm:setRot((General.hasItem(player:getHeldItem(not leftHanded)) ~= "none" and ArmsClass.ItemHeldContradicts[2]) and -15 or 0, 0, 0)
		end
	else
		for _, armPart in ipairs({rightArm, leftArm}) do
			armPart:setPos(0, 0, 0)
			armPart:setRot(0, 0, 0)
		end
	end
end)

return ArmsClass