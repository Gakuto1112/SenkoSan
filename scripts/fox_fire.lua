---@class FoxFireClass 狐火を制御するクラス
---@field FoxFireEnableData table 狐火の開始。終了を検出する為に狐火が有効かどうかの情報が格納されているデータ
---@field FoxFirePos Vecotr3 狐火の座標
---@field FoxFireClass.FoxFireInFirstPerson boolean 一人称視点で狐火を表示するかどうか

FoxFireClass = {}
FoxFireEnableData = {}
FoxFirePos = vectors.vec(0, 0, 0)
FoxFireClass.FoxFireInFirstPerson = ConfigClass.FoxFireInFirstPerson

events.TICK:register(function ()
	local isFoxFireEnabled = (General.getStatusEffect("night_vision") and true or false) and WetClass.WetCount == 0
	table.insert(FoxFireEnableData, isFoxFireEnabled)
	if #FoxFireEnableData == 3 then
		table.remove(FoxFireEnableData, 1)
	end
	if isFoxFireEnabled then
		if not FoxFireEnableData[1] then
			sounds:playSound("minecraft:item.firecharge.use", player:getPos(), 1, 2)
		end
		local playerTargetPos = player:getPos():add(0, 2.5, 0)
		local vectorToPlayer = playerTargetPos:copy():sub(FoxFirePos)
		if vectorToPlayer:length() >= 16 then
			FoxFirePos = playerTargetPos
		end
		FoxFirePos:add(vectorToPlayer:scale(0.25))
		if not renderer:isFirstPerson() or FoxFireClass.FoxFireInFirstPerson then
			particles:addParticle("minecraft:soul_fire_flame", FoxFirePos:copy():add((math.random() - 0.5) * 0.25, (math.random() - 0.5) * 0.25, (math.random() - 0.5) * 0.25))
		end
	else
		if FoxFireEnableData[1] then
			sounds:playSound("minecraft:block.fire.extinguish", player:getPos(), 1, 2)
		end
	end
end)

return FoxFireClass