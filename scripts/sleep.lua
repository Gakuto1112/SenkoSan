---@class Sleep ベッドで寝る時の挙動を制御するクラス
---@field Sleep.IsSleepingPrev boolean 前チックに寝ていたかどうか
---@field Sleep.WardenNearbyPrev boolean 前チックにウォーデンが近くにいたかどうか
---@field Sleep.PlayerCheckCount integer 添い寝チェックのカウンター
---@field Sleep.CoSleepState Sleep.CoSleepState 添い寝の状態
---@field Sleep.CostumeBeforeSleeping CostumeType 寝る前のコスチュームを保持する変数

---@alias Sleep.CoSleepState
---| "NONE"
---| "LEFT"
---| "RIGHT"

Sleep = {
	IsSleepingPrev = false,
	WardenNearbyPrev = false,
	PlayerCheckCount = 0,
	CoSleepState = "NONE",
	CostumeBeforeSleeping = "DEFAULT"
}

events.TICK:register(function()
	local isSleeping = player:getPose() == "SLEEPING"
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
			if renderer:isFirstPerson() then
				models.models.main:setVisible(false)
				Apron.IsVisible = false
			else
				local sleepBlock = world.getBlockState(player:getPos())
				if sleepBlock.id:find("^minecraft:.+bed$") then
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
			Sleep.PlayerCheckCount = 0
			animations["models.main"]["sleep"]:stop()
			animations["models.main"]["sleep_afraid"]:play()
		elseif not Warden.WardenNearby then
			if Sleep.WardenNearbyPrev then
				animations["models.main"]["sleep"]:play()
				animations["models.main"]["sleep_afraid"]:stop()
			end
			if Sleep.PlayerCheckCount == 1 then
				--添い寝チェック
				local playerPos = player:getPos()
				local sleepBlock = world.getBlockState(playerPos)
				if sleepBlock.id:find("^minecraft:.+bed$") then
					local facing = sleepBlock.properties["facing"]
					local neighborPos = nil
					if facing == "north" then
						neighborPos = {playerPos:copy():add(-1), playerPos:copy():add(1)}
					elseif facing == "east" then
						neighborPos = {playerPos:copy():add(0, 0, -1), playerPos:copy():add(0, 0, 1)}
					elseif facing == "south" then
						neighborPos = {playerPos:copy():add(1), playerPos:copy():add(-1)}
					else
						neighborPos = {playerPos:copy():add(0, 0, 1), playerPos:copy():add(0, 0, -1)}
					end
					local nextBlocks = {world.getBlockState(neighborPos[1]), world.getBlockState(neighborPos[2])}
					local validBeds = {nextBlocks[1].id:find("^minecraft:.+bed$") and nextBlocks[1].properties["facing"] == facing, nextBlocks[2].id:find("^minecraft:.+bed$") and nextBlocks[2].properties["facing"] == facing}
					if validBeds[1] or validBeds[2] then
						local hostName = player:getName()
						local playerFound = {false, false} --1. 左, 2. 右
						for playerName, playerEntity in pairs(world.getPlayers()) do
							if playerName ~= hostName then
								local targetPlayerPos = playerEntity:getPos():floor()
								local isTargetSleeping = playerEntity:getPose() == "SLEEPING"
								if targetPlayerPos == neighborPos[1]:floor() and isTargetSleeping then
									playerFound[1] = true
									if Sleep.CoSleepState == "NONE" then
										--左側にプレイヤーが寝ている
										print("左側にプレイヤーが寝ている")
										Sleep.CoSleepState = "LEFT"
										break
									end
								elseif targetPlayerPos == neighborPos[2]:floor() and isTargetSleeping then
									playerFound[2] = true
								end
							end
						end
						if playerFound[2] and Sleep.CoSleepState ~= "RIGHT" then
							--右側にプレイヤーが寝ている
							print("右側にプレイヤーが寝ている")
							Sleep.CoSleepState = "RIGHT"
						elseif not playerFound[1] and not playerFound[2] and Sleep.CoSleepState ~= "NONE" then
							--添い寝対象なし
							print("添い寝対象なし")
							Sleep.CoSleepState = "NONE"
						end
					end
				end
			end
			Sleep.PlayerCheckCount = Sleep.PlayerCheckCount == 20 and 0 or Sleep.PlayerCheckCount + 1
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
			Sleep.PlayerCheckCount = 0
			renderer:setCameraRot()
		end
	end
	Sleep.IsSleepingPrev = isSleeping
	Sleep.WardenNearbyPrev = Warden.WardenNearby
end)

return Sleep