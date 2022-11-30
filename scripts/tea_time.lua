---@class TeaTimeClass お茶飲みのアニメーションを制御するクラス
---@field TeaTimeAnimationCount integer アニメーションの再生時間を示すカウンター。

TeaTimeClass = {}

TeaTimeAnimationCount = 0

---お茶飲みのアニメーションを再生する。
function TeaTimeClass.play()
	for _, modelPart in ipairs({models.models.tea, models.models.tea.Avatar.Body.Yunomi1.Tea}) do
		modelPart:setVisible(true)
	end
	General.setAnimations("PLAY", "tea_time")
	General.setAnimations("PLAY", "earpick_arm_fix")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	UmbrellaClass.EnableUmbrella = false
	TeaTimeAnimationCount = 250
end

---お茶飲みのアニメーションを停止する。
function TeaTimeClass.stop()
	for _, modelPart in ipairs({models.models.tea, models.models.tea.Avatar.Body.Yunomi1.Tea}) do
		modelPart:setVisible(false)
	end
	General.setAnimations("STOP", "tea_time")
	General.setAnimations("STOP", "earpick_arm_fix")
	FacePartsClass:resetEmotion()
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	for _, modelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
		modelPart:setVisible(true)
	end
	ArmsClass.ItemHeldContradicts = {false, false}
	UmbrellaClass.EnableUmbrella = true
	TeaTimeAnimationCount = 0
end

events.TICK:register(function ()
	if TeaTimeAnimationCount > 0 then
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
		local yunomi2ParticlePivot = models.models.tea.Avatar.Table.TableItems.Yunomi2.Yunomi2ParticlePivot:partToWorldMatrix()
		particles:newParticle("poof", yunomi2ParticlePivot[4][1], yunomi2ParticlePivot[4][2], yunomi2ParticlePivot[4][3]):scale(0.2):velocity(0, 0, 0):lifetime(15)
		if TeaTimeAnimationCount > 50 then
			local yunomi1ParticlePivot = models.models.tea.Avatar.Body.Yunomi1.Yunomi1ParticlePivot:partToWorldMatrix()
			particles:newParticle("poof", yunomi1ParticlePivot[4][1], yunomi1ParticlePivot[4][2], yunomi1ParticlePivot[4][3]):scale(0.2):velocity(0, 0, 0):lifetime(15)
		end
		if TeaTimeAnimationCount <= 210 and TeaTimeAnimationCount > 50 and (TeaTimeAnimationCount - 210) % 20 == 0 then
			if TeaTimeAnimationCount == 210 then
				FacePartsClass.setEmotion("CLOSED", "CLOSED", "CLOSED", 160, true)
			end
			sounds:playSound("minecraft:entity.generic.drink", player:getPos(), 0.5, 1)
		elseif TeaTimeAnimationCount == 50 then
			models.models.tea.Avatar.Body.Yunomi1.Tea:setVisible(false)
		elseif TeaTimeAnimationCount == 40 then
			FacePartsClass.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
			local playerPos = player:getPos()
			sounds:playSound("minecraft:entity.player.levelup", playerPos, 1, 1.5)
			sounds:playSound("minecraft:block.stone.break", player:getPos(), 0.5, 1)
			for _ = 1, 30 do
				particles:newParticle("minecraft:happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
			end
		elseif TeaTimeAnimationCount == 1 then
			TeaTimeClass.stop()
		end
		TeaTimeAnimationCount = TeaTimeAnimationCount > 0 and (client:isPaused() and TeaTimeAnimationCount or TeaTimeAnimationCount - 1) or 0
	end
end)

models.models.tea.Avatar.Table.Board:setPrimaryTexture("RESOURCE", "textures/block/spruce_planks.png")
models.models.tea.Avatar.Table.TableLegs:setPrimaryTexture("RESOURCE", "textures/block/spruce_log.png")

return TeaTimeClass