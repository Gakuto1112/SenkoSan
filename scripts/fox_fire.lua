---@class FoxFire 狐火を制御するクラス
---@field NightVision boolean 暗視を受けていたかどうか
---@field NightVisionPrev boolean 前チックに暗視を受けていたかどうか
---@field FoxFireEnabledPrev boolean 前チックに狐火が有効かどうか
---@field FoxFirePos Vector3 狐火の座標
---@field FoxFireInFirstPerson boolean 一人称視点で狐火を表示するかどうか
FoxFire = {
	NightVision = false,
	NightVisionPrev = false,
	FoxFireEnabledPrev = false,
	FoxFirePos = vectors.vec(0, 0, 0),
	FoxFireInFirstPerson = Config.loadConfig("foxFireInFirstPerson", true)
}

--ping関数
function pings.setNightVision(newValue)
	FoxFire.NightVision = newValue
end

events.POST_RENDER:register(function (delta)
	models.models.main.FoxFireAnchors:setPos(player:getPos(delta) * 16)
	models.models.main.FoxFireAnchors:setRot(0, -player:getBodyYaw(delta))
end)

models.models.fox_fire:setSecondaryTexture("CUSTOM", textures["textures.fox_fire"])
for index, foxFireAnchor in ipairs(models.models.main.FoxFireAnchors:getChildren()) do
	foxFireAnchor:addChild(models.models.fox_fire:copy("FoxFire"..index))
	foxFireAnchor["FoxFire"..index]:setPos(foxFireAnchor:getPivot())
end
models.models.fox_fire:setVisible(false)

return FoxFire