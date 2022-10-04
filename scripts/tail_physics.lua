---@class TailPhysicsClass 尻尾を制御するクラス
---@field VelocityData table 速度データ：1. 前後, 2. 上下, 3. 左右, 4. 角速度
---@field VelocityAverage table 速度の平均値：1. 前後, 2. 上下, 3. 左右, 4. 角速度
---@field LookRotPrevRender number 前レンダーチックのlookRot
---@field LookRotDeltaPrevRender number 前レンダーチックのlookRotDelta
---@field TailPhysicsClass.EnablePyhisics boolean 尻尾の物理演算を有効にするかどうか。

TailPhysicsClass = {}

VelocityData = {{}, {}, {}, {}}
VelocityAverage = {0, 0, 0, 0}
LookRotPrevRender = 0
LookRotDeltaPrevRender = 0
TailPhysicsClass.EnablePyhisics = true;

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
	local tail = models.models.main.Body.Tail
	if TailPhysicsClass.EnablePyhisics then
		local tailLimit = {{-60, 60}, {-30, 30}} --尻尾の可動範囲：1. 上下方向, 2. 左右方向
		local tailXMoveXZ = (VelocityAverage[1] + math.abs(VelocityAverage[3])) * 160
		local tailMoveY = VelocityAverage[2] * 80
		local tailXAngleMove = math.abs(VelocityAverage[4]) * 0.05
		tail:setRot(math.clamp(tailLimit[1][2] - math.min(tailXMoveXZ, math.max(60 - tailMoveY - tailXAngleMove, 0)) + tailMoveY - math.min(tailXAngleMove, math.max(60 -tailXMoveXZ - tailMoveY, 0)), tailLimit[1][1], tailLimit[1][2]) + (player:getPose() == "CROUCHING" and 30 or 0), math.clamp(-VelocityAverage[3] * 160 + VelocityAverage[4] * 0.05, tailLimit[2][1], tailLimit[2][2]), 0)
	else
		tail:setRot(0, 0, 0)
	end
	LookRotDeltaPrevRender = lookRotDelta
	LookRotPrevRender = lookRot
end)

return TailPhysicsClass