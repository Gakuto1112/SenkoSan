---@class EarsClass けも耳を制御するクラス

EarsClass = {}

events.TICK:register(function ()
	local gamemode = player:getGamemode()
	models.models.main.Avatar.Head.Ears:setRot(General.isTired and -40 or ((player:getHealth() / player:getMaxHealth() <= 0.5 or player:getFood() <= 6) and (gamemode == "SURVIVAL" or gamemode == "ADVENTURE") and -20 or 0), 0, 0)
end)

return EarsClass