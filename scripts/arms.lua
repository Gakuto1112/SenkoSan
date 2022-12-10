---@class Arms 腕を制御するクラス
---@field Arms.ItemHeldContradicts boolean アイテムを手に持った際の腕のズレを打ち消すかどうか：1. 右腕, 2. 左腕

Arms = {}

Arms.ItemHeldContradicts = false

---手持ちアイテムを隠し、手のズレを補正する。
---@param hide boolean 手のアイテムを隠すかどうか
function Arms.hideHeldItem(hide)
	for _, vanillaModel in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
		vanillaModel:setVisible(not hide)
	end
	Arms.ItemHeldContradicts = hide
end

events.TICK:register(function()
	local rightArm = models.models.main.Avatar.Body.Arms.RightArm
	local leftArm = models.models.main.Avatar.Body.Arms.LeftArm
	local isFirstPerson = renderer:isFirstPerson()
	local armPos = vectors.vec3(0, player:getPose() == "CROUCHING" and not isFirstPerson and 3 or 0, 0)
	rightArm:setPos(armPos)
	leftArm:setPos(armPos)
	if isFirstPerson then
		rightArm:setRot(0, 0, 0)
		leftArm:setRot(0, 0, 0)
	end
end)

events.RENDER:register(function ()
	local rightArm = models.models.main.Avatar.Body.Arms.RightArm
	local leftArm = models.models.main.Avatar.Body.Arms.LeftArm
	local leftHanded = player:isLeftHanded()
	local rightOriginRot = vanilla_model.RIGHT_ARM:getOriginRot()
	local leftOriginRot = vanilla_model.LEFT_ARM:getOriginRot()
	local umbrellaAdjust = Umbrella.Umbrella and not SitDown.IsAnimationPlaying
	local sneakAdjust = General.IsSneaking and 30 or 0
	if Arms.ItemHeldContradicts then
		rightArm:setRot(-rightOriginRot.x + ((umbrellaAdjust and leftHanded) and 20 or 0) + sneakAdjust, -rightOriginRot.y, -rightOriginRot.z)
		leftArm:setRot(-leftOriginRot.x+ ((umbrellaAdjust and not leftHanded) and 20 or 0) + sneakAdjust, -leftOriginRot.y, -leftOriginRot.z)
	else
		rightArm:setRot(((umbrellaAdjust and leftHanded) and 20 or 0) + sneakAdjust, 0, 0)
		leftArm:setRot(((umbrellaAdjust and not leftHanded) and 20 or 0) + sneakAdjust, 0, 0)
	end
end)

return Arms