---@class Physics 物理演算（もどき）を制御するクラス
---@field Physics.VelocityData table 速度データ：1. 前後, 2. 上下, 3. 左右, 4. 角速度
---@field Physics.VelocityAverage table 速度の平均値：1. 前後, 2. 上下, 3. 左右, 4. 角速度
---@field Physics.LookRotPrevRender number 前レンダーチックのlookRot
---@field Physics.LookRotDeltaPrevRender number 前レンダーチックのlookRotDelta
---@field Physics.EnablePyhsics boolean 物理演算を有効にするかどうか：1. 尻尾, 2. 髪飾り, 3. 袖

Physics = {
	VelocityData = {{}, {}, {}, {}},
	VelocityAverage = {0, 0, 0, 0},
	LookRotPrevRender = 0,
	LookRotDeltaPrevRender = 0,
	EnablePyhsics = {true, true, true}
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
	local tailRot = vectors.vec3(0, 0, 0)
	local hairAccessoryLineRot = vectors.vec3(0, 0, 0)
	local sleeveRot = {vectors.vec3(0, 0, 0), vectors.vec3(0, 0, 0)}
	local rotLimit = {{{-60, 60}, {-30, 30}}, {{0, 180}, {-90, 90}}, {{-20, 20}, {-20, 20}}, {{-60, 60}, {-70, 70}}} --物理演算の可動範囲：1. 尻尾：{1-1. 上下方向, 1-2. 左右方向}, 2. 髪飾りのヒモ：{2-1. 前後方向, 2-2. 左右方向}, 3. 袖ベース：{3-1. 前後方向, 3-2. 左右方向}, 4. 袖：{4-1. 前後方向, 4-2. 左右方向}
	if (not renderer:isFirstPerson() or client:hasIrisShader()) and (Physics.EnablePyhsics[1] or Physics.EnablePyhsics[2]) then
		local playerPose = player:getPose()
		if SitDown.IsAnimationPlaying or player:getVehicle() then
			rotLimit[1][1][2] = 10
		end
		if playerPose == "FALL_FLYING" then
			if Physics.EnablePyhsics[1] then
				tailRot = vectors.vec3(math.clamp(Physics.VelocityAverage[1] * 80, rotLimit[1][1][1], rotLimit[1][1][2]), math.clamp(-Physics.VelocityAverage[4] * 0.1, rotLimit[1][2][1], rotLimit[1][2][2]))
			end
			if Physics.EnablePyhsics[2] then
				hairAccessoryLineRot = vectors.vec3(math.clamp(60 - Physics.VelocityAverage[1] * 80, rotLimit[2][1][1], rotLimit[2][1][2]), 0, math.clamp(-Physics.VelocityAverage[4] * 0.1, rotLimit[2][2][1], rotLimit[2][2][2]))
			end
			if Physics.EnablePyhsics[3] then
				sleeveRot = {vectors.vec3(math.clamp(90 - vanilla_model.RIGHT_ARM:getOriginRot().x, rotLimit[3][1][1] + rotLimit[3][2][1], rotLimit[3][1][2] + rotLimit[4][1][2])), vectors.vec3(math.clamp(90 - vanilla_model.LEFT_ARM:getOriginRot().x, rotLimit[3][1][1] + rotLimit[4][1][1], rotLimit[3][1][2] + rotLimit[4][1][2]))}
			end
		elseif playerPose == "SWIMMING" then
			if Physics.EnablePyhsics[1] then
				tailRot = vectors.vec3(math.clamp(Physics.VelocityAverage[1] * 320, rotLimit[1][1][1], rotLimit[1][1][2]), math.clamp(-Physics.VelocityAverage[4] * 0.2, rotLimit[1][2][1], rotLimit[1][2][2]))
			end
			if Physics.EnablePyhsics[2] then
				hairAccessoryLineRot = vectors.vec3(math.clamp(60 - Physics.VelocityAverage[1] * 320, rotLimit[2][1][1], rotLimit[2][1][2]), 0, math.clamp(-Physics.VelocityAverage[4] * 0.2, rotLimit[2][2][1], rotLimit[2][2][2]))
			end
			if Physics.EnablePyhsics[3] then
				local rightOriginArmRot = vanilla_model.RIGHT_ARM:getOriginRot()
				local leftOriginArmRot = vanilla_model.LEFT_ARM:getOriginRot()
				sleeveRot = {vectors.vec3(math.clamp(rightOriginArmRot.x >= 90 and -rightOriginArmRot.x + 180 or -rightOriginArmRot.x, rotLimit[3][1][1] + rotLimit[4][1][1], rotLimit[3][1][2] + rotLimit[4][1][2])), vectors.vec3(math.clamp(leftOriginArmRot.x >= 90 and -leftOriginArmRot.x + 180 or -leftOriginArmRot.x, rotLimit[3][1][1] + rotLimit[4][1][1], rotLimit[3][1][2] + rotLimit[4][1][2]))}
			end
		else
			if Physics.EnablePyhsics[1] then
				local tailXMoveXZ = (Physics.VelocityAverage[1] + math.abs(Physics.VelocityAverage[3])) * 160
				local tailXMoveY = Physics.VelocityAverage[2] * 80
				local tailXAngleMove = math.abs(Physics.VelocityAverage[4]) * 0.05
				local tailXConditionAngle = (General.PlayerCondition == "LOW" or SitDown.IsAnimationPlaying or player:getVehicle() or Warden.WardenNearby) and 0 or (General.PlayerCondition == "MEDIUM" and 15 or 30)
				tailRot = vectors.vec3(math.clamp(rotLimit[1][1][2] - math.min(tailXMoveXZ, math.max(rotLimit[1][1][2] - tailXMoveY - tailXAngleMove - tailXConditionAngle, 0)) + tailXMoveY - math.min(tailXAngleMove, math.max(rotLimit[1][1][2] - tailXMoveXZ - tailXMoveY - tailXConditionAngle, 0)) - tailXConditionAngle, rotLimit[1][1][1], rotLimit[1][1][2]) + (General.IsSneaking and 30 or 0), math.clamp(-Physics.VelocityAverage[3] * 160 + Physics.VelocityAverage[4] * 0.05, rotLimit[1][2][1], rotLimit[1][2][2]))
			end
			if Physics.EnablePyhsics[2] then
				local hairAccessoryLineXMoveX = -Physics.VelocityAverage[1] * 160
				local hairAccessoryLineXMoveY = -Physics.VelocityAverage[2] * 160
				local hairAccessoryLineXAngleMove = math.abs(Physics.VelocityAverage[4]) * 0.05
				hairAccessoryLineRot = vectors.vec3(math.clamp(math.min(hairAccessoryLineXMoveX, math.max(90 - hairAccessoryLineXMoveY / 2 - hairAccessoryLineXAngleMove, 0)) + math.clamp(hairAccessoryLineXMoveY, math.min(hairAccessoryLineXMoveX + hairAccessoryLineXAngleMove, 0), math.max(rotLimit[2][1][2] - hairAccessoryLineXMoveX - hairAccessoryLineXAngleMove, 0)) + math.min(hairAccessoryLineXAngleMove, math.max(90 - hairAccessoryLineXMoveX - hairAccessoryLineXMoveY / 2, 0)) - lookDir.y * 90, rotLimit[2][1][1], rotLimit[2][1][2]), 0, math.clamp(-Physics.VelocityAverage[3] * 90, rotLimit[2][2][1], rotLimit[2][2][2]))
			end
			if Physics.EnablePyhsics[3] then
				local leftHanded = player:isLeftHanded()
				local vehicle = player:getVehicle()
				sleeveRot = {vectors.vec3(math.clamp((Umbrella.Umbrella and leftHanded) and 70 or (90 - vanilla_model.RIGHT_ARM:getOriginRot().x), rotLimit[3][1][1] + rotLimit[4][1][1], rotLimit[3][1][2] + rotLimit[4][1][2]), vehicle and 20 or 0), vectors.vec3(math.clamp((Umbrella.Umbrella and not leftHanded) and 70 or (90 - vanilla_model.LEFT_ARM:getOriginRot().x), rotLimit[3][1][1] + rotLimit[4][1][1], rotLimit[3][1][2] + rotLimit[4][1][2]), vehicle and -20 or 0)}
			end
		end
	end
	models.models.main.Avatar.Body.BodyBottom.Tail:setRot(tailRot)
	for _, modelPart in ipairs(models.models.main.Avatar.Head.HairAccessory.HairAccessoryLines:getChildren()) do
		modelPart:setRot(hairAccessoryLineRot)
	end
	for index, sleeveBase in ipairs({models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase}) do
		sleeveBase:setRot(sleeveRot[index]:copy():applyFunc(function (element, vectorIndex)
			return vectorIndex == 1 and math.clamp(element, rotLimit[3][1][1], rotLimit[3][1][2]) or element
		end))
	end
	for index, sleeve in ipairs({models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase.RightSleeve, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase.LeftSleeve}) do
		sleeve:setRot(sleeveRot[index]:applyFunc(function (element, vectorIndex)
			if vectorIndex == 1 then
				if element >= 0 then
					return math.max(element + rotLimit[3][1][1], 0)
				else
					return math.min(element + rotLimit[3][1][2], 0)
				end
			else
				return element
			end
		end))
	end
	Physics.LookRotDeltaPrevRender = lookRotDelta
	Physics.LookRotPrevRender = lookRot
end)

return Physics