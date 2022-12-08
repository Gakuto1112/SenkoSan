---@class Arms 腕を制御するクラス
---@field Arms.ItemHeldContradicts table アイテムを手に持った際の腕のズレを打ち消すかどうか：1. 右腕, 2. 左腕

Arms = {}

Arms.ItemHeldContradicts = {false, false}

events.TICK:register(function()
	local rightArms = {models.models.main.Avatar.Body.Arms.RightArm, models.models.costume_cheerleader.Avatar.Body.Arms.RightArm}
	local leftArms = {models.models.main.Avatar.Body.Arms.LeftArm, models.models.costume_cheerleader.Avatar.Body.Arms.LeftArm}
	local rightArmorArm = models.models.armor.Avatar.Body.Arms.RightArm
	local leftArmorArm = models.models.armor.Avatar.Body.Arms.LeftArm
	local playerPose = player:getPose()
	local leftHanded = player:isLeftHanded()
	if not renderer:isFirstPerson() then
		local rightArmHeldContradict = player:getHeldItem(leftHanded).id ~= "minecraft:air" and Arms.ItemHeldContradicts[1]
		local leftArmHeldContradict = player:getHeldItem(not leftHanded).id ~= "minecraft:air" and Arms.ItemHeldContradicts[2]
		local umbrellaAdjust = Umbrella.Umbrella and not SitDown.IsAnimationPlaying
		if playerPose == "CROUCHING" then
			for _, rightArm in ipairs(rightArms) do
				rightArm:setPos(0, 3, 0)
				rightArm:setRot(30 - (rightArmHeldContradict and 15 or 0) + ((umbrellaAdjust and leftHanded) and 20 or 0), 0, 0)
			end
			for _, leftArm in ipairs(leftArms) do
				leftArm:setPos(0, 3, 0)
				leftArm:setRot(30 - (leftArmHeldContradict and 15 or 0) + ((umbrellaAdjust and not leftHanded) and 20 or 0), 0, 0)
			end
			if Armor.ArmorVisible[2] then
				rightArmorArm:setPos(0, 3, 0)
				rightArmorArm:setRot(30 - (rightArmHeldContradict and 15 or 0) + ((umbrellaAdjust and leftHanded) and 20 or 0), 0, 0)
				leftArmorArm:setPos(0, 3, 0)
				leftArmorArm:setRot(30 - (leftArmHeldContradict and 15 or 0) + ((umbrellaAdjust and not leftHanded) and 20 or 0), 0, 0)
			end
		else
			for _, rightArm in ipairs(rightArms) do
				rightArm:setPos(0, 0, 0)
				rightArm:setRot((rightArmHeldContradict and -15 or 0) + ((umbrellaAdjust and leftHanded) and 20 or 0), 0, 0)
			end
			for _, leftArm in ipairs(leftArms) do
				leftArm:setPos(0, 0, 0)
				leftArm:setRot((leftArmHeldContradict and -15 or 0) + ((umbrellaAdjust and not leftHanded) and 20 or 0), 0, 0)
			end
			if Armor.ArmorVisible[2] then
				rightArmorArm:setPos(0, 0, 0)
				rightArmorArm:setRot((rightArmHeldContradict and -15 or 0) + ((umbrellaAdjust and leftHanded) and 20 or 0), 0, 0)
				leftArmorArm:setPos(0, 0, 0)
				leftArmorArm:setRot((leftArmHeldContradict and -15 or 0) + ((umbrellaAdjust and not leftHanded) and 20 or 0), 0, 0)
			end
		end
	else
		for _, rightArm in ipairs(rightArms) do
			rightArm:setPos(0, 0, 0)
			rightArm:setRot(0, 0, 0)
		end
		for _, leftArm in ipairs(leftArms) do
			leftArm:setPos(0, 0, 0)
			leftArm:setRot(0, 0, 0)
		end
		if Armor.ArmorVisible[2] then
			for _, modelPart in ipairs({rightArmorArm, leftArmorArm}) do
				modelPart:setPos(0, 0, 0)
				modelPart:setRot(0, 0, 0)
			end
		end
	end
end)

return Arms