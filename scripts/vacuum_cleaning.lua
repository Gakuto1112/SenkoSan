---@class VacuumCleaningClass 掃除機での掃除のアニメーションを制御するクラス
---@field VacuumCleaningAnimationCount integer アニメーションの再生時間を示すカウンター。

VacuumCleaningClass = {}

VacuumCleaningAnimationCount = 0

---掃除機アニメーションを再生する。
function VacuumCleaningClass.play()
	models.models.vacuum_cleaning:setVisible(true)
	General.setAnimations("PLAY", "vacuum_cleaning")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	VacuumCleaningAnimationCount = 281
end

---掃除機アニメーションを停止する。
function VacuumCleaningClass.stop()
	if VacuumCleaningAnimationCount > 148 then
		models.models.vacuum_cleaning:setVisible(false)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	end
	General.setAnimations("STOP", "vacuum_cleaning")
	FacePartsClass:resetEmotion()
	EarsClass.resetEarsRot()
	for _, modelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
		modelPart:setVisible(true)
	end
	ArmsClass.ItemHeldContradicts = {false, false}
	VacuumCleaningAnimationCount = 0
end

events.TICK:register(function ()
	if VacuumCleaningAnimationCount > 0 then
		local leftHanded = player:isLeftHanded()
		if General.hasItem(player:getHeldItem(leftHanded)) ~= "none" then
			vanilla_model.RIGHT_ITEM:setVisible(false)
			ArmsClass.ItemHeldContradicts[1] = true
		else
			vanilla_model.RIGHT_ITEM:setVisible(true)
			ArmsClass.ItemHeldContradicts[1] = false
		end
		if General.hasItem(player:getHeldItem(not leftHanded)) ~= "none" then
			vanilla_model.LEFT_ITEM:setVisible(false)
			ArmsClass.ItemHeldContradicts[2] = true
		else
			vanilla_model.LEFT_ITEM:setVisible(true)
			ArmsClass.ItemHeldContradicts[2] = false
		end
	end
	if VacuumCleaningAnimationCount == 236 then
		sounds:playSound("block.stone_button.click_on", player:getPos(), 1, 1.5)
	elseif VacuumCleaningAnimationCount <= 231 and VacuumCleaningAnimationCount > 148 then
		if VacuumCleaningAnimationCount <= 231 and VacuumCleaningAnimationCount > 192 then
			if VacuumCleaningAnimationCount == 231 then
				FacePartsClass.setEmotion("SURPLISED", "SURPLISED", "CLOSED", 39, true)
				EarsClass.setEarsRot("DROOPING", 230, true)
			end
			sounds:playSound("entity.experience_orb.pickup", player:getPos(), 0.25, 1.5)
		elseif VacuumCleaningAnimationCount <= 189 and VacuumCleaningAnimationCount >= 149 and (VacuumCleaningAnimationCount - 149) % 10 == 0 then
			sounds:playSound("entity.iron_golem.step", player:getPos(), 1, 1)
		end
		if VacuumCleaningAnimationCount == 192 then
			FacePartsClass.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 76, true)
		end
		sounds:playSound("entity.minecart.riding", player:getPos(), 0.25, 2)
	elseif VacuumCleaningAnimationCount == 148 then
		models.models.vacuum_cleaning:setVisible(false)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	elseif VacuumCleaningAnimationCount == 119 then
		FacePartsClass.setEmotion("SURPLISED", "SURPLISED", "CLOSED", 85, true)
	elseif VacuumCleaningAnimationCount == 34 then
		FacePartsClass.setEmotion("CLOSED", "CLOSED", "CLOSED", 30, true)
	elseif VacuumCleaningAnimationCount == 1 then
		VacuumCleaningClass.stop()
	end
	VacuumCleaningAnimationCount = VacuumCleaningAnimationCount > 0 and (client:isPaused() and VacuumCleaningAnimationCount or VacuumCleaningAnimationCount - 1) or 0
end)

models.models.vacuum_cleaning:setVisible(false)

return VacuumCleaningClass