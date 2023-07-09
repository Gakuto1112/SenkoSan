---@class Legs 脚を制御するクラス
---@field RightLegOffset Vector3 右脚の角度のオフセット
---@field LeftLegOffset Vector3 左脚の角度のオフセット
---@field ReducedLegSwing boolean 脚の動きを軽減するかどうか（軽減時は0.5になる）
Legs = {
	ReducedLegSwing = false,
	RightLegRotOffset = vectors.vec3(),
	LeftLegRotOffset = vectors.vec3()
}

events.RENDER:register(function ()
	local vehicle = player:getVehicle()
	models.models.main.Avatar.LowerBody.BodyBottomPivot.Legs.RightLeg:setRot(vectors.vec3((Legs.ReducedLegSwing and not vehicle) and vanilla_model.RIGHT_LEG:getOriginRot().x * -0.5 or 0, 0.28647, -0.28647) + Legs.RightLegRotOffset)
	models.models.main.Avatar.LowerBody.BodyBottomPivot.Legs.LeftLeg:setRot(vectors.vec3((Legs.ReducedLegSwing and not vehicle) and vanilla_model.LEFT_LEG:getOriginRot().x * -0.5 or 0, -0.28647, 0.28647) + Legs.LeftLegRotOffset)
end)

return Legs