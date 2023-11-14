---@class Arms 腕を制御するクラス
---@field RightArmPosOffset Vector3 右腕の位置のオフセット
---@field LeftArmPosOffset Vector3 左腕の位置のオフセット
---@field RightArmRotOffset Vector3 右腕の角度のオフセット
---@field LeftArmORotffset Vector3 左腕の角度のオフセット
---@field ItemHeldContradicts boolean アイテムを手に持った際の腕のズレを打ち消すかどうか：1. 右腕, 2. 左腕
Arms = {
	RightArmPosOffset = vectors.vec3(),
	LeftArmPosOffset = vectors.vec3(),
	RightArmRotOffset = vectors.vec3(),
	LeftArmRotOffset = vectors.vec3(),
	ItemHeldContradicts = false,

	---腕の状態（位置や角度など）を更新する。
	updateArm = function ()
		models.models.main.Avatar.UpperBody.Arms.RightArm:setPos(Arms.RightArmPosOffset)
		models.models.main.Avatar.UpperBody.Arms.LeftArm:setPos(Arms.LeftArmPosOffset)
		local leftHanded = player:isLeftHanded()
		local umbrellaAdjust = Umbrella.IsUsing and not SitDown.IsAnimationPlaying
		if Arms.ItemHeldContradicts then
			models.models.main.Avatar.UpperBody.Arms.RightArm:setRot(vectors.vec3((umbrellaAdjust and leftHanded) and 20 or 0) + Arms.RightArmRotOffset - vanilla_model.RIGHT_ARM:getOriginRot())
			models.models.main.Avatar.UpperBody.Arms.LeftArm:setRot(vectors.vec3((umbrellaAdjust and not leftHanded) and 20 or 0) + Arms.LeftArmRotOffset - vanilla_model.LEFT_ARM:getOriginRot())
		else
			models.models.main.Avatar.UpperBody.Arms.RightArm:setRot(vectors.vec3((umbrellaAdjust and leftHanded) and 20 or 0) + Arms.RightArmRotOffset)
			models.models.main.Avatar.UpperBody.Arms.LeftArm:setRot(vectors.vec3((umbrellaAdjust and not leftHanded) and 20 or 0) + Arms.LeftArmRotOffset)
		end
	end,

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
	models.models.main.Avatar.UpperBody.Arms.RightArm:setParentType(((Umbrella.IsUsing and leftHanded) or Naginata.State[1] >= 2 or Naginata.State[2] >= 2) and "Body" or "RightArm")
	models.models.main.Avatar.UpperBody.Arms.LeftArm:setParentType(((Umbrella.IsUsing and not leftHanded) or Naginata.State[1] >= 2 or Naginata.State[2] >= 2) and "Body" or "LeftArm")
end)

events.RENDER:register(function ()
	Arms.updateArm()
end)

return Arms