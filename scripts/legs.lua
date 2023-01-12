---@class Legs 脚を制御するクラス
---@field Legs.ReducedLegSwing boolean 脚の動きを軽減するかどうか（軽減時は0.5になる）

Legs = {
	ReducedLegSwing = false
}

events.TICK:register(function ()
	local rightLeg = models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg
	local leftLeg = models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg
	if player:getPose() == "CROUCHING" then
		for _, legPart in ipairs({rightLeg, leftLeg}) do
			legPart:setPos(0, 4, -4)
		end
	else
		for _, legPart in ipairs({rightLeg, leftLeg}) do
			legPart:setPos(0, 0, 0)
		end
	end
end)

events.RENDER:register(function ()
	local rightLeg = models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg
	local leftLeg = models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg
	local playerPose = player:getPose()
	local rightLegRot = General.IsSneaking and 30 or 0
	local leftLegRot = General.IsSneaking and 30 or 0
	if Legs.ReducedLegSwing then
		rightLegRot = rightLegRot + vanilla_model.RIGHT_LEG:getOriginRot().x * -0.5
		leftLegRot = leftLegRot + vanilla_model.LEFT_LEG:getOriginRot().x * -0.5
	end
	if (playerPose == "STANDING" or playerPose == "CROUCHING" or playerPose == "SWIMMING" or playerPose == "FALL_FLYING") and not player:getVehicle() then
		rightLeg:setRot(rightLegRot, 0, 0)
		leftLeg:setRot(leftLegRot, 0, 0)
	else
		for _, modelPart in ipairs({rightLeg, leftLeg}) do
			modelPart:setRot()
		end
	end
end)

return Legs