---@class Skull プレイヤーの頭のモデルタイプを管理するクラス
---@field Skull.SkullList table 利用可能な頭モデルのリスト
---@field Skull.CurrentSkull integer 現在の頭モデルのID

Skull = {
	SkullList = {"default", "figure_a", "figure_b", "figure_c", "figure_d"},
	CurrentSkull = 1
}

events.SKULL_RENDER:register(function (_, block, item)
	models.models.skull:setVisible((block == nil and item == nil) or Skull.CurrentSkull == 1)
	for index, modelPart in ipairs({models.models.skull_figure_a, models.models.skull_figure_b, models.models.skull_figure_c, models.models.skull_figure_d}) do
		modelPart:setVisible((block ~= nil or item ~= nil) and Skull.CurrentSkull == index + 1)
	end
end)

local loadedData = Config.loadConfig("skull", 1)
if loadedData <= #Skull.SkullList then
	Skull.CurrentSkull = loadedData
else
	Config.saveConfig("skull", 1)
end

return Skull