---@class Wet 濡れ機能を制御するクラス
---@field Wet.WalkDistance number 鈴を鳴らす用の歩いた距離
---@field Wet.VelocityYData table ジャンプしたかどうかを判定する為にy方向の速度を格納するテーブル
---@field Wet.OnGroundData table 前チックに着地していたかを判定する為に着地情報を格納するテーブル
---@field Wet.IsWet boolean 濡れているかどうか
---@field Wet.WetCount integer 濡れの度合いを計るカウンター
---@field Wet.AutoShake boolean 自動ブルブルが有効かどうか
---@field Wet.AutoShakeCount integer 自動ブルブルまでの時間を計るカウンター

Wet = {
	WalkDistance = 0,
	VelocityYData = {},
	OnGroundData = {},
	IsWet = false,
	WetCount = 0,
	AutoShake = Config.loadConfig("autoShake", true),
	AutoShakeCount = 0
}

--ping関数
function pings.wetJumpSound()
	sounds:playSound("minecraft:entity.cod.flop", player:getPos(), Wet.WetCount / 1200, 1)
end

events.TICK:register(function()
	local velocity = player:getVelocity()
	local onGround = player:isOnGround()
	local paused = client:isPaused()
	local playerPos = player:getPos()
	if not paused then
		Wet.WalkDistance = Wet.WalkDistance + math.sqrt(math.abs(velocity.x ^ 2 + velocity.z ^ 2))
		if Wet.WalkDistance >= 1.8 then
			if not player:getVehicle() and onGround and not player:isInWater() then
				sounds:playSound("minecraft:entity.cod.flop", playerPos, Wet.WetCount / 1200, 1)
			end
			Wet.WalkDistance = 0
		end
		Wet.WetCount = player:getDeathTime() == 19 and 0 or (Wet.IsWet and (player:isInWater() and 1200 or math.min(Wet.WetCount + 4, 1200)) or math.max(Wet.WetCount - 1, 0))
	end
	table.insert(Wet.VelocityYData, velocity.y)
	table.insert(Wet.OnGroundData, onGround)
	for _, dataTable in ipairs({Wet.VelocityYData, Wet.OnGroundData}) do
		if #dataTable == 3 then
			table.remove(dataTable, 1)
		end
	end
	Wet.IsWet = (player:isInRain() and not Umbrella.Umbrella) or player:isInWater()
	if Wet.IsWet then
		Ears.setEarsRot("DROOPING", 1, true)
		Wet.AutoShakeCount = 0
	elseif Wet.WetCount > 0 then
		if Wet.WetCount % 5 == 0 then
			for _ = 1, math.min(avatar:getMaxParticles() / 4 , 4) * math.ceil(Wet.WetCount / 300) / 4 do
				particles:newParticle("minecraft:falling_water", playerPos.x + math.random() - 0.5, playerPos.y + math.random() + 0.5, playerPos.z + math.random() - 0.5)
			end
		end
		Ears.setEarsRot("DROOPING", 1, true)
		if host:isJumping() and Wet.OnGroundData[1] and velocity.y > 0 and Wet.VelocityYData[1] <= 0 then
			pings.wetJumpSound()
		end
		if Wet.AutoShake and not ShakeBody.IsAnimationPlaying then
			if Wet.AutoShakeCount == 20 then
				ShakeBody:play(false)
				Wet.AutoShakeCount = 0
			elseif not paused then
				Wet.AutoShakeCount = Wet.AutoShakeCount + 1
			end
		end
	end
	local tailScale = (1200 - Wet.WetCount) / 1200 * 0.5 + 0.5
	models.models.main.Avatar.Body.BodyBottom.Tail:setScale(tailScale, tailScale, 1)
end)

return Wet