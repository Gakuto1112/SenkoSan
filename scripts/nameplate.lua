---@class Nameplate ネームプレート（プレイヤーの名前）を制御するクラス
---@field Nameplate.NameList table 利用可能な名前のリスト
---@field Nameplate.NamplateOffset number ネームプレートのオフセット

Nameplate = {}

Nameplate.NameList = {player:getName(), "Senko", "仙狐", "Senko_san", "仙狐さん", "Sen", "仙", "セン"}
Nameplate.NamePlateOffset = 0

---プレイヤーの表示名を設定する。
---@param nameID integer 新しい表示名
function Nameplate.setName(nameID)
	nameplate.ALL:setText(Nameplate.NameList[nameID])
end

---プレイヤー名前設定の初期処理
function nameInit()
	local loadedData = Config.loadConfig("name", 1)
	if loadedData <= #Nameplate.NameList then
		Nameplate.setName(loadedData)
	else
		Nameplate.setName(1)
		Config.saveConfig("name", 1)
	end
end

events.RENDER:register(function ()
	local currentNameplateOffset = nameplate.ENTITY:getPos()
	if currentNameplateOffset == nil then
		currentNameplateOffset = 0
	else
		currentNameplateOffset = currentNameplateOffset.y
	end
	if currentNameplateOffset > Nameplate.NamePlateOffset then
		nameplate.ENTITY:setPos(0, math.max(currentNameplateOffset - 3 / client:getFPS(), Nameplate.NamePlateOffset), 0)
	elseif currentNameplateOffset < Nameplate.NamePlateOffset then
		nameplate.ENTITY:setPos(0, math.min(currentNameplateOffset + 3 / client:getFPS(), Nameplate.NamePlateOffset), 0)
	end
end)

nameInit()

return Nameplate