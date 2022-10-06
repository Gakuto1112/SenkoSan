---@class EarsClass けも耳を制御するクラス

EarsClass = {}

events.TICK:register(function ()
	models.models.main.Avatar.Head.Ears:setRot(General.PlayerCondition == "LOW" and -40 or (General.PlayerCondition == "MEDIUM" and -20 or 0), 0, 0)
end)

return EarsClass