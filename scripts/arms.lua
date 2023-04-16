---@class Arms 腕を制御するクラス
---@field Arms.RightArmPosOffset Vector3 右腕の位置のオフセット
---@field Arms.LeftArmPosOffset Vector3 左腕の位置のオフセット
---@field Arms.RightArmRotOffset Vector3 右腕の角度のオフセット
---@field Arms.LeftArmORotffset Vector3 左腕の角度のオフセット
---@field Arms.ItemHeldContradicts boolean アイテムを手に持った際の腕のズレを打ち消すかどうか：1. 右腕, 2. 左腕

Arms = {
	RightArmPosOffset = vectors.vec3(),
	LeftArmPosOffset = vectors.vec3(),
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

events.TICK:register(function ()
	local leftHanded = player:isLeftHanded()
	models.models.main.Avatar.Body.Arms.RightArm:setParentType(((Umbrella.IsUsing and leftHanded and PhotoPose.CurrentPose ~= 7) or Naginata.State[1] >= 2 or Naginata.State[2] >= 2) and "Body" or "RightArm")
	models.models.main.Avatar.Body.Arms.LeftArm:setParentType(((Umbrella.IsUsing and not leftHanded) or Naginata.State[1] >= 2 or Naginata.State[2] >= 2) and "Body" or "LeftArm")
end)

events.RENDER:register(function ()
	local armPos = vectors.vec3(0, player:isCrouching() and 3 or 0)
	models.models.main.Avatar.Body.Arms.RightArm:setPos(armPos + Arms.RightArmPosOffset)
	models.models.main.Avatar.Body.Arms.LeftArm:setPos(armPos + Arms.LeftArmPosOffset)
	local leftHanded = player:isLeftHanded()
	local umbrellaAdjust = Umbrella.IsUsing and not SitDown.IsAnimationPlaying and PhotoPose.CurrentPose ~= 7
	local sneakAdjust = player:isCrouching() and 30 or 0
	if Arms.ItemHeldContradicts then
		models.models.main.Avatar.Body.Arms.RightArm:setRot(vectors.vec3(((umbrellaAdjust and leftHanded) and 20 or 0) + sneakAdjust) + Arms.RightArmRotOffset - vanilla_model.RIGHT_ARM:getOriginRot())
		models.models.main.Avatar.Body.Arms.LeftArm:setRot(vectors.vec3(((umbrellaAdjust and not leftHanded) and 20 or 0) + sneakAdjust) + Arms.LeftArmRotOffset - vanilla_model.LEFT_ARM:getOriginRot())
	else
		models.models.main.Avatar.Body.Arms.RightArm:setRot(vectors.vec3(((umbrellaAdjust and leftHanded) and 20 or 0) + sneakAdjust) + Arms.RightArmRotOffset)
		models.models.main.Avatar.Body.Arms.LeftArm:setRot(vectors.vec3(((umbrellaAdjust and not leftHanded) and 20 or 0) + sneakAdjust) + Arms.LeftArmRotOffset)
	end
end)

return Arms