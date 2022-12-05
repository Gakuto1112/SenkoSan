---@class Skull プレイヤーの頭のモデルタイプを管理するクラス
---@field Skull.SkullList table 利用可能な頭モデルのリスト
---@field Skull.CurrentSkull integer 現在の頭モデルのID

Skull = {}

Skull.SkullList = {"default", "figure_a", "figure_b", "figure_c"}
Skull.CurrentSkull = 1

---頭モデル設定の初期処理
function skullInit()
	local loadedData = Config.loadConfig("skull", 1)
	if loadedData <= #Skull.SkullList then
		Skull.CurrentSkull = loadedData
	else
		Config.saveConfig("skull", 1)
	end
end

events.SKULL_RENDER:register(function (delta, block, item)
	models.models.skull:setVisible((block == nil and item == nil) or Skull.CurrentSkull == 1)
	models.models.skull_figure_a:setVisible((block ~= nil or item ~= nil) and Skull.CurrentSkull == 2)
	models.models.skull_figure_b:setVisible((block ~= nil or item ~= nil) and Skull.CurrentSkull == 3)
	models.models.skull_figure_c:setVisible((block ~= nil or item ~= nil) and Skull.CurrentSkull == 4)
end)

skullInit()

return Skull