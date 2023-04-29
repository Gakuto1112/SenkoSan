---@class Skull プレイヤーの頭のモデルタイプを管理するクラス
---@field SkullList table<string> 利用可能な頭モデルのリスト
---@field CurrentSkull integer 現在の頭モデルのID
Skull = {
	SkullList = {"default", "figure_a", "figure_b", "figure_c", "figure_d"},
	CurrentSkull = 1
}

---@diagnostic disable-next-line: redundant-parameter
events.SKULL_RENDER:register(function (delta, _, _, _, renderType)
	models.models.skull.Skull:setVisible(renderType == "HEAD" or Skull.CurrentSkull == 1)
	for index, modelPart in ipairs({models.models.skull_figure_a.Skull, models.models.skull_figure_b.Skull, models.models.skull_figure_c.Skull, models.models.skull_figure_d.Skull}) do
		modelPart:setVisible(renderType ~= "HEAD" and Skull.CurrentSkull == index + 1)
	end
end)

local loadedData = Config.loadConfig("skull", 1)
if loadedData <= #Skull.SkullList then
	Skull.CurrentSkull = loadedData
else
	Config.saveConfig("skull", 1)
end

return Skull