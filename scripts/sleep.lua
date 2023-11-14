---@class Sleep ベッドで寝る時の挙動を制御するクラス
Sleep = {
}

---前チックに寝ていたかどうか
---@type boolean
local isSleepingPrev = false

---眠っている目になるまでのカウンター
---@type integer
local sleepEyeCount = 0

events.TICK:register(function()
	local isSleeping = player:getPose() == "SLEEPING"
	if isSleeping then
		if not isSleepingPrev then
			local facing = nil
			local playerPos = player:getPos():floor()
			local playerBlock = world.getBlockState(playerPos)
			if playerBlock.id:find("^minecraft:.+bed$") then
				facing = playerBlock.properties["facing"]
			end
			models.models.main.Avatar:setPos(0, 0, 2)
			models.models.main.Avatar:setRot(-90, -70, 90)
			models.models.main.Avatar.Head:setRot(0, 0, 15)
			Arms.RightArmRotOffset = vectors.vec3(81.1041, -59.4247, 63.7095)
			models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom:setRot(85)
			Sleeve.RightSleeveRotOffset = vectors.vec3(21.1728, -118.7472, -7.096)
			models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom:setRot(50)
			Sleeve.LeftSleeveRotOffset = vectors.vec3(60.2836, 9.3913, 3.4512)
			Physics.TailRotOffset = vectors.vec3(0, -40)
			models.models.main.Avatar.UpperBody.Body.Tails.TailUL:setRot(2.4994, 19.965, 1.7094)
			models.models.main.Avatar.UpperBody.Body.Tails.TailUR:setRot(-20, 35)
			models.models.main.Avatar.UpperBody.Body.Tails.TailLL:setRot(44.1429, 2.5586, 20.2919)
			models.models.main.Avatar.UpperBody.Body.Tails.TailLR:setRot(20, 35)
			models.models.main.Avatar.LowerBody:setRot(0, 0, -20)
			models.models.main.Avatar.LowerBody.RightLeg:setRot(2.5)
			models.models.main.Avatar.LowerBody.RightLeg.RightLegBottom:setRot(-45)
			models.models.main.Avatar.LowerBody.LeftLeg:setRot(40.1265, -23.337, 23.287)
			models.models.main.Avatar.LowerBody.LeftLeg.LeftLegBottom:setRot(-72.5)
			Physics.EnablePyhsics = false
			Sleeve.Moving = false
			local firstPerson = renderer:isFirstPerson()
			if firstPerson then
				models.models.main.Avatar.Head:setVisible(false)
				renderer:setCameraRot(0, facing == "north" and 90 or (facing == "east" and 180 or (facing == "south" and -90 or 0)), 75)
			elseif renderer:isCameraBackwards() then
				renderer:setCameraRot(0, facing == "north" and -90 or (facing == "east" and 0 or (facing == "south" and 90 or 180)))
			else
				renderer:setCameraRot(0, facing == "north" and 90 or (facing == "east" and 180 or (facing == "south" and -90 or 0)))
			end
			sleepEyeCount = 0
		end
		if sleepEyeCount >= 40 then
			FaceParts.setEmotion("CLOSED", "CLOSED", "CLOSED", 1, false)
		end
		sleepEyeCount = sleepEyeCount + 1
	else
		if isSleepingPrev then
			models.models.main.Avatar.Head:setVisible(true)
			models.models.main.Avatar:setPos()
			for _, modelPart in ipairs({models.models.main.Avatar, models.models.main.Avatar.Head, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom, models.models.main.Avatar.UpperBody.Body.Tails.TailUL, models.models.main.Avatar.UpperBody.Body.Tails.TailUR, models.models.main.Avatar.UpperBody.Body.Tails.TailLL, models.models.main.Avatar.UpperBody.Body.Tails.TailLR, models.models.main.Avatar.LowerBody, models.models.main.Avatar.LowerBody.RightLeg, models.models.main.Avatar.LowerBody.RightLeg.RightLegBottom, models.models.main.Avatar.LowerBody.LeftLeg, models.models.main.Avatar.LowerBody.LeftLeg.LeftLegBottom}) do
				modelPart:setRot()
			end
			Arms:resetArmRotOffset()
			Sleeve.RightSleeveRotOffset = vectors.vec3()
			Sleeve.LeftSleeveRotOffset = vectors.vec3()
			Physics.TailRotOffset = vectors.vec3()
			Physics.EnablePyhsics = true
			Sleeve.Moving = true
			renderer:setCameraRot()
		end
	end
	isSleepingPrev = isSleeping
end)

return Sleep