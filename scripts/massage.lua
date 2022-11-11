---@class MassageClass マッサージのアニメーションを制御するクラス
---@field MassageAnimationCount integer アニメーションの再生時間を示すカウンター。

MassaseClass = {}

MassageAnimationCount = 0

---マッサージのアニメーションを再生する。
function MassaseClass.play()
	models.models.massage:setVisible(true)
	General.setAnimations("PLAY", "massage")
	General.setAnimations("PLAY", "earpick_arm_fix")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	MassageAnimationCount = 426
end

---マッサージのアニメーションを停止する。
function MassaseClass.stop()
	models.models.massage:setVisible(false)
	General.setAnimations("STOP", "massage")
	General.setAnimations("STOP", "earpick_arm_fix")
	FacePartsClass:resetEmotion()
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	for _, modelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
		modelPart:setVisible(true)
	end
	ArmsClass.ItemHeldContradicts = {false, false}
	MassageAnimationCount = 0
end

events.TICK:register(function ()
	if MassageAnimationCount > 0 then
		local playerPos = player:getPos()
		for _ = 1, 5 do
			particles:addParticle("minecraft:end_rod", playerPos:copy():add((math.random() - 0.5) * 10, (math.random() - 0.5) * 10, (math.random() - 0.5) * 10))
		end
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
	end
	if (MassageAnimationCount <= 403 and MassageAnimationCount >= 373 and (MassageAnimationCount - 403) % 15 == 0) or (MassageAnimationCount <= 341 and MassageAnimationCount >= 311 and (MassageAnimationCount - 341) % 15 == 0) or (MassageAnimationCount <= 279 and MassageAnimationCount >= 249 and (MassageAnimationCount - 279) % 15 == 0) or (MassageAnimationCount <= 151 and MassageAnimationCount >= 59 and (MassageAnimationCount - 151) % 8 == 0) then
		sounds:playSound("minecraft:block.wool.step", player:getPos(), 0.5, 1)
		if MassageAnimationCount == 95 then
			FacePartsClass.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
			local playerPos = player:getPos()
			sounds:playSound("minecraft:entity.player.levelup", playerPos, 1, 1.5)
			for _ = 1, 30 do
				particles:addParticle("minecraft:happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
			end
		end
	elseif MassageAnimationCount == 1 then
		MassaseClass.stop()
	end
	MassageAnimationCount = MassageAnimationCount > 0 and (client:isPaused() and MassageAnimationCount or MassageAnimationCount - 1) or 0
end)

models.models.massage.LyingPlayer:setPrimaryTexture("SKIN")
if player:getModelType() == "DEFAULT" then
	for _, modelPart in ipairs({models.models.massage.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerRightArms.LyingPlayerRightArmSlim, models.models.massage.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerLeftArms.LyingPlayerLeftArmSlim}) do
		modelPart:setVisible(false)
	end
else
	for _, modelPart in ipairs({models.models.massage.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerRightArms.LyingPlayerRightArmClassic, models.models.massage.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerLeftArms.LyingPlayerLeftArmClassic}) do
		modelPart:setVisible(false)
	end
end

return MassaseClass