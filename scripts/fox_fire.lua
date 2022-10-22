---@class FoxFireClass 狐火を制御するクラス
---@field IsFoxFireEnabled boolean 狐火を出すかどうか
---@field FoxFireEnableData table 狐火の開始。終了を検出する為に狐火が有効かどうかの情報が格納されているデータ
---@field FoxFirePos Vecotr3 狐火の座標
---@field FoxFireClass.FoxFireInFirstPerson boolean 一人称視点で狐火を表示するかどうか

FoxFireClass = {}
IsFoxFireEnabled = false
FoxFireEnableData = {}
FoxFirePos = vectors.vec(0, 0, 0)
FoxFireClass.FoxFireInFirstPerson = ConfigClass.FoxFireInFirstPerson

events.TICK:register(function ()
	IsFoxFireEnabled = (General.getStatusEffect("night_vision") and true or false) and WetClass.WetCount == 0
	table.insert(FoxFireEnableData, IsFoxFireEnabled)
	if #FoxFireEnableData == 3 then
		table.remove(FoxFireEnableData, 1)
	end
	if IsFoxFireEnabled then
		if not FoxFireEnableData[1] then
			sounds:playSound("minecraft:item.firecharge.use", player:getPos(), 1, 2)
		end
		if not renderer:isFirstPerson() or FoxFireClass.FoxFireInFirstPerson then
			particles:addParticle("minecraft:soul_fire_flame", FoxFirePos:copy():add((math.random() - 0.5) * 0.25, (math.random() - 0.5) * 0.25, (math.random() - 0.5) * 0.25))
		end
	else
		if FoxFireEnableData[1] then
			sounds:playSound("minecraft:block.fire.extinguish", player:getPos(), 1, 2)
		end
	end
end)

events.WORLD_RENDER:register(function ()
	if player and IsFoxFireEnabled then
		local playerPos = player:getPos():add(0, 2.5, 0)
		local vectorToPlayer = playerPos:copy():sub(FoxFirePos)
		local FPS = client:getFPS()
		if vectorToPlayer:length() >= 16 then
			FoxFirePos = playerPos
		end
		local foxFireSpeed = 5
		FoxFirePos:add(vectorToPlayer.x * (foxFireSpeed / FPS), vectorToPlayer.y * (foxFireSpeed / FPS), vectorToPlayer.z * (foxFireSpeed / FPS))
	end
end)

return FoxFireClass