---@class LegsClass 脚を制御するクラス
---@field LegsClass.ReducedLegSwing boolean 脚の動きを軽減するかどうか（軽減時は0.5になる）

LegsClass = {}
LegsClass.ReducedLegSwing = false

events.TICK:register(function ()
	local rightLeg = models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg
	local leftLeg = models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg
	local rightArmorLeg = models.models.armor.Avatar.Body.BodyBottom.Legs.RightLeg
	local leftArmorLeg = models.models.armor.Avatar.Body.BodyBottom.Legs.LeftLeg
	if player:getPose() == "CROUCHING" then
		for _, legPart in ipairs({rightLeg, leftLeg}) do
			legPart:setPos(0, 4, -4)
		end
		if ArmorClass.ArmorVisible[3] then
			for _, legPart in ipairs({rightArmorLeg, leftArmorLeg}) do
				legPart:setPos(0, 4, -4)
			end
		end
	else
		for _, legPart in ipairs({rightLeg, leftLeg}) do
			legPart:setPos(0, 0, 0)
		end
		if ArmorClass.ArmorVisible[3] then
			for _, legPart in ipairs({rightArmorLeg, leftArmorLeg}) do
				legPart:setPos(0, 0, 0)
			end
		end
	end
end)

events.RENDER:register(function ()
	local rightLeg = models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg
	local leftLeg = models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg
	local rightArmorLeg = models.models.armor.Avatar.Body.BodyBottom.Legs.RightLeg
	local leftArmorLeg = models.models.armor.Avatar.Body.BodyBottom.Legs.LeftLeg
	local playerPose = player:getPose()
	local rightLegRot = General.IsSneaking and 30 or 0
	local leftLegRot = General.IsSneaking and 30 or 0
	if LegsClass.ReducedLegSwing then
		rightLegRot = rightLegRot + vanilla_model.RIGHT_LEG:getOriginRot().x * -0.5
		leftLegRot = leftLegRot + vanilla_model.LEFT_LEG:getOriginRot().x * -0.5
	end
	if (playerPose == "STANDING" or playerPose == "CROUCHING" or playerPose == "SWIMMING" or playerPose == "FALL_FLYING") and not player:getVehicle() and not ArmorClass.ArmorVisible[3] then
		rightLeg:setRot(rightLegRot, 0, 0)
		leftLeg:setRot(leftLegRot, 0, 0)
		if ArmorClass.ArmorVisible[3] then
			rightArmorLeg:setRot(rightLegRot, 0, 0)
			leftArmorLeg:setRot(leftLegRot, 0, 0)
		end
	else
		for _, modelPart in ipairs({rightLeg, leftLeg}) do
			modelPart:setRot()
		end
		if ArmorClass.ArmorVisible[3] then
			for _, modelPart in ipairs({rightArmorLeg, leftArmorLeg}) do
				modelPart:setRot()
			end
		end
	end
end)

return LegsClass