---@class 腕を制御するクラス

ArmsClass = {}

events.TICK:register(function()
	local rightArm = models.models.main.Avatar.Body.Arms.RightArm
	local leftArm = models.models.main.Avatar.Body.Arms.LeftArm
	local playerPose = player:getPose()
	if playerPose == "CROUCHING" and not renderer:isFirstPerson() then
		for _, armPart in ipairs({rightArm, leftArm}) do
			armPart:setPos(0, 3, 0)
			armPart:setRot(30, 0, 0)
		end
	elseif playerPose ~= "SLEEPING" then
		for _, armPart in ipairs({rightArm, leftArm}) do
			armPart:setPos(0, 0, 0)
			armPart:setRot(0, 0, 0)
		end
	end
end)

return ArmsClass