---@class NameplateClass ネームプレート（プレイヤーの名前）を制御するクラス

NameplateClass = {}

---プレイヤーの表示名を設定する。
---@param newName string 新しい表示名
function NameplateClass.setName(newName)
	for _, nameplatePart in ipairs({nameplate.CHAT, nameplate.ENTITY, nameplate.LIST}) do
		nameplatePart:setText(newName)
	end
end

events.TICK:register(function()
	if animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" then
		nameplate.ENTITY:setPos(0, -0.5, 0)
	else
		nameplate.ENTITY:setPos(0, 0, 0)
	end
end)

return NameplateClass