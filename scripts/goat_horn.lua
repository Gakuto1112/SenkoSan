---@class GoatHorn ヤギの角笛を吹く時の挙動を制御するクラス

events.TICK:register(function()
	if player:getActiveItem().id == "minecraft:goat_horn" then
		FaceParts.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 1, true)
	end
end)