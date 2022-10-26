---@class EarpickClass 耳かきのアニメーションを制御するクラス
---@field EarpickAnimationCount integer アニメーションの再生時間を示すカウンター。

EarpickClass = {}

EarpickAnimationCount = 0

---耳かきアニメーションを再生する。
function EarpickClass.play()
	models.models.ear_cleaning:setVisible(true)
	General.setAnimations("PLAY", "earpick")
	General.setAnimations("PLAY", "earpick_arm_fix")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	EarpickAnimationCount = 238
end

---耳かきアニメーションを停止する。
function EarpickClass.stop()
	models.models.ear_cleaning:setVisible(false)
	General.setAnimations("STOP", "earpick")
	General.setAnimations("STOP", "earpick_arm_fix")
	FacePartsClass:resetEmotion()
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	for _, modelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
		modelPart:setVisible(true)
	end
	ArmsClass.ItemHeldContradicts = {false, false}
	EarpickAnimationCount = 0
end

events.TICK:register(function ()
	if EarpickAnimationCount > 0 then
		local playerPos = player:getPos()
		for _ = 1, 5 do
			particles:addParticle("minecraft:end_rod", playerPos:copy():add((math.random() - 0.5) * 10, (math.random() - 0.5) * 10, (math.random() - 0.5) * 10))
		end
		local leftHanded = player:isLeftHanded()
		if player:getHeldItem(leftHanded).id ~= "minecraft:air" then
			vanilla_model.RIGHT_ITEM:setVisible(false)
			ArmsClass.ItemHeldContradicts[1] = true
			models.models.ear_cleaning.Avatar.RightArm:setRot(-20, 0, 0)
		else
			vanilla_model.RIGHT_ITEM:setVisible(true)
			ArmsClass.ItemHeldContradicts[1] = false
			models.models.ear_cleaning.Avatar.RightArm:setRot(0, 0, 0)
		end
		if player:getHeldItem(not leftHanded).id ~= "minecraft:air" then
			vanilla_model.LEFT_ITEM:setVisible(false)
			ArmsClass.ItemHeldContradicts[2] = true
		else
			vanilla_model.LEFT_ITEM:setVisible(true)
			ArmsClass.ItemHeldContradicts[2] = false
		end
	end
	if EarpickAnimationCount == 184 then
		FacePartsClass.setEmotion("CLOSED", "CLOSED", "CLOSED", 40, true)
	elseif EarpickAnimationCount == 41 then
		FacePartsClass.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
		local playerPos = player:getPos()
		sounds:playSound("minecraft:entity.player.levelup", playerPos, 1, 1.5)
		for _ = 1, 30 do
			particles:addParticle("minecraft:happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
		end
	elseif EarpickAnimationCount == 1 then
		EarpickClass.stop()
	end
	EarpickAnimationCount = EarpickAnimationCount > 0 and (client:isPaused() and EarpickAnimationCount or EarpickAnimationCount - 1) or 0
end)

models.models.ear_cleaning:setVisible(false)
models.models.ear_cleaning.LyingPlayer:setPrimaryTexture("SKIN")
if player:getModelType() == "DEFAULT" then
	for _, modelPart in ipairs({models.models.ear_cleaning.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerRightArms.LyingPlayerRightArmSlim, models.models.ear_cleaning.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerLeftArms.LyingPlayerLeftArmSlim}) do
		modelPart:setVisible(false)
	end
else
	for _, modelPart in ipairs({models.models.ear_cleaning.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerRightArms.LyingPlayerRightArmClassic, models.models.ear_cleaning.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerLeftArms.LyingPlayerLeftArmClassic}) do
		modelPart:setVisible(false)
	end
end

return EarpickClass