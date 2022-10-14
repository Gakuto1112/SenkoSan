---@class LegsClass 脚を制御するクラス
---@field LegSwingMultiplayer table 衣装ごとの脚の振り角度の倍率
---@field IsSneaking boolean スニークしているかどうか

LegsClass = {}
LegSwingMultiplayer = {DEFAULT = 0, NIGHTWEAR = 0, DISGUISE = 0, MAID_A = -0.67, MAID_B = -0.83}
IsSneaking = false

events.TICK:register(function ()
	local rightLeg = models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg
	local leftLeg = models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg
	IsSneaking = player:getPose() == "CROUCHING"
	if IsSneaking then
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
	if (playerPose == "STANDING" or playerPose == "CROUCHING" or playerPose == "SWIMMING" or playerPose == "FALL_FLYING") and not player:getVehicle() then
		rightLeg:setRot(vanilla_model.RIGHT_LEG:getOriginRot():mul(LegSwingMultiplayer[CostumeClass.CurrentCostume], 0, 0):add(IsSneaking and 30 or 0, 0, 0))
		leftLeg:setRot(vanilla_model.LEFT_LEG:getOriginRot():mul(LegSwingMultiplayer[CostumeClass.CurrentCostume], 0, 0):add(IsSneaking and 30 or 0, 0, 0))
	else
		rightLeg:setRot()
		leftLeg:setRot()
	end
end)

return LegsClass