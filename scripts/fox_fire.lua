---@class FoxFire 狐火を制御するクラス
---@field FoxFire.FoxFireEnableData table 狐火の開始。終了を検出する為に狐火が有効かどうかの情報が格納されているデータ
---@field FoxFire.FoxFirePos Vector3 狐火の座標
---@field FoxFire.FoxFireInFirstPerson boolean 一人称視点で狐火を表示するかどうか

FoxFire = {}
FoxFire.FoxFireEnableData = {}
FoxFire.FoxFirePos = vectors.vec(0, 0, 0)
FoxFire.FoxFireInFirstPerson = Config.loadConfig("foxFireInFirstPerson", true)

events.TICK:register(function ()
	local isFoxFireEnabled = (General.getStatusEffect("night_vision") and true or false) and Wet.WetCount == 0
	table.insert(FoxFire.FoxFireEnableData, isFoxFireEnabled)
	if #FoxFire.FoxFireEnableData == 3 then
		table.remove(FoxFire.FoxFireEnableData, 1)
	end
	if isFoxFireEnabled then
		if not FoxFire.FoxFireEnableData[1] then
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
	else
		if FoxFire.FoxFireEnableData[1] then
			sounds:playSound("minecraft:block.fire.extinguish", player:getPos(), 1, 2)
		end
	end
end)

return FoxFire