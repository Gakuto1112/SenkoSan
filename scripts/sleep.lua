---@class Sleep ベッドで寝る時の挙動を制御するクラス
---@field Sleep.IsSleepingPrev boolean 前チックに寝ていたかどうか
---@field Sleep.PlayerCheckCount integer 添い寝チェックのカウンター
---@field Sleep.SleepStatePrev integer 前チックの睡眠の状態：0. 添い寝なし, 1. 左側にプレイヤー, 2. 右側にプレイヤー, 3. ウォーデン
---@field Sleep.CostumeBeforeSleeping CostumeType 寝る前のコスチュームを保持する変数

Sleep = {
	IsSleepingPrev = false,
	SleepStatePrev = 0,
	CostumeBeforeSleeping = "DEFAULT"
}

events.TICK:register(function()
	local isSleeping = player:getPose() == "SLEEPING"
	if isSleeping then
		if not Sleep.IsSleepingPrev  then
			animations["models.main"]["afraid"]:stop()
			Sleep.CostumeBeforeSleeping = Costume.CurrentCostume
			Costume.setCostume("NIGHTWEAR")
			Physics.EnablePyhsics[1] = false
			Physics.EnablePyhsics[3] = false
			if renderer:isFirstPerson() then
				models.models.main:setVisible(false)
				Apron.IsVisible = false
			end
		end
		local facing = nil
		local sleepState = 0 --0. 添い寝なし, 1. 左側にプレイヤー, 2. 右側にプレイヤー, 3. ウォーデン
		if Warden.WardenNearby then
			sleepState = 3
		else
			local playerPos = player:getPos()
			local playerBlock = world.getBlockState(playerPos)
			if playerBlock.id:find("^minecraft:.+bed$") then
				facing = playerBlock.properties["facing"]
				local neighborPos = nil --0. 左隣の座標, 1. 右隣の座標
				if facing == "north" then
					neighborPos = {playerPos:copy():add(-1), playerPos:copy():add(1)}
				elseif facing == "east" then
					neighborPos = {playerPos:copy():add(0, 0, -1), playerPos:copy():add(0, 0, 1)}
				elseif facing == "south" then
					neighborPos = {playerPos:copy():add(1), playerPos:copy():add(-1)}
				else
					neighborPos = {playerPos:copy():add(0, 0, 1), playerPos:copy():add(0, 0, -1)}
				end
				for i = 1, 2 do
					local targetBlock = world.getBlockState(neighborPos[i])
					if targetBlock.id:find("^minecraft:.+bed$") and targetBlock.properties["facing"] == facing and targetBlock.properties["occupied"] == "false" then
						sleepState = i
						break
					end
				end
			end
		end
		if sleepState ~= Sleep.SleepStatePrev or not Sleep.IsSleepingPrev then
			for _, animation in ipairs({animations["models.main"]["sleep"], animations["models.main"]["sleep_afraid"]}) do
				animation:stop()
			end
			if sleepState == 0 then
				--0. 添い寝なし
				animations["models.main"]["sleep"]:play()
				if facing then
					local cameraYaw = facing == "north" and 160 or (facing == "east" and -110 or (facing == "south" and -20 or 70))
					renderer:setCameraRot(10, cameraYaw + (renderer:isCameraBackwards() and 180 or 0))
				end
			elseif sleepState == 1 then
				--1. 左側にプレイヤー
			elseif sleepState == 2 then
				--2. 右側にプレイヤー
			elseif sleepState == 3 then
				--3. ウォーデン
				animations["models.main"]["sleep_afraid"]:play()
			end
		end
		Ears.setEarsRot("DROOPING", 1, true)
		if not Warden.WardenNearby then
			FaceParts.setEmotion("CLOSED", "CLOSED", "CLOSED", 1, false)
		end
		Sleep.SleepStatePrev = sleepState
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
end)

return Sleep