---@class Nameplate ネームプレート（プレイヤーの名前）を制御するクラス
---@field Nameplate.NameList table 利用可能な名前のリスト
---@field Nameplate.NamplateOffset number ネームプレートのオフセット

Nameplate = {
	NameList = {player:getName(), "Shiro", "シロ"},
	NamePlateOffset = 0,

	---プレイヤー名前設定の初期処理
	nameInit = function ()
		local loadedData = Config.loadConfig("name", 1)
		if loadedData <= #Nameplate.NameList then
			nameplate.ALL:setText(Nameplate.NameList[loadedData])
		else
			nameplate.ALL:setText(Nameplate.NameList[1])
			Config.saveConfig("name", 1)
		end
	end
}

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

Nameplate.nameInit()

return Nameplate