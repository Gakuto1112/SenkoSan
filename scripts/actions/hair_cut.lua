---@class HairCut 散髪のアニメーションを制御するクラス
---@field HairCut.ChairBlock BlockTask 椅子の代わりのオークの木の階段の描画を行うレンダータスク
---@field HairCut.ScissorsItem ItemTask はさみの描画を行うレンダータスク

HairCut = General.instance({}, AnimationAction, function ()
	return BroomCleaning:checkAction()
end, {models.models.hair_cut, models.models.hair_cut.Avatar.Body.Arms.RightArm.RightArmBottom.Spray, models.models.hair_cut.Avatar.Body.Arms.LeftArm.LeftArmBottom.Comb}, {models.models.hair_cut, models.models.hair_cut.Avatar.Body.Arms.RightArm.RightArmBottom.Spray, models.models.hair_cut.Avatar.Body.Arms.LeftArm.LeftArmBottom.Comb, models.models.hair_cut.Avatar.Body.Arms.LeftArm.LeftArmBottom.HairPiece}, animations["models.main"]["hair_cut"], General.getAnimationsOutOfMain("hair_cut"), 8)

HairCut.ChairBlock = models.models.hair_cut:newBlock("hair_cut.chair"):block("minecraft:oak_stairs"):pos(8, -6, -4):rot(0, 180, 0) --椅子代わりの階段ブロックのレンダータスク
HairCut.ScissorsItem = models.models.hair_cut.Avatar.Body.Arms.RightArm.RightArmBottom.Scissors:newItem("hair_cut.scissors"):item("minecraft:shears"):pos(2, 0, -3):rot(-90, 45, 0):scale(0.5, 0.5, 0.5):enabled(false) --鋏のアイテムレンダータスク。

---散髪アニメーションを再生する。
function HairCut.play(self)
	AnimationAction.play(self)
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	self.HideHeldItem = true
end

---散髪アニメーションを停止する。
function HairCut.stop(self)
	AnimationAction.stop(self)
	HairCut.ScissorsItem:enabled(false)
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
end

---アニメーション再生中に毎チック実行される関数
function HairCut.onAnimationTick(self)
	AnimationAction.onAnimationTick(self)
	if self.AnimationCount > 0 then
		if self.AnimationCount > 296 or self.AnimationCount <= 206 then
			local playerPos = player:getPos()
			for _ = 1, 5 do
				particles:newParticle("end_rod", playerPos:copy():add((math.random() - 0.5) * 10, (math.random() - 0.5) * 10, (math.random() - 0.5) * 10))
			end
		end
		if self.AnimationCount <= 468 and self.AnimationCount >= 398 and (self.AnimationCount - 468) % 15 == 0 then
			sounds:playSound("entity.cat.hiss", player:getPos(), 0.25, 2)
			local splashPos = vectors.rotateAroundAxis(-(player:getBodyYaw() % 360), 0, 0, 0.3, 0, 1, 0):add(player:getPos():add(0, 1, 0))
			for _ = 1, 5 do
				particles:newParticle("splash", splashPos)
			end
		elseif self.AnimationCount == 383 then
			for _, modelPart in ipairs({models.models.hair_cut.Avatar.Body.Arms.RightArm.RightArmBottom.Spray, models.models.hair_cut.Avatar.Body.Arms.LeftArm.LeftArmBottom.Comb}) do
				modelPart:setVisible(false)
			end
			HairCut.ScissorsItem:enabled(true)
			sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		elseif (self.AnimationCount <= 373 and self.AnimationCount >= 330 and (self.AnimationCount - 373) % 6 == 0) or (self.AnimationCount <= 320 and self.AnimationCount >= 303 and (self.AnimationCount - 320) % 6 == 0) or (self.AnimationCount <= 196 and self.AnimationCount >= 153 and (self.AnimationCount - 196) % 6 == 0) or (self.AnimationCount <= 143 and self.AnimationCount >= 100 and (self.AnimationCount - 143) % 6 == 0) then
			sounds:playSound("entity.sheep.shear", player:getPos(), 0.25, 1)
		elseif self.AnimationCount == 296 then
			local playerPos = player:getPos()
			for _ = 1, 30 do
				particles:newParticle("smoke", playerPos:copy():add((math.random() - 0.5) * 2, (math.random() - 0.5) * 2 + 1, (math.random() - 0.5) * 2))
			end
			sounds:playSound("entity.sheep.shear", player:getPos(), 1, 1)
			FaceParts.setEmotion("SURPLISED", "SURPLISED", "CLOSED", 60, false)
			models.models.hair_cut.Avatar.Body.Arms.LeftArm.LeftArmBottom.HairPiece:setVisible(true)
		elseif self.AnimationCount == 276 then
			sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		elseif self.AnimationCount == 236 then
			sounds:playSound("entity.wolf.shake", player:getPos(), 1, 1.5)
			FaceParts.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 20, true)
		elseif self.AnimationCount == 216 then
			models.models.hair_cut.Avatar.Body.Arms.LeftArm.LeftArmBottom.HairPiece:setVisible(false)
		elseif self.AnimationCount == 90 then
			HairCut.ScissorsItem:enabled(false)
		elseif self.AnimationCount <= 80 and self.AnimationCount >= 53 and (self.AnimationCount - 80) % 13 == 0 then
			sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
		elseif self.AnimationCount == 40 then
			FaceParts.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
			local playerPos = player:getPos()
			sounds:playSound("entity.player.levelup", playerPos, 1, 1.5)
			for _ = 1, 30 do
				particles:newParticle("happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
			end
		end
	end
end

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

return HairCut