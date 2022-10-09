---@class NameplateClass ネームプレート（プレイヤーの名前）を制御するクラス

NameplateClass = {}

---プレイヤーの表示名を設定する。
---@param newName string 新しい表示名
function NameplateClass.setName(newName)
	nameplate.ALL:setText(newName)
end

events.TICK:register(function()
	if animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" then
		nameplate.ENTITY:setPos(0, -0.5, 0)
	else
		nameplate.ENTITY:setPos(0, 0, 0)
	end
end)

if ConfigClass.DefaultName >= 2 then
	NameplateClass.setName(ConfigClass.DefaultName == 2 and "Senko_san" or "仙狐さん")
end

nameplate.ENTITY:setBackgroundColor(233 / 255, 160 / 255, 70 / 255)
nameplate.ENTITY.shadow = true

return NameplateClass