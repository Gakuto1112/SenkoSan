---@class SleepClass ベッドで寝る時の挙動を制御するクラス
---@field SleepData table 寝た瞬間を検出する為にポーズデータを格納するテーブル
---@field SleepCount integer 睡眠時のタイミングを計るカウンター

SleepClass = {}

SleepData = {}

events.TICK:register(function()
	local head = models.models.main.Avatar.Head
	local rightArm = models.models.main.Avatar.Body.Arms.RightArm
	local leftArm = models.models.main.Avatar.Body.Arms.LeftArm
	local rightLegBottom = models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom
	local leftLegBottom = models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom
	local nightgownTextureParts = {models.models.main.Avatar.Body.Body, models.models.main.Avatar.Body.BodyLayer, models.models.main.Avatar.Body.BodyBottom.BodyBottom, models.models.main.Avatar.Body.BodyBottom.BodyBottomLayer, rightArm.RightArm, rightArm.RightArmLayer, rightArm.RightArmBottom.RightArmBottom, rightArm.RightArmBottom.RightArmBottomLayer, leftArm.LeftArm, leftArm.LeftArmLayer, leftArm.LeftArmBottom.LeftArmBottom, leftArm.LeftArmBottom.LeftArmBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeg, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegLayer, rightLegBottom.RightLegBottom, rightLegBottom.RightLegBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeg, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegLayer, leftLegBottom.LeftLegBottom, leftLegBottom.LeftLegBottomLayer}
	local isSleeping = player:getPose() == "SLEEPING"
	local isFirstPerson = renderer:isFirstPerson()
	if isSleeping then
		if not SleepData[1] then
			General.setAnimations("PLAY", "sleep")
			for _, modelPart in ipairs(nightgownTextureParts) do
				modelPart:setUVPixels(0, 48)
			end
			head:setParentType("None")
			local leftHanded = player:isLeftHanded()
			rightArm:setRot(General.hasItem(player:getHeldItem(leftHanded)) ~= "none" and -15 or 0, 0, 0)
			leftArm:setRot(General.hasItem(player:getHeldItem(not leftHanded)) ~= "none" and -15 or 0, 0, 0)
			rightLegBottom:setPivot(2, 6, -2)
			leftLegBottom:setPivot(-2, 6, -2)
			TailClass.enablePyhsics = false
			if not WardenClass.WardenNearby then
				FacePartsClass.setEmotion("SLEEPY", "SLEEPY", "CLOSED", 40, true)
			end
			if isFirstPerson then
				head:setVisible(false)
			else
				local sleepBlock = world.getBlockState(player:getPos())
				if string.find(sleepBlock.id, "^minecraft:.+bed$") then
					local facingValue = {north = 180, east = -90, south = 0, west = 90}
					if renderer:isCameraBackwards() then
						renderer:setCameraRot(-30, 80 + facingValue[sleepBlock.properties["facing"]], 0)
					else
						renderer:setCameraRot(30, 100 + facingValue[sleepBlock.properties["facing"]], 0)
					end
				end
			end
		end
		if not WardenClass.WardenNearby then
			FacePartsClass.setEmotion("CLOSED", "CLOSED", "CLOSED", 1, false)
		end
	else
		if SleepData[1] then
			General.setAnimations("STOP", "sleep")
			for _, modelPart in ipairs(nightgownTextureParts) do
				modelPart:setUVPixels(0, 0)
			end
			head:setParentType("Head")
			head:setVisible(true)
			rightArm:setRot(0, 0, 0)
			leftArm:setRot(0, 0, 0)
			rightLegBottom:setPivot(2, 6, 0)
			leftLegBottom:setPivot(-2, 6, 0)
			TailClass.enablePyhsics = true
			renderer:setCameraRot()
		end
	end
	table.insert(SleepData, isSleeping)
	if #SleepData == 3 then
		table.remove(SleepData, 1)
	end
end)

return SleepClass