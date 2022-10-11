---@class SleepClass ベッドで寝る時の挙動を制御するクラス
---@field SleepData table 寝た瞬間を検出する為にポーズデータを格納するテーブル
---@field CostumeBeforeSleeping CostumeType 寝る前のコスチュームを保持する変数

SleepClass = {}

SleepData = {}
WardenNearbyPrev = false
CostumeBeforeSleeping = "DEFAULT"

events.TICK:register(function()
	local mainModel = models.models.main
	local head = mainModel.Avatar.Head
	local isSleeping = player:getPose() == "SLEEPING"
	local isFirstPerson = renderer:isFirstPerson()
	table.insert(SleepData, isSleeping)
	if #SleepData == 3 then
		table.remove(SleepData, 1)
	end
	if isSleeping then
		if not SleepData[1] then
			if WardenClass.WardenNearby then
				General.setAnimations("STOP", "afraid")
				General.setAnimations("PLAY", "sleep_afraid")
			else
				General.setAnimations("PLAY", "sleep")
			end
			CostumeBeforeSleeping = CostumeClass.CurrentCostume
			CostumeClass.setCostume("NIGHTWEAR")
			head:setParentType("None")
			ArmsClass.ItemHeldContradicts = {true, true}
			if isFirstPerson then
				mainModel:setVisible(false)
			else
				local sleepBlock = world.getBlockState(player:getPos())
				if string.find(sleepBlock.id, "^minecraft:.+bed$") then
					local facingValue = {north = 180, east = -90, south = 0, west = 90}
					if renderer:isCameraBackwards() then
						renderer:setCameraRot(-10, facingValue[sleepBlock.properties["facing"]] - 20, 0)
					else
						renderer:setCameraRot(10, facingValue[sleepBlock.properties["facing"]] + 20, 0)
					end
				end
			end
		end
		if WardenClass.WardenNearby and not WardenNearbyPrev then
			General.setAnimations("STOP", "sleep")
			General.setAnimations("PLAY", "sleep_afraid")
		elseif not WardenClass.WardenNearby and WardenNearbyPrev then
			General.setAnimations("PLAY", "sleep")
			General.setAnimations("STOP", "sleep_afraid")
		end
		EarsClass.setEarsRot("DROOPING", 1, true)
		if not WardenClass.WardenNearby then
			FacePartsClass.setEmotion("CLOSED", "CLOSED", "CLOSED", 1, false)
		end
	else
		if SleepData[1] then
			if WardenClass.WardenNearby then
				General.setAnimations("PLAY", "afraid")
			end
			General.setAnimations("STOP", "sleep")
			General.setAnimations("STOP", "sleep_afraid")
			if CostumeBeforeSleeping == "DEFAULT" then
				CostumeClass.resetCostume()
			else
				CostumeClass.setCostume(CostumeBeforeSleeping)
			end
			head:setParentType("Head")
			mainModel:setVisible(true)
			ArmsClass.ItemHeldContradicts = {false, false}
			renderer:setCameraRot()
		end
	end
	WardenNearbyPrev = WardenClass.WardenNearby
end)

return SleepClass