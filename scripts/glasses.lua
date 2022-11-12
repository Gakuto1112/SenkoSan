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
		local glassesWear = guiClassName == "net.minecraft.class_486" or guiClassName == "net.minecraft.class_473" or guiClassName == "net.minecraft.class_3934" or guiClassName == "net.minecraft.class_3935"
		if glassesWear and not GlassesWorePrev then
			pings.setGlassVisible(true)
		elseif not glassesWear and GlassesWorePrev then
			pings.setGlassVisible(false)
		end
		GlassesWorePrev = guiClassName and glassesWear or false
	end
end)

return GlassesClass