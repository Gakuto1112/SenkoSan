---@class Skull プレイヤーの頭のモデルタイプを管理するクラス
---@field Skull.SkullList table 利用可能な頭モデルのリスト

Skull = {}

Skull.SkullList = {"default", "figure_a", "figure_b", "figure_c"}

---頭モデルを変更する。
---@param skullID integer 新たに変更する頭モデル
function Skull.setSkull(skullID)
	models.models.skull:setVisible(skullID == 1)
	models.models.skull_figure_a:setVisible(skullID == 2)
	models.models.skull_figure_b:setVisible(skullID == 3)
	models.models.skull_figure_c:setVisible(skullID == 4)
end

---頭モデル設定の初期処理
function skullInit()
	local loadedData = Config.loadConfig("skull", 1)
	if loadedData <= #Skull.SkullList then
		Skull.setSkull(loadedData)
	else
		Skull.setSkull(1)
		Config.saveConfig("skull", 1)
	end
end

skullInit()

return Skull