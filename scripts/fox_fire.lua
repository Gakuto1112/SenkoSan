---@class FoxFire 狐火を制御するクラス
---@field FoxFire.NightVision boolean 暗視を受けていたかどうか
---@field FoxFire.NightVisionPrev boolean 前チックに暗視を受けていたかどうか
---@field FoxFire.FoxFireEnabledPrev boolean 前チックに狐火が有効かどうか
---@field FoxFire.FoxFirePos Vector3 狐火の座標
---@field FoxFire.FoxFireInFirstPerson boolean 一人称視点で狐火を表示するかどうか

FoxFire = {}
FoxFire.NightVision = false
FoxFire.NightVisionPrev = false
FoxFire.FoxFireEnabledPrev = false
FoxFire.FoxFirePos = vectors.vec(0, 0, 0)
FoxFire.FoxFireInFirstPerson = Config.loadConfig("foxFireInFirstPerson", true)

--ping関数
function pings.setNightVision(newValue)
	FoxFire.NightVision = newValue
end

events.TICK:register(function ()
	if host:isHost() then
		FoxFire.NightVision = General.getStatusEffect("night_vision") and true or false
	end
	if FoxFire.NightVision and not FoxFire.NightVisionPrev then
		pings.setNightVision(true)
	elseif not FoxFire.NightVision and FoxFire.NightVisionPrev then
		pings.setNightVision(false)
	end
	local isFoxFireEnabled = FoxFire.NightVision and Wet.WetCount == 0
	if isFoxFireEnabled then
		if not FoxFire.FoxFireEnabledPrev then
			sounds:playSound("minecraft:item.firecharge.use", player:getPos(), 1, 2)
		end
		local playerTargetPos = player:getPos():add(0, 2.5, 0)
		local vectorToPlayer = playerTargetPos:copy():sub(FoxFire.FoxFirePos)
		if vectorToPlayer:length() >= 16 then
			FoxFire.FoxFirePos = playerTargetPos
		end
		FoxFire.FoxFirePos:add(vectorToPlayer:scale(0.25))
		if not renderer:isFirstPerson() or FoxFire.FoxFireInFirstPerson then
			particles:newParticle("minecraft:soul_fire_flame", FoxFire.FoxFirePos:copy():add((math.random() - 0.5) * 0.25, (math.random() - 0.5) * 0.25, (math.random() - 0.5) * 0.25))
		end
	elseif FoxFire.FoxFireEnabledPrev then
		sounds:playSound("minecraft:block.fire.extinguish", player:getPos(), 1, 2)
	end
	FoxFire.NightVisionPrev = FoxFire.NightVision
	FoxFire.FoxFireEnabledPrev = isFoxFireEnabled
end)

return FoxFire