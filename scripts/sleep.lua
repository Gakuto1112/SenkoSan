---@class SleepClass ベッドで寝る時の挙動を制御するクラス
---@field SleepData table 寝た瞬間を検出する為にポーズデータを格納するテーブル
---@field CostumeBeforeSleeping CostumeType 寝る前のコスチュームを保持する変数

SleepClass = {}

SleepData = {}
CostumeBeforeSleeping = "DEFAULT"

events.TICK:register(function()
	local head = models.models.main.Avatar.Head
	local isSleeping = player:getPose() == "SLEEPING"
	local isFirstPerson = renderer:isFirstPerson()
	table.insert(SleepData, isSleeping)
	if #SleepData == 3 then
		table.remove(SleepData, 1)
	end
	if isSleeping then
		if not SleepData[1] then
			General.setAnimations("PLAY", "sleep")
			CostumeBeforeSleeping = CostumeClass.CurrentCostume
			CostumeClass.setCostume("NIGHTWEAR")
			head:setParentType("None")
			ArmsClass.ItemHeldContradicts = {true, true}
			if isFirstPerson then
				head:setVisible(false)
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
		EarsClass.setEarsRot("DROOPING", 1, true)
		if not WardenClass.WardenNearby then
			FacePartsClass.setEmotion("CLOSED", "CLOSED", "CLOSED", 1, false)
		end
	else
		if SleepData[1] then
			General.setAnimations("STOP", "sleep")
			if CostumeBeforeSleeping == "DEFAULT" then
				CostumeClass.resetCostume()
			else
				CostumeClass.setCostume(CostumeBeforeSleeping)
			end
			head:setParentType("Head")
			head:setVisible(true)
			ArmsClass.ItemHeldContradicts = {false, false}
			renderer:setCameraRot()
		end
	end
end)

return SleepClass