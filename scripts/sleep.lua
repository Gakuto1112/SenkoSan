---@class Sleep ベッドで寝る時の挙動を制御するクラス
---@field Sleep.SleepData table 寝た瞬間を検出する為にポーズデータを格納するテーブル
---@field Sleep.CostumeBeforeSleeping CostumeType 寝る前のコスチュームを保持する変数

Sleep = {}

Sleep.SleepData = {}
Sleep.WardenNearbyPrev = false
Sleep.CostumeBeforeSleeping = "DEFAULT"

events.TICK:register(function()
	local mainModel = models.models.main
	local head = mainModel.Avatar.Head
	local isSleeping = player:getPose() == "SLEEPING"
	local isFirstPerson = renderer:isFirstPerson()
	table.insert(Sleep.SleepData, isSleeping)
	if #Sleep.SleepData == 3 then
		table.remove(Sleep.SleepData, 1)
	end
	if isSleeping then
		if not Sleep.SleepData[1] then
			Physics.EnablePyhsics[1] = false
			if Warden.WardenNearby then
				General.setAnimations("STOP", "afraid")
				General.setAnimations("PLAY", "sleep_afraid")
			else
				General.setAnimations("PLAY", "sleep")
			end
			Sleep.CostumeBeforeSleeping = Costume.CurrentCostume
			Costume.setCostume("NIGHTWEAR")
			head:setParentType("None")
			Arms.ItemHeldContradicts = {true, true}
			if isFirstPerson then
				mainModel:setVisible(false)
				Apron.IsVisible = false
			else
				local sleepBlock = world.getBlockState(player:getPos())
				if string.find(sleepBlock.id, "^minecraft:.+bed$") then
					local facingValue = {north = 180, east = -90, south = 0, west = 90}
					if renderer:isCameraBackwards() then
						renderer:setCameraRot(10, facingValue[sleepBlock.properties["facing"]] + 160, 0)
					else
						renderer:setCameraRot(10, facingValue[sleepBlock.properties["facing"]] + 20, 0)
					end
				end
			end
		end
		if Warden.WardenNearby and not Sleep.WardenNearbyPrev then
			General.setAnimations("STOP", "sleep")
			General.setAnimations("PLAY", "sleep_afraid")
		elseif not Warden.WardenNearby and Sleep.WardenNearbyPrev then
			General.setAnimations("PLAY", "sleep")
			General.setAnimations("STOP", "sleep_afraid")
		end
		Ears.setEarsRot("DROOPING", 1, true)
		if not Warden.WardenNearby then
			FaceParts.setEmotion("CLOSED", "CLOSED", "CLOSED", 1, false)
		end
	else
		if Sleep.SleepData[1] then
			Physics.EnablePyhsics[1] = true
			if Warden.WardenNearby then
				General.setAnimations("PLAY", "afraid")
			end
			General.setAnimations("STOP", "sleep")
			General.setAnimations("STOP", "sleep_afraid")
			if Sleep.CostumeBeforeSleeping == "DEFAULT" then
				Costume.resetCostume()
			else
				Costume.setCostume(Sleep.CostumeBeforeSleeping)
			end
			head:setParentType("Head")
			mainModel:setVisible(true)
			Apron.IsVisible = (Sleep.CostumeBeforeSleeping == "DEFAULT" or Sleep.CostumeBeforeSleeping == "DISGUISE" or Costume.CurrentCostume == "KAPPOGI") and not Armor.ArmorVisible[3]
			Arms.ItemHeldContradicts = {false, false}
			renderer:setCameraRot()
		end
	end
	Sleep.WardenNearbyPrev = Warden.WardenNearby
end)

return Sleep