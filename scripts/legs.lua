---@class Legs 脚を制御するクラス
---@field Legs.ReducedLegSwing boolean 脚の動きを軽減するかどうか（軽減時は0.5になる）

Legs = {
	ReducedLegSwing = false
}

events.RENDER:register(function ()
	local legPos = vectors.vec3()
	local legLot = {0, 0} --脚の角度：1. 右, 2. 左
	if player:isCrouching() then
		legPos = vectors.vec3(0, 4, -4)
		legLot = {30, 30}
	end
	if Legs.ReducedLegSwing and not player:getVehicle() then
		legLot[1] = legLot[1] + vanilla_model.RIGHT_LEG:getOriginRot().x * -0.5
		legLot[2] = legLot[2] + vanilla_model.LEFT_LEG:getOriginRot().x * -0.5
	end
	for index, legPart in ipairs({models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg}) do
		legPart:setPos(legPos)
		legPart:setRot(legLot[index])
	end
end)

return Legs