---@class TailClass 尻尾を制御するクラス
---@field VelocityData table 速度データ：1. 前後, 2. 上下, 3. 左右, 4. 角速度
---@field VelocityAverage table 速度の平均値：1. 前後, 2. 上下, 3. 左右, 4. 角速度
---@field LookRotPrevRender number 前レンダーチックのlookRot
---@field LookRotDeltaPrevRender number 前レンダーチックのlookRotDelta
---@field TailClass.EnablePyhsics boolean 尻尾の動的角度設定を有効にするかどうか
---@field WagTailKey Keybind 尻尾振りをするキー
---@field WagTailCount integer 尻尾振りの時間を計るカウンター

TailClass = {}

VelocityData = {{}, {}, {}, {}}
VelocityAverage = {0, 0, 0, 0}
LookRotPrevRender = 0
LookRotDeltaPrevRender = 0
TailClass.EnablePyhsics = true
WagTailKey = keybind:create(LanguageClass.getTranslate("key_name__wag_tail"), ConfigClass.KiyBinds.WagTail)
WagTailCount = -1

--ping関数
---尻尾を振る
function pings.wag_tail()
	General.setAnimations("PLAY", "wag_tail")
	WagTailCount = 25
end

events.TICK:register(function ()
	if WetClass.WetCount == 0 then
		if WagTailCount == 18 then
			sounds:playSound("block.grass.step", player:getPos(), 1, 1)
		elseif WagTailCount == 25 or WagTailCount == 13 then
			sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
		end
	end
	WagTailCount = WagTailCount > 0 and WagTailCount - 1 or 0
end)

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
	VelocityAverage[1] = (#VelocityData[1] * VelocityAverage[1] + relativeVelocity[1]) / (#VelocityData[1] + 1)
	table.insert(VelocityData[1], relativeVelocity[1])
	VelocityAverage[2] = (#VelocityData[2] * VelocityAverage[2] + velocity.y) / (#VelocityData[2] + 1)
	table.insert(VelocityData[2], velocity.y)
	VelocityAverage[3] = (#VelocityData[3] * VelocityAverage[3] + relativeVelocity[2]) / (#VelocityData[3] + 1)
	table.insert(VelocityData[3], relativeVelocity[2])
	local lookRotDelta = lookRot - LookRotPrevRender
	lookRotDelta = lookRotDelta > 180 and 360 - lookRotDelta or (lookRotDelta < -180 and 360 + lookRotDelta or lookRotDelta)
	local lookRotDeltaPerSecond = lookRotDelta * FPS
	if lookRotDelta < 20 and lookRotDelta ~= LookRotDeltaPrevRender then
		VelocityAverage[4] = (#VelocityData[4] * VelocityAverage[4] + lookRotDeltaPerSecond) / (#VelocityData[4] + 1)
		table.insert(VelocityData[4], lookRotDeltaPerSecond)
	else
		VelocityAverage[4] = (#VelocityData[4] * VelocityAverage[4]) / (#VelocityData[4] + 1)
		table.insert(VelocityData[4], 0)
	end
	--古いデータの切り捨て
	for index, velocityTable in ipairs(VelocityData) do
		while #velocityTable > FPS * 0.25 do
			if #velocityTable >= 2 then
				VelocityAverage[index] = (#velocityTable * VelocityAverage[index] - velocityTable[1]) / (#velocityTable - 1)
			end
			table.remove(velocityTable, 1)
		end
	end
	--求めた平均速度から尻尾の角度を計算
	local tail = models.models.main.Avatar.Body.BodyBottom.Tail
	local disguiseTail = models.models.costume_disguise.Avatar.Body.BodyBottom.Tail
	local tailArmor = models.models.armor.Avatar.Body.BodyBottom.Tail
	if (not renderer:isFirstPerson() or client:hasIrisShader()) and TailClass.EnablePyhsics then
		local tailLimit = {{-60, 60}, {-30, 30}} --尻尾の可動範囲：1. 上下方向, 2. 左右方向
		local playerPose = player:getPose()
		if animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" or player:getVehicle() then
			tailLimit[1][2] = 10
		end
		if playerPose == "FALL_FLYING" then
			tail:setRot(math.clamp(VelocityAverage[1] * 80, tailLimit[1][1], tailLimit[1][2]), math.clamp(-VelocityAverage[4] * 0.1, tailLimit[2][1], tailLimit[2][2]), 0)
		elseif playerPose == "SWIMMING" then
			tail:setRot(math.clamp(VelocityAverage[1] * 320, tailLimit[1][1], tailLimit[1][2]), math.clamp(-VelocityAverage[4] * 0.2, tailLimit[2][1], tailLimit[2][2]), 0)
		else
			local tailXMoveXZ = (VelocityAverage[1] + math.abs(VelocityAverage[3])) * 160
			local tailXMoveY = VelocityAverage[2] * 80
			local tailXAngleMove = math.abs(VelocityAverage[4]) * 0.05
			local tailXConditionAngle = (General.PlayerCondition == "LOW" or animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" or player:getVehicle() or WardenClass.WardenNearby) and 0 or (General.PlayerCondition == "MEDIUM" and 15 or 30)
			local tailRot = vectors.vec3(math.clamp(tailLimit[1][2] - math.min(tailXMoveXZ, math.max(tailLimit[1][2] - tailXMoveY - tailXAngleMove - tailXConditionAngle, 0)) + tailXMoveY - math.min(tailXAngleMove, math.max(tailLimit[1][2] -tailXMoveXZ - tailXMoveY - tailXConditionAngle, 0)) - tailXConditionAngle, tailLimit[1][1], tailLimit[1][2]) + (playerPose == "CROUCHING" and 30 or 0), math.clamp(-VelocityAverage[3] * 160 + VelocityAverage[4] * 0.05, tailLimit[2][1], tailLimit[2][2]), 0)
			tail:setRot(tailRot)
			if CostumeClass.CurrentCostume == "DISGUISE" then
				disguiseTail:setRot(tailRot)
			end
			if ArmorClass.ArmorVisible[2] then
				tailArmor:setRot(tailRot)
			end
		end
	else
		tail:setRot(0, 0, 0)
		if CostumeClass.CurrentCostume == "DISGUISE" then
			disguiseTail:setRot(0, 0, 0)
		end
		if ArmorClass.ArmorVisible[2] then
			tailArmor:setRot(0, 0, 0)
		end
	end
	LookRotDeltaPrevRender = lookRotDelta
	LookRotPrevRender = lookRot
end)

WagTailKey.onPress = function ()
	if WagTailCount == 0 then
		pings.wag_tail()
	end
end

return TailClass