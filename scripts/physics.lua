---@class Physics 物理演算（もどき）を制御するクラス
---@field Physics.VelocityData table 速度データ：1. 前後, 2. 上下, 3. 左右, 4. 角速度
---@field Physics.VelocityAverage table 速度の平均値：1. 前後, 2. 上下, 3. 左右, 4. 角速度
---@field Physics.LookRotPrevRender number 前レンダーチックのlookRot
---@field Physics.LookRotDeltaPrevRender number 前レンダーチックのlookRotDelta
---@field Physics.EnablePyhsics boolean 物理演算を有効にするかどうか：1. 尻尾, 2. 髪飾り

Physics = {
	VelocityData = {{}, {}, {}, {}},
	VelocityAverage = {0, 0, 0, 0},
	LookRotPrevRender = 0,
	LookRotDeltaPrevRender = 0,
	EnablePyhsics = {true, true}
}

events.RENDER:register(function ()
	local lookDir = player:getLookDir()
	local lookRot = math.deg(math.atan2(lookDir.z, lookDir.x))
	local FPS = client:getFPS()
	local velocity = player:getVelocity()
	local velocityRot = math.deg(math.atan2(velocity.z, velocity.x))
	velocityRot = velocityRot < 0 and 360 + velocityRot or velocityRot
	local directionAbsFront = math.abs(velocityRot - (lookRot) % 360)
	directionAbsFront = directionAbsFront > 180 and 360 - directionAbsFront or directionAbsFront
	local directionAbsRight = math.abs(velocityRot - (lookRot + 90) % 360)
	directionAbsRight = directionAbsRight > 180 and 360 - directionAbsRight or directionAbsRight
	local relativeVelocity = {math.sqrt(velocity.x ^ 2 + velocity.z ^ 2) * math.cos(math.rad(directionAbsFront)), math.sqrt(velocity.x ^ 2 + velocity.z ^ 2) * math.cos(math.rad(directionAbsRight))}
	Physics.VelocityAverage[1] = (#Physics.VelocityData[1] * Physics.VelocityAverage[1] + relativeVelocity[1]) / (#Physics.VelocityData[1] + 1)
	table.insert(Physics.VelocityData[1], relativeVelocity[1])
	Physics.VelocityAverage[2] = (#Physics.VelocityData[2] * Physics.VelocityAverage[2] + velocity.y) / (#Physics.VelocityData[2] + 1)
	table.insert(Physics.VelocityData[2], velocity.y)
	Physics.VelocityAverage[3] = (#Physics.VelocityData[3] * Physics.VelocityAverage[3] + relativeVelocity[2]) / (#Physics.VelocityData[3] + 1)
	table.insert(Physics.VelocityData[3], relativeVelocity[2])
	local lookRotDelta = lookRot - Physics.LookRotPrevRender
	lookRotDelta = lookRotDelta > 180 and 360 - lookRotDelta or (lookRotDelta < -180 and 360 + lookRotDelta or lookRotDelta)
	local lookRotDeltaPerSecond = lookRotDelta * FPS
	if lookRotDelta < 20 and lookRotDelta ~= Physics.LookRotDeltaPrevRender then
		Physics.VelocityAverage[4] = (#Physics.VelocityData[4] * Physics.VelocityAverage[4] + lookRotDeltaPerSecond) / (#Physics.VelocityData[4] + 1)
		table.insert(Physics.VelocityData[4], lookRotDeltaPerSecond)
	else
		Physics.VelocityAverage[4] = (#Physics.VelocityData[4] * Physics.VelocityAverage[4]) / (#Physics.VelocityData[4] + 1)
		table.insert(Physics.VelocityData[4], 0)
	end
	--古いデータの切り捨て
	for index, velocityTable in ipairs(Physics.VelocityData) do
		while #velocityTable > FPS * 0.25 do
			if #velocityTable >= 2 then
				Physics.VelocityAverage[index] = (#velocityTable * Physics.VelocityAverage[index] - velocityTable[1]) / (#velocityTable - 1)
			end
			table.remove(velocityTable, 1)
		end
	end
	--求めた平均速度から尻尾の角度を計算
	local tail = models.models.main.Avatar.Body.BodyBottom.Tail
	local frontHair = models.models.main.Avatar.Body.Hairs.FrontHair
	local backHair = models.models.main.Avatar.Body.Hairs.BackHair
	if (not renderer:isFirstPerson() or client:hasIrisShader()) and (Physics.EnablePyhsics[1] or Physics.EnablePyhsics[2]) then
		local rotLimit = {{{-60, 60}, {-30, 30}}, {{2, 80}, {-80, -2}}} --物理演算の可動範囲：1. 尻尾：{1-1. 上下方向, 1-2. 左右方向}, 2. 長髪：{2-1. 前髪, 2-2. 後髪}
		local playerPose = player:getPose()
		if SitDown.IsAnimationPlaying or player:getVehicle() then
			rotLimit[1][1][2] = 10
		end
		if not Armor.ArmorVisible[3] then
			if Costume.CurrentCostume == "MAID_A" then
				rotLimit[2][2][2] = -15
			elseif Costume.CurrentCostume == "MAID_B" then
				rotLimit[2][2][2] = -5
			elseif Costume.CurrentCostume == "SWIMSUIT" or Costume.CurrentCostume == "CHEERLEADER" or Costume.CurrentCostume == "SAILOR" then
				rotLimit[2][2][2] = -10
			end
		end
		local tailRot = vectors.vec3(0, 0, 0)
		local frontHairRot = vectors.vec3(0, 0, 0)
		local backHairRot = vectors.vec3(0, 0, 0)
		if playerPose == "FALL_FLYING" then
			if Physics.EnablePyhsics[1] then
				tailRot = vectors.vec3(math.clamp(Physics.VelocityAverage[1] * 80, rotLimit[1][1][1], rotLimit[1][1][2]), math.clamp(-Physics.VelocityAverage[4] * 0.1, rotLimit[1][2][1], rotLimit[1][2][2]), 0)
			end
			if Physics.EnablePyhsics[2] then
				frontHairRot = vectors.vec3(math.clamp(rotLimit[2][1][2] - math.sqrt(Physics.VelocityAverage[1] ^ 2 + Physics.VelocityAverage[2] ^ 2) * 80, rotLimit[2][1][1], rotLimit[2][1][2]), 0, 0)
				backHairRot = vectors.vec3(rotLimit[2][2][2])
			end
		elseif playerPose == "SWIMMING" then
			if Physics.EnablePyhsics[1] then
				tailRot = vectors.vec3(math.clamp(Physics.VelocityAverage[1] * 320, rotLimit[1][1][1], rotLimit[1][1][2]), math.clamp(-Physics.VelocityAverage[4] * 0.2, rotLimit[1][2][1], rotLimit[1][2][2]), 0)
			end
			if Physics.EnablePyhsics[2] then
				frontHairRot = vectors.vec3(math.clamp(rotLimit[2][1][2] - math.sqrt(Physics.VelocityAverage[1] ^ 2 + Physics.VelocityAverage[2] ^ 2) * 320, rotLimit[2][1][1], rotLimit[2][1][2]), 0, 0)
				backHairRot = vectors.vec3(rotLimit[2][2][2])
			end
		else
			if Physics.EnablePyhsics[1] then
				local tailXMoveXZ = (Physics.VelocityAverage[1] + math.abs(Physics.VelocityAverage[3])) * 160
				local tailXMoveY = Physics.VelocityAverage[2] * 80
				local tailXAngleMove = math.abs(Physics.VelocityAverage[4]) * 0.05
				local tailXConditionAngle = (General.PlayerCondition == "LOW" or SitDown.IsAnimationPlaying or player:getVehicle() or Warden.WardenNearby) and 0 or (General.PlayerCondition == "MEDIUM" and 15 or 30)
				tailRot = vectors.vec3(math.clamp(rotLimit[1][1][2] - math.min(tailXMoveXZ, math.max(rotLimit[1][1][2] - tailXMoveY - tailXAngleMove - tailXConditionAngle, 0)) + tailXMoveY - math.min(tailXAngleMove, math.max(rotLimit[1][1][2] - tailXMoveXZ - tailXMoveY - tailXConditionAngle, 0)) - tailXConditionAngle, rotLimit[1][1][1], rotLimit[1][1][2]) + (General.IsSneaking and 30 or 0), math.clamp(-Physics.VelocityAverage[3] * 160 + Physics.VelocityAverage[4] * 0.05, rotLimit[1][2][1], rotLimit[1][2][2]), 0)
			end
			if Physics.EnablePyhsics[2] then
				local hairXMoveX = Physics.VelocityAverage[1] * -160
				local hairXMoveY = Physics.VelocityAverage[2] * 80
				local hairXAngleMove = math.abs(Physics.VelocityAverage[4]) * 0.05
				frontHairRot = vectors.vec3(math.clamp(hairXMoveX - hairXMoveY + hairXAngleMove, rotLimit[2][1][1], rotLimit[2][1][2]), 0, 0)
				backHairRot = vectors.vec3(math.clamp(hairXMoveX + hairXMoveY - hairXAngleMove, rotLimit[2][2][1], rotLimit[2][2][2]), 0, 0)
			end
		end
		tail:setRot(tailRot)
		frontHair:setRot(frontHairRot)
		backHair:setRot(backHairRot)
	else
		tail:setRot(0, 0, 0)
	end
	Physics.LookRotDeltaPrevRender = lookRotDelta
	Physics.LookRotPrevRender = lookRot
end)

return Physics