---@class Sleep ベッドで寝る時の挙動を制御するクラス
---@field IsSleepingPrev boolean 前チックに寝ていたかどうか
---@field SleepStatePrev integer 前チックの睡眠の状態：0. 添い寝なし, 1. 左側にプレイヤー, 2. 右側にプレイヤー, 3. ウォーデン
---@field CostumeBeforeSleeping CostumeType 寝る前のコスチュームを保持する変数
Sleep = {
	IsSleepingPrev = false,
	SleepStatePrev = 0,
	CostumeBeforeSleeping = "DEFAULT"
}

events.TICK:register(function()
	local isSleeping = player:getPose() == "SLEEPING"
	if isSleeping then
		local facing = nil
		local playerPos = player:getPos():floor()
		local playerBlock = world.getBlockState(playerPos)
		if playerBlock.id:find("^minecraft:.+bed$") then
			facing = playerBlock.properties["facing"]
		end
		local sleepState = 0 --0. 添い寝なし, 1. 左側にプレイヤー, 2. 右側にプレイヤー, 3. ウォーデン
		if Warden.WardenNearby then
			sleepState = 3
		elseif facing then
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
		if not Sleep.IsSleepingPrev  then
			animations["models.main"]["afraid"]:stop()
			Sleep.CostumeBeforeSleeping = Costume.CurrentCostume
			Costume.setCostume("NIGHTWEAR")
			if not Warden.WardenNearby then
				if host:isHost() and sleepState >= 1 and sleepState <= 2 and General.ShowMessage then
					print(Language.getTranslate("message__sleep_together"))
				end
			end
			Physics.EnablePyhsics[1] = false
			Sleeve.Moving = false
		end
		if sleepState ~= Sleep.SleepStatePrev or not Sleep.IsSleepingPrev then
			if sleepState ~= Sleep.SleepStatePrev then
				for _, animation in ipairs({animations["models.main"]["sleep"], animations["models.main"]["sleep_afraid"], animations["models.main"]["sleep_together_left"], animations["models.dummy_player"]["sleep_together_left"], animations["models.main"]["sleep_together_right"], animations["models.dummy_player"]["sleep_together_right"]}) do
					animation:stop()
				end
				models.models.dummy_player:setVisible(false)
				renderer:setCameraPos()
				renderer:setCameraRot()
			end
			local isFirstPerson = renderer:isFirstPerson()
			---眠たい目にする
			local function sleepEye()
				if General.PlayerCondition == "LOW" then
					FaceParts.setEmotion("TIRED", "TIRED", "CLOSED", 40, true)
				else
					FaceParts.setEmotion("SLEEPY", "SLEEPY", "CLOSED", 40, true)
				end
			end
			if sleepState == 0 then
				--0. 添い寝なし
				animations["models.main"]["sleep"]:play()
				sleepEye()
				if facing then
					if isFirstPerson then
						renderer:setCameraPos(0, -0.2, 0.2)
						renderer:setCameraRot(10, (facing == "north" and 180 or (facing == "east" and -90 or (facing == "south" and 0 or 90))))
					else
						renderer:setCameraRot(10, (facing == "north" and 160 or (facing == "east" and -110 or (facing == "south" and -20 or 70))) + (renderer:isCameraBackwards() and 180 or 0))
					end
				end
			elseif sleepState == 1 or sleepState == 2 then
				models.models.dummy_player:setVisible(not isFirstPerson)
				sleepEye()
				if sleepState == 1 then
					--1. 左側にプレイヤー
					for _, animation in ipairs({animations["models.main"]["sleep_together_left"], animations["models.dummy_player"]["sleep_together_left"]}) do
						animation:play()
					end
					if facing then
						if isFirstPerson then
							renderer:setCameraPos(0, -0.2, 1)
							renderer:setCameraRot(0, facing == "north" and -90 or (facing == "east" and 0 or (facing == "south" and 90 or 180)), -90)
						else
							renderer:setCameraPos(-0.5, -0.5)
							renderer:setCameraRot(90, facing == "north" and 180 or (facing == "east" and -90 or (facing == "south" and 0 or 90)))
						end
					end
				else
					for _, animation in ipairs({animations["models.main"]["sleep_together_right"], animations["models.dummy_player"]["sleep_together_right"]}) do
						animation:play()
					end
					if facing then
						if isFirstPerson then
							renderer:setCameraPos(0, -0.2, 1)
							renderer:setCameraRot(0, facing == "north" and 90 or (facing == "east" and 180 or (facing == "south" and -90 or 0)), 90)
						else
							renderer:setCameraPos(0.5, -0.5)
							renderer:setCameraRot(90, facing == "north" and 180 or (facing == "east" and -90 or (facing == "south" and 0 or 90)))
						end
					end
				end
			elseif sleepState == 3 then
				--3. ウォーデン
				animations["models.main"]["sleep_afraid"]:play()
				if facing then
					if isFirstPerson then
						renderer:setCameraPos(0, 0.2, 0.4)
						renderer:setCameraRot(35, (facing == "north" and 180 or (facing == "east" and -90 or (facing == "south" and 0 or 90))))
					else
						renderer:setCameraRot(10, (facing == "north" and 160 or (facing == "east" and -110 or (facing == "south" and -20 or 70))) + (renderer:isCameraBackwards() and 180 or 0))
					end
				end
			end
			if isFirstPerson then
				local headVisible = sleepState >= 1 and sleepState <= 2
				for _, modelPart in ipairs({models.models.main.Avatar.Head, models.models.main.Avatar.Head.Ears, models.models.main.Avatar.Head.Cowlick}) do
					modelPart:setVisible(headVisible)
				end
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
			for _, animation in ipairs({animations["models.main"]["sleep"], animations["models.main"]["sleep_afraid"], animations["models.main"]["sleep_together_left"], animations["models.dummy_player"]["sleep_together_left"], animations["models.main"]["sleep_together_right"], animations["models.dummy_player"]["sleep_together_right"]}) do
				animation:stop()
			end
			models.models.dummy_player:setVisible(false)
			if Sleep.CostumeBeforeSleeping == "DEFAULT" then
				Costume.resetCostume()
			else
				Costume.setCostume(Sleep.CostumeBeforeSleeping)
			end
			Sleeve.Moving = true
			models.models.main:setVisible(true)
			renderer:setCameraPos()
			renderer:setCameraRot()
		end
	end
	Sleep.IsSleepingPrev = isSleeping
end)

return Sleep