---@class LegsClass 脚を制御するクラス

LegsClass = {}

events.TICK:register(function ()
	local rightLeg = models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg
	local leftLeg = models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg
	if player:getPose() == "CROUCHING" then
		for _, legPart in ipairs({rightLeg, leftLeg}) do
			legPart:setPos(0, 4, -4)
			legPart:setRot(30, 0, 0)
		end
	else
		for _, legPart in ipairs({rightLeg, leftLeg}) do
			legPart:setPos(0, 0, 0)
			legPart:setRot(0, 0, 0)
		end
	end
end)

return LegsClass