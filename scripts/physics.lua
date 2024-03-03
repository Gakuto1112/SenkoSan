---@class Physics 物理演算（もどき）を制御するクラス
---@field VelocityData table<table<number>> 速度データ：1. 頭前後, 2. 上下, 3. 頭左右, 4. 頭角速度, 5. 体前後, 6. 体左右, 7. 体角速度
---@field VelocityAverage table<number> 速度の平均値：1. 頭前後, 2. 上下, 3. 頭左右, 4. 頭角速度, 5. 体前後, 6. 体左右, 7. 体角速度
---@field DirectionPrevRender table<number> 前レンダーチックのdirectionテーブル
---@field EnablePyhsics table<boolean> 物理演算を有効にするかどうか：1. 尻尾, 2. 髪飾り
---@field TailRotOffset Vector3 尻尾の角度のオフセット
Physics = {
	VelocityData = {{}, {}, {}, {}, {}, {}, {}},
	VelocityAverage = {0, 0, 0, 0, 0, 0, 0},
	DirectionPrevRender = {},
	EnablePyhsics = {true, true},
	TailRotOffset = vectors.vec3()
}

---@type boolean
local renderProcessed = false

events.RENDER:register(function (delta, context)
	local lookDir = player:getLookDir()
	if not renderProcessed then
		local velocity = player:getVelocity()
		local FPS = client:getFPS()

		---速度を指定された方向から見て前後方向、左右方向に分解する。
		---@param direction number 基準にする方向
		---@param index integer データ管理用のインデックス番号（呼び出しの度に異なるインデックス番号になるようにする）
		---@return number velocityFront 指定された方向から見た前後方向の速度
		---@return number velocityRight 指定された方向から見た左右方向の速度
		---@return number velocityRot 指定された方向を基準とした角速度
		local function decomposeHorizontalVelocity(direction, index)
			if Physics.DirectionPrevRender[index] == nil then
				Physics.DirectionPrevRender[index] = 0
			end
			---@diagnostic disable-next-line: deprecated
			local velocityRot = math.deg(math.atan2(velocity.z, velocity.x))
			velocityRot = velocityRot < 0 and 360 + velocityRot or velocityRot
			local directionAbsFront = math.abs(velocityRot - (direction) % 360)
			directionAbsFront = directionAbsFront > 180 and 360 - directionAbsFront or directionAbsFront
			local directionAbsRight = math.abs(velocityRot - (direction + 90) % 360)
			directionAbsRight = directionAbsRight > 180 and 360 - directionAbsRight or directionAbsRight
			local directionDelta = direction - Physics.DirectionPrevRender[index]
			directionDelta = directionDelta > 180 and (360 - directionDelta) * FPS or (directionDelta < -180 and (360 + directionDelta) * FPS or directionDelta * FPS)
			Physics.DirectionPrevRender[index] = direction
			return math.sqrt(velocity.x ^ 2 + velocity.z ^ 2) * math.cos(math.rad(directionAbsFront)), math.sqrt(velocity.x ^ 2 + velocity.z ^ 2) * math.cos(math.rad(directionAbsRight)), directionDelta
		end

		---@diagnostic disable-next-line: deprecated
		local velocityHeadFront, velocityHeadRight, velocityHeadRot = decomposeHorizontalVelocity(math.deg(math.atan2(lookDir.z, lookDir.x)), 1)
		Physics.VelocityAverage[1] = (#Physics.VelocityData[1] * Physics.VelocityAverage[1] + velocityHeadFront) / (#Physics.VelocityData[1] + 1)
		table.insert(Physics.VelocityData[1], velocityHeadFront)
		Physics.VelocityAverage[2] = (#Physics.VelocityData[2] * Physics.VelocityAverage[2] + velocity.y) / (#Physics.VelocityData[2] + 1)
		table.insert(Physics.VelocityData[2], velocity.y)
		Physics.VelocityAverage[3] = (#Physics.VelocityData[3] * Physics.VelocityAverage[3] + velocityHeadRight) / (#Physics.VelocityData[3] + 1)
		table.insert(Physics.VelocityData[3], velocityHeadRight)
		Physics.VelocityAverage[4] = (#Physics.VelocityData[4] * Physics.VelocityAverage[4] + velocityHeadRot) / (#Physics.VelocityData[4] + 1)
		table.insert(Physics.VelocityData[4], velocityHeadRot)
		local velocityBodyFront, velocityBodyRight, velocityBodyRot = decomposeHorizontalVelocity((player:getBodyYaw(delta) + models.models.main.Avatar.UpperBody:getTrueRot().y - 90) % 360 - 180, 2)
		Physics.VelocityAverage[5] = (#Physics.VelocityData[5] * Physics.VelocityAverage[5] + velocityBodyFront) / (#Physics.VelocityData[5] + 1)
		table.insert(Physics.VelocityData[5], velocityBodyFront)
		Physics.VelocityAverage[6] = (#Physics.VelocityData[6] * Physics.VelocityAverage[6] + velocityBodyRight) / (#Physics.VelocityData[6] + 1)
		table.insert(Physics.VelocityData[6], velocityBodyRight)
		Physics.VelocityAverage[7] = (#Physics.VelocityData[7] * Physics.VelocityAverage[7] + velocityBodyRot) / (#Physics.VelocityData[7] + 1)
		table.insert(Physics.VelocityData[7], velocityBodyRot)
		--古いデータの切り捨て
		for index, velocityTable in ipairs(Physics.VelocityData) do
			while #velocityTable > FPS * 0.25 do
				if #velocityTable >= 2 then
					Physics.VelocityAverage[index] = (#velocityTable * Physics.VelocityAverage[index] - velocityTable[1]) / (#velocityTable - 1)
				end
				table.remove(velocityTable, 1)
			end
		end
		renderProcessed = true
	end
	--求めた平均速度から尻尾の角度を計算
	local tailRot = vectors.vec3()
	local frontHairRot = vectors.vec3()
	local backHairRot = vectors.vec3()
	local backHairVisible = models.models.main.Avatar.UpperBody.Body.Hairs.BackHair:getVisible()
	local rotLimit = {{{-60, 60}, {-30, 30}}, {{0, 80}, {-80, 0}}} --物理演算の可動範囲：1. 尻尾：{1-1. 上下方向, 1-2. 左右方向}, 2. 長髪：{2-1. 前髪, 2-2. 後髪}
	if (context ~= "FIRST_PERSON" or client:hasShaderPack()) and (Physics.EnablePyhsics[1] or Physics.EnablePyhsics[2]) then
		local playerPose = player:getPose()
		local rideVehicle = player:getVehicle() ~= nil
		if SitDown.IsAnimationPlaying or rideVehicle then
			rotLimit[1][1][2] = 10
		end
		if not Armor.ArmorVisible[3] then
			if Costume.CurrentCostume == "MAID_A" then
				rotLimit[2][2][2] = -15
			elseif Costume.CurrentCostume == "MAID_B" then
				rotLimit[2][2][2] = -5
			elseif Costume.CurrentCostume == "SWIMSUIT" then
				rotLimit[2][2] = {lookDir.y * -90 - 90, 0}
			elseif Costume.CurrentCostume == "CHEERLEADER" or Costume.CurrentCostume == "SAILOR" then
				rotLimit[2][2][2] = -10
			end
		end
		if playerPose == "FALL_FLYING" then
			if Physics.EnablePyhsics[1] then
				tailRot = vectors.vec3(math.clamp(Physics.VelocityAverage[5] * 80, rotLimit[1][1][1], rotLimit[1][1][2]), math.clamp(-Physics.VelocityAverage[7] * 0.1, rotLimit[1][2][1], rotLimit[1][2][2]))
			end
			if Physics.EnablePyhsics[2] then
				frontHairRot = vectors.vec3(math.clamp(rotLimit[2][1][2] - math.sqrt(Physics.VelocityAverage[5] ^ 2 + Physics.VelocityAverage[2] ^ 2) * 80, rotLimit[2][1][1], rotLimit[2][1][2]))
				if Costume.CurrentCostume == "SWIMSUIT" then
					backHairRot = vectors.vec3(-30)
				elseif backHairVisible then
					backHairRot = vectors.vec3(rotLimit[2][2][2])
				end
			end
		elseif playerPose == "SWIMMING" then
			if Physics.EnablePyhsics[1] then
				tailRot = vectors.vec3(math.clamp(Physics.VelocityAverage[5] * 320, rotLimit[1][1][1], rotLimit[1][1][2]), math.clamp(-Physics.VelocityAverage[7] * 0.2, rotLimit[1][2][1], rotLimit[1][2][2]))
			end
			if Physics.EnablePyhsics[2] then
				frontHairRot = vectors.vec3(math.clamp(rotLimit[2][1][2] - math.sqrt(Physics.VelocityAverage[5] ^ 2 + Physics.VelocityAverage[2] ^ 2) * 320, rotLimit[2][1][1], rotLimit[2][1][2]))
				if Costume.CurrentCostume == "SWIMSUIT" then
					backHairRot = vectors.vec3(-30)
				elseif backHairVisible then
					backHairRot = vectors.vec3(rotLimit[2][2][2])
				end
			end
		else
			if Physics.EnablePyhsics[1] then
				local tailXMoveXZ = (Physics.VelocityAverage[5] + math.abs(Physics.VelocityAverage[6])) * 160
				local tailXMoveY = Physics.VelocityAverage[2] * 80
				local tailXAngleMove = math.abs(Physics.VelocityAverage[7]) * 0.05
				local tailXConditionAngle = (General.PlayerCondition == "LOW" or SitDown.IsAnimationPlaying or rideVehicle or Warden.WardenNearby) and 0 or (General.PlayerCondition == "MEDIUM" and 15 or 30)
				tailRot = vectors.vec3(math.clamp(rotLimit[1][1][2] - math.min(tailXMoveXZ, math.max(rotLimit[1][1][2] - tailXMoveY - tailXAngleMove - tailXConditionAngle, 0)) + tailXMoveY - math.min(tailXAngleMove, math.max(rotLimit[1][1][2] - tailXMoveXZ - tailXMoveY - tailXConditionAngle, 0)) - tailXConditionAngle, rotLimit[1][1][1], rotLimit[1][1][2]) + (player:isCrouching() and 30 or 0), math.clamp(Physics.VelocityAverage[rideVehicle and 3 or 6] * (rideVehicle and -160 or 160) + Physics.VelocityAverage[7] * 0.05 - models.models.main.Avatar.UpperBody:getTrueRot().y, rotLimit[1][2][1], rotLimit[1][2][2]))
			end
			if Physics.EnablePyhsics[2] then
				local hairXMoveX = Physics.VelocityAverage[5] * -160 + (player:isCrouching() and 30 or 0)
				local hairXMoveY = Physics.VelocityAverage[2] * 80
				local hairXAngleMove = math.abs(Physics.VelocityAverage[7]) * 0.05
				frontHairRot = vectors.vec3(math.clamp(hairXMoveX - hairXMoveY + hairXAngleMove, rotLimit[2][1][1], rotLimit[2][1][2]))
				if Costume.CurrentCostume == "SWIMSUIT" then
					backHairRot = vectors.vec3(math.clamp(hairXMoveX + hairXMoveY - hairXAngleMove - lookDir.y * 90, rotLimit[2][2][1], rotLimit[2][2][2]))
				elseif backHairVisible then
					backHairRot = vectors.vec3(math.clamp(hairXMoveX + hairXMoveY - hairXAngleMove, rotLimit[2][2][1], rotLimit[2][2][2]))
				end
			end
		end
	end
	models.models.main.Avatar.UpperBody.Body.Tail:setRot(tailRot + Physics.TailRotOffset)
	models.models.main.Avatar.UpperBody.Body.Hairs.FrontHair:setRot(frontHairRot)
	if Costume.CurrentCostume == "SWIMSUIT" and not Armor.ArmorVisible[1] then
		models.models.main.Avatar.Head.CSwimsuitH.Ponytail.PonytailHair:setRot(backHairRot)
	elseif backHairVisible then
		models.models.main.Avatar.UpperBody.Body.Hairs.BackHair:setRot(backHairRot)
	end
end)

events.WORLD_RENDER:register(function ()
	renderProcessed = false
end)

return Physics