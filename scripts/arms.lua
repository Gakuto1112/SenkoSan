---@class Arms 腕を制御するクラス
---@field Arms.RightArmOffset Vector3 右腕の角度のオフセット
---@field Arms.LeftArmOffset Vector3 左腕の角度のオフセット
---@field Arms.ItemHeldContradicts boolean アイテムを手に持った際の腕のズレを打ち消すかどうか：1. 右腕, 2. 左腕

Arms = {
	RightArmRotOffset = vectors.vec3(),
	LeftArmRotOffset = vectors.vec3(),
	ItemHeldContradicts = false,

	---手持ちアイテムを隠し、手のズレを補正する。
	---@param hide boolean 手のアイテムを隠すかどうか
	hideHeldItem = function(hide)
		for _, vanillaModel in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
			vanillaModel:setVisible(not hide)
		end
		Arms.ItemHeldContradicts = hide
	end,

	---腕の角度のオフセットをリセットする。
	resetArmRotOffset = function ()
		Arms.RightArmRotOffset = vectors.vec3()
		Arms.LeftArmRotOffset = vectors.vec3()
	end
}

events.TICK:register(function()
	local isFirstPerson = renderer:isFirstPerson()
	local armPos = vectors.vec3(0, General.IsSneaking and not isFirstPerson and 3 or 0)
	models.models.main.Avatar.Body.Arms.RightArm:setPos(armPos)
	models.models.main.Avatar.Body.Arms.LeftArm:setPos(armPos)
	if isFirstPerson then
		models.models.main.Avatar.Body.Arms.RightArm:setRot(0, 0, 0)
		models.models.main.Avatar.Body.Arms.LeftArm:setRot(0, 0, 0)
	end
end)

events.RENDER:register(function ()
	local leftHanded = player:isLeftHanded()
	local rightOriginRot = vanilla_model.RIGHT_ARM:getOriginRot()
	local leftOriginRot = vanilla_model.LEFT_ARM:getOriginRot()
	local umbrellaAdjust = Umbrella.Umbrella and not SitDown.IsAnimationPlaying
	local sneakAdjust = General.IsSneaking and 30 or 0
	if Arms.ItemHeldContradicts then
		models.models.main.Avatar.Body.Arms.RightArm:setRot(-rightOriginRot.x + ((umbrellaAdjust and leftHanded) and 20 or 0) + sneakAdjust + Arms.RightArmRotOffset.x, -rightOriginRot.y + Arms.RightArmRotOffset.y, -rightOriginRot.z + Arms.RightArmRotOffset.z)
		models.models.main.Avatar.Body.Arms.LeftArm:setRot(-leftOriginRot.x+ ((umbrellaAdjust and not leftHanded) and 20 or 0) + sneakAdjust + Arms.LeftArmRotOffset.x, -leftOriginRot.y + Arms.LeftArmRotOffset.y, -leftOriginRot.z + Arms.LeftArmRotOffset.z)
	else
		models.models.main.Avatar.Body.Arms.RightArm:setRot(((umbrellaAdjust and leftHanded) and 20 or 0) + sneakAdjust, 0, 0)
		models.models.main.Avatar.Body.Arms.LeftArm:setRot(((umbrellaAdjust and not leftHanded) and 20 or 0) + sneakAdjust, 0, 0)
	end
end)

return Arms