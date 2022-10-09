---@class FoxFireClass 狐火を制御するクラス
---@field NightVisionData table 狐火の開始。終了を検出する為に暗視の情報が格納されているデータ
---@field EnableFoxFire boolean 狐火の表示が有効かどうか
---@field FoxFirePos Vecotr3 狐火の座標
---@field FoxFireSpeed number 狐火の移動速度

FoxFireClass = {}
NightVisionData = {}
EnableFoxFire = false
FoxFirePos = vectors.vec(0, 0, 0)
FoxFireSpeed = 5

events.TICK:register(function ()
	local nightVision = General.getStatusEffect("night_vision")
	table.insert(NightVisionData, nightVision and true or false)
	if #NightVisionData == 3 then
		table.remove(NightVisionData, 1)
	end
	if nightVision then
		if not NightVisionData[1] then
			sounds:playSound("minecraft:item.firecharge.use", player:getPos(), 1, 2)
		end
		EnableFoxFire = true
		particles:addParticle("minecraft:soul_fire_flame", FoxFirePos:copy():add((math.random() - 0.5) * 0.25, (math.random() - 0.5) * 0.25, (math.random() - 0.5) * 0.25))
	else
		if NightVisionData[1] then
			sounds:playSound("minecraft:block.fire.extinguish", player:getPos(), 1, 2)
		end
		EnableFoxFire = false
	end
end)

events.WORLD_RENDER:register(function ()
	if player and EnableFoxFire then
		local playerPos = player:getPos():add(0, 2.5, 0)
		local vectorToPlayer = playerPos:copy():sub(FoxFirePos)
		local FPS = client:getFPS()
		if vectorToPlayer:length() >= 16 then
			FoxFirePos = playerPos
		end
		FoxFirePos:add(vectorToPlayer.x * (FoxFireSpeed / FPS), vectorToPlayer.y * (FoxFireSpeed / FPS), vectorToPlayer.z * (FoxFireSpeed / FPS))
	end
end)

return FoxFireClass