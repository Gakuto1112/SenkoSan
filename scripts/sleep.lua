---@class Sleep ベッドで寝る時の挙動を制御するクラス
---@field Sleep.IsSleepingPrev boolean 前チックに寝ていたかどうか
---@field Sleep.CostumeBeforeSleeping CostumeType 寝る前のコスチュームを保持する変数

Sleep = {
	IsSleepingPrev = false,
	WardenNearbyPrev = false,
	CostumeBeforeSleeping = "DEFAULT"
}

events.TICK:register(function()
	local isSleeping = player:getPose() == "SLEEPING"
	local isFirstPerson = renderer:isFirstPerson()
	if isSleeping then
		if not Sleep.IsSleepingPrev  then
			Physics.EnablePyhsics[1] = false
			if Warden.WardenNearby then
				animations["models.main"]["afraid"]:stop()
				animations["models.main"]["sleep_afraid"]:play()
			else
				animations["models.main"]["sleep"]:play()
			end
			Sleep.CostumeBeforeSleeping = Costume.CurrentCostume
			Costume.setCostume("NIGHTWEAR")
			Physics.EnablePyhsics[3] = false
			if isFirstPerson then
				models.models.main:setVisible(false)
				Apron.IsVisible = false
			else
				local sleepBlock = world.getBlockState(player:getPos())
				if string.find(sleepBlock.id, "^minecraft:.+bed$") then
					local facingValue = {north = 180, east = -90, south = 0, west = 90}
					if renderer:isCameraBackwards() then
						renderer:setCameraRot(10, facingValue[sleepBlock.properties["facing"]] + 160)
					else
						renderer:setCameraRot(10, facingValue[sleepBlock.properties["facing"]] + 20)
					end
				end
			end
		end
		if Warden.WardenNearby and not Sleep.WardenNearbyPrev then
			animations["models.main"]["sleep"]:stop()
			animations["models.main"]["sleep_afraid"]:play()
		elseif not Warden.WardenNearby and Sleep.WardenNearbyPrev then
			animations["models.main"]["sleep"]:play()
			animations["models.main"]["sleep_afraid"]:stop()
		end
		Ears.setEarsRot("DROOPING", 1, true)
		if not Warden.WardenNearby then
			FaceParts.setEmotion("CLOSED", "CLOSED", "CLOSED", 1, false)
		end
	else
		if Sleep.IsSleepingPrev then
			Physics.EnablePyhsics[1] = true
			if Warden.WardenNearby then
				animations["models.main"]["afraid"]:play()
			end
			animations["models.main"]["sleep"]:stop()
			animations["models.main"]["sleep_afraid"]:stop()
			if Sleep.CostumeBeforeSleeping == "DEFAULT" then
				Costume.resetCostume()
			else
				Costume.setCostume(Sleep.CostumeBeforeSleeping)
			end
			Physics.EnablePyhsics[3] = true
			models.models.main:setVisible(true)
			Apron.IsVisible = (Sleep.CostumeBeforeSleeping == "DEFAULT" or Sleep.CostumeBeforeSleeping == "DISGUISE" or Costume.CurrentCostume == "KAPPOGI") and not Armor.ArmorVisible[3]
			renderer:setCameraRot()
		end
	end
	Sleep.IsSleepingPrev = isSleeping
	Sleep.WardenNearbyPrev = Warden.WardenNearby
end)

return Sleep