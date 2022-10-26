---@class LegsClass 脚を制御するクラス
---@field LegSwingMultiplayer table 衣装ごとの脚の振り角度の倍率

LegsClass = {}
LegSwingMultiplayer = {MAID_A = -0.67, MAID_B = -0.83}

events.TICK:register(function ()
	local rightLeg = models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg
	local leftLeg = models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg
	local rightArmorLeg = models.models.armor.Avatar.Body.BodyBottom.Legs.RightLeg
	local leftArmorLeg = models.models.armor.Avatar.Body.BodyBottom.Legs.LeftLeg
	local multiplayer = LegSwingMultiplayer[CostumeClass.CurrentCostume] and LegSwingMultiplayer[CostumeClass.CurrentCostume] or 0
	local playerPose = player:getPose()
	local rightLegRot = vanilla_model.RIGHT_LEG:getOriginRot().x * multiplayer + (playerPose == "CROUCHING" and 30 or 0)
	local leftLegRot = vanilla_model.LEFT_LEG:getOriginRot().x * multiplayer + (playerPose == "CROUCHING" and 30 or 0)
	if playerPose == "CROUCHING" then
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
	if (playerPose == "STANDING" or playerPose == "CROUCHING" or playerPose == "SWIMMING" or playerPose == "FALL_FLYING") and not player:getVehicle() then
		rightLeg:setRot(rightLegRot, 0, 0)
		leftLeg:setRot(leftLegRot, 0, 0)
		if ArmorClass.ArmorVisible[3] then
			rightArmorLeg:setRot(rightLegRot, 0, 0)
			leftArmorLeg:setRot(leftLegRot, 0, 0)
		end
	else
		for _, modelPart in ipairs({rightLeg, leftLeg}) do
			modelPart:setRot(0, 0, 0)
		end
		if ArmorClass.ArmorVisible[3] then
			for _, modelPart in ipairs({rightArmorLeg, leftArmorLeg}) do
				modelPart:setRot(0, 0, 0)
			end
		end
	end
end)

return LegsClass