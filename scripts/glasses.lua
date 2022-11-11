---@class GlassesClass 眼鏡を制御するクラス
---@field GlassesWorePrev boolean 前チックに眼鏡をかけていたかどうか

GlassesClass = {}
GlassesWorePrev = false

--ping関数
function pings.setGlassVisible(visible)
	models.models.main.Avatar.Head.Glasses:setVisible(visible)
end

events.TICK:register(function ()
	if host:isHost() then
		local guiClassName = host:getScreen()
		local glassesWear = guiClassName and (guiClassName == "class_486" or guiClassName == "class_473" or guiClassName == "class_3934" or guiClassName == "class_3935") or false
		if glassesWear and not GlassesWorePrev then
			pings.setGlassVisible(true)
		elseif not glassesWear and GlassesWorePrev then
			pings.setGlassVisible(false)
		end
		GlassesWorePrev = guiClassName and glassesWear or false
	end
end)

return GlassesClass