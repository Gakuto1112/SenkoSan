---@class ClothCleaningClass 雑巾がけのアニメーションを制御するクラス
---@field ClothCleaningAnimationCount integer アニメーションの再生時間を示すカウンター。

ClothCleaningClass = {}
ClothCleaningAnimationCount = 0

---雑巾がけアニメーションを再生する。
function ClothCleaningClass.play()
	for _, modelPart in ipairs({models.models.cloth_cleaning, models.models.cloth_cleaning.Stain}) do
		modelPart:setVisible(true)
	end
	models.models.cloth_cleaning.Avatar.Body.Arms.RightArm:setParentType("None")
	models.models.cloth_cleaning.Avatar.Body.Arms.RightArm.RightArmBottom.Cloth.Cloth:setUVPixels(0, 0)
	General.setAnimations("PLAY", "cloth_cleaning")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	ClothCleaningAnimationCount = 198
end

---雑巾がけアニメーションを停止する。
function ClothCleaningClass.stop()
	for _, modelPart in ipairs({models.models.cloth_cleaning, models.models.cloth_cleaning.Stain}) do
		modelPart:setVisible(false)
	end
	models.models.cloth_cleaning.Avatar.Body.Arms.RightArm:setParentType("RightArm")
	General.setAnimations("STOP", "cloth_cleaning")
	FacePartsClass:resetEmotion()
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	for _, modelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
		modelPart:setVisible(true)
	end
	ArmsClass.ItemHeldContradicts = {false, false}
	ClothCleaningAnimationCount = 0
end

events.TICK:register(function ()
	if ClothCleaningAnimationCount > 0 then
		local leftHanded = player:isLeftHanded()
		if player:getHeldItem(leftHanded).id ~= "minecraft:air" then
			vanilla_model.RIGHT_ITEM:setVisible(false)
			ArmsClass.ItemHeldContradicts[1] = true
		else
			vanilla_model.RIGHT_ITEM:setVisible(true)
			ArmsClass.ItemHeldContradicts[1] = false
		end
		if player:getHeldItem(not leftHanded).id ~= "minecraft:air" then
			vanilla_model.LEFT_ITEM:setVisible(false)
			ArmsClass.ItemHeldContradicts[2] = true
		else
			vanilla_model.LEFT_ITEM:setVisible(true)
			ArmsClass.ItemHeldContradicts[2] = false
		end
		if ClothCleaningAnimationCount == 91 then
			models.models.cloth_cleaning.Stain:setVisible(false)
			models.models.cloth_cleaning.Avatar.Body.Arms.RightArm.RightArmBottom.Cloth.Cloth:setUVPixels(0, 6)
		elseif ClothCleaningAnimationCount == 41 then
			FacePartsClass.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
			local playerPos = player:getPos()
			sounds:playSound("minecraft:entity.player.levelup", playerPos, 1, 1.5)
			for _ = 1, 30 do
				particles:addParticle("minecraft:happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
			end
		elseif ClothCleaningAnimationCount == 1 then
			ClothCleaningClass.stop()
		end
		ClothCleaningAnimationCount = ClothCleaningAnimationCount > 0 and (client:isPaused() and ClothCleaningAnimationCount or ClothCleaningAnimationCount - 1) or 0
	end
end)

return ClothCleaningClass