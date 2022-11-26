---@class NameplateClass ネームプレート（プレイヤーの名前）を制御するクラス
---@field NameplateClass.NameList table 利用可能な名前のリスト
---@field NameplateClass.NamplateOffset number ネームプレートのオフセット

NameplateClass = {}

NameplateClass.NameList = {player:getName(), "Senko", "仙狐", "Senko_san", "仙狐さん", "Sen", "仙", "セン"}
NameplateClass.NamePlateOffset = 0

---プレイヤーの表示名を設定する。
---@param nameID integer 新しい表示名
function NameplateClass.setName(nameID)
	nameplate.ALL:setText(NameplateClass.NameList[nameID])
end

---プレイヤー名前設定の初期処理
function nameInit()
	local loadedData = ConfigClass.loadConfig("name", 1)
	if loadedData <= #NameplateClass.NameList then
		NameplateClass.setName(loadedData)
	else
		NameplateClass.setName(1)
		ConfigClass.saveConfig("name", 1)
	end
end

events.RENDER:register(function ()
	local currentNameplateOffset = nameplate.ENTITY:getPos()
	if currentNameplateOffset == nil then
		currentNameplateOffset = 0
	else
		currentNameplateOffset = currentNameplateOffset.y
	end
	if currentNameplateOffset > NameplateClass.NamePlateOffset then
		nameplate.ENTITY:setPos(0, math.max(currentNameplateOffset - 3 / client:getFPS(), NameplateClass.NamePlateOffset), 0)
	elseif currentNameplateOffset < NameplateClass.NamePlateOffset then
		nameplate.ENTITY:setPos(0, math.min(currentNameplateOffset + 3 / client:getFPS(), NameplateClass.NamePlateOffset), 0)
	end
end)

nameInit()
nameplate.ENTITY:setBackgroundColor(233 / 255, 160 / 255, 70 / 255)
nameplate.ENTITY.shadow = true

return NameplateClass