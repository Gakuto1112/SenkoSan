---@class HairCutClass 散髪のアニメーションを制御するクラス
---@field ChairBlock BlockTask 椅子の代わりのオークの木の階段の描画を行うレンダータスク
---@field ScissorsItem ItemStack はさみの描画を行うレンダータスク
---@field HairCutAnimationCount integer アニメーションの再生時間を示すカウンター。

HairCutClass = {}

ChairBlock = models.models.hair_cut:newBlock("hair_cut.chair"):block("minecraft:oak_stairs"):pos(8, -6, -4):rot(0, 180, 0)
ScissorsItem = models.models.hair_cut.Avatar.Body.Arms.RightArm.RightArmBottom.Scissors:newItem("hair_cut.scissors"):item("minecraft:shears"):pos(2, 0, -3):rot(-90, 45, 0):scale(0.5, 0.5, 0.5):enabled(false)
HairCutAnimationCount = 0

---散髪のアニメーションを再生する。
function HairCutClass.play()
	for _, modelPart in ipairs({models.models.hair_cut, models.models.hair_cut.Avatar.Body.Arms.RightArm.RightArmBottom.Spray, models.models.hair_cut.Avatar.Body.Arms.LeftArm.LeftArmBottom.Comb}) do
		modelPart:setVisible(true)
	end
	General.setAnimations("PLAY", "hair_cut")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	UmbrellaClass.EnableUmbrella = false
	HairCutAnimationCount = 488
end

---散髪のアニメーションを停止する。
function HairCutClass.stop()
	for _, modelPart in ipairs({models.models.hair_cut, models.models.hair_cut.Avatar.Body.Arms.RightArm.RightArmBottom.Spray, models.models.hair_cut.Avatar.Body.Arms.LeftArm.LeftArmBottom.Comb, models.models.hair_cut.Avatar.Body.Arms.LeftArm.LeftArmBottom.HairPiece}) do
		modelPart:setVisible(false)
	end
	ScissorsItem:enabled(false)
	General.setAnimations("STOP", "hair_cut")
	FacePartsClass:resetEmotion()
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	for _, modelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
		modelPart:setVisible(true)
	end
	ArmsClass.ItemHeldContradicts = {false, false}
	UmbrellaClass.EnableUmbrella = true
	HairCutAnimationCount = 0
end

events.TICK:register(function ()
	if HairCutAnimationCount > 0 then
		if HairCutAnimationCount > 296 or HairCutAnimationCount <= 206 then
			local playerPos = player:getPos()
			for _ = 1, 5 do
				particles:newParticle("minecraft:end_rod", playerPos:copy():add((math.random() - 0.5) * 10, (math.random() - 0.5) * 10, (math.random() - 0.5) * 10))
			end
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
		if HairCutAnimationCount <= 468 and HairCutAnimationCount >= 398 and (HairCutAnimationCount - 468) % 15 == 0 then
			sounds:playSound("minecraft:entity.cat.hiss", player:getPos(), 0.25, 2)
			local splashPos = vectors.rotateAroundAxis(-(player:getBodyYaw() % 360), 0, 0, 0.3, 0, 1, 0):add(player:getPos():add(0, 1, 0))
			for _ = 1, 5 do
				particles:newParticle("minecraft:splash", splashPos)
			end
		elseif HairCutAnimationCount == 383 then
			for _, modelPart in ipairs({models.models.hair_cut.Avatar.Body.Arms.RightArm.RightArmBottom.Spray, models.models.hair_cut.Avatar.Body.Arms.LeftArm.LeftArmBottom.Comb}) do
				modelPart:setVisible(false)
			end
			ScissorsItem:enabled(true)
			sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		elseif (HairCutAnimationCount <= 373 and HairCutAnimationCount >= 330 and (HairCutAnimationCount - 373) % 6 == 0) or (HairCutAnimationCount <= 320 and HairCutAnimationCount >= 303 and (HairCutAnimationCount - 320) % 6 == 0) or (HairCutAnimationCount <= 196 and HairCutAnimationCount >= 153 and (HairCutAnimationCount - 196) % 6 == 0) or (HairCutAnimationCount <= 143 and HairCutAnimationCount >= 100 and (HairCutAnimationCount - 143) % 6 == 0) then
			sounds:playSound("entity.sheep.shear", player:getPos(), 0.25, 1)
		elseif HairCutAnimationCount == 296 then
			local playerPos = player:getPos()
			for _ = 1, 30 do
				particles:newParticle("minecraft:smoke", playerPos:copy():add((math.random() - 0.5) * 2, (math.random() - 0.5) * 2 + 1, (math.random() - 0.5) * 2))
			end
			sounds:playSound("entity.sheep.shear", player:getPos(), 1, 1)
			FacePartsClass.setEmotion("SURPLISED", "SURPLISED", "CLOSED", 60, false)
			models.models.hair_cut.Avatar.Body.Arms.LeftArm.LeftArmBottom.HairPiece:setVisible(true)
		elseif HairCutAnimationCount == 276 then
			sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		elseif HairCutAnimationCount == 236 then
			sounds:playSound("minecraft:entity.wolf.shake", player:getPos(), 1, 1.5)
			FacePartsClass.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 20, true)
		elseif HairCutAnimationCount == 216 then
			models.models.hair_cut.Avatar.Body.Arms.LeftArm.LeftArmBottom.HairPiece:setVisible(false)
		elseif HairCutAnimationCount == 90 then
			ScissorsItem:enabled(false)
		elseif HairCutAnimationCount <= 80 and HairCutAnimationCount >= 53 and (HairCutAnimationCount - 80) % 13 == 0 then
			sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
		elseif HairCutAnimationCount == 40 then
			FacePartsClass.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
			local playerPos = player:getPos()
			sounds:playSound("minecraft:entity.player.levelup", playerPos, 1, 1.5)
			for _ = 1, 30 do
				particles:newParticle("minecraft:happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
			end
		end
		if HairCutAnimationCount == 1 then
			HairCutClass.stop()
		end
		HairCutAnimationCount = HairCutAnimationCount > 0 and (client:isPaused() and HairCutAnimationCount or HairCutAnimationCount - 1) or 0
	end
end)

for _, modelPart in ipairs({models.models.hair_cut.SittingPlayer, models.models.hair_cut.Avatar.Body.Arms.LeftArm.LeftArmBottom.HairPiece}) do
	modelPart:setPrimaryTexture("SKIN")
end
if player:getModelType() == "DEFAULT" then
	for _, modelPart in ipairs({models.models.hair_cut.SittingPlayer.SittingPlayerBody.SittingPlayerArms.SittingPlayerRightArms.SittingPlayerRightArmSlim, models.models.hair_cut.SittingPlayer.SittingPlayerBody.SittingPlayerArms.SittingPlayerLeftArms.SittingPlayerLeftArmSlim}) do
		modelPart:setVisible(false)
	end
else
	for _, modelPart in ipairs({models.models.hair_cut.SittingPlayer.SittingPlayerBody.SittingPlayerArms.SittingPlayerRightArms.SittingPlayerRightArmClassic, models.models.hair_cut.SittingPlayer.SittingPlayerBody.SittingPlayerArms.SittingPlayerLeftArms.SittingPlayerLeftArmClassic}) do
		modelPart:setVisible(false)
	end
end

return HairCutClass