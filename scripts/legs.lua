---@class Legs 脚を制御するクラス
---@field Legs.RightLegOffset Vector3 右脚の角度のオフセット
---@field Lefs.LeftLegOffset Vector3 左脚の角度のオフセット
---@field Legs.ReducedLegSwing boolean 脚の動きを軽減するかどうか（軽減時は0.5になる）

Legs = {
	ReducedLegSwing = false,
	RightLegRotOffset = vectors.vec3(),
	LeftLegRotOffset = vectors.vec3()
}

events.RENDER:register(function ()
	local isCrouching = player:isCrouching()
	local legPos = isCrouching and vectors.vec3(0, 4, -4) or vectors.vec3()
	for _, legPart in ipairs({models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg}) do
		legPart:setPos(legPos)
	end
	local vehicle = player:getVehicle()
	models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg:setRot(vectors.vec3((isCrouching and 30 or 0) + ((Legs.ReducedLegSwing and not vehicle) and vanilla_model.RIGHT_LEG:getOriginRot().x * -0.5 or 0)) + Legs.RightLegRotOffset)
	models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg:setRot(vectors.vec3((isCrouching and 30 or 0) + ((Legs.ReducedLegSwing and not vehicle) and vanilla_model.LEFT_LEG:getOriginRot().x * -0.5 or 0)) + Legs.LeftLegRotOffset)
end)

return Legs