---@class HairCut 散髪のアニメーションを制御するクラス
---@field ChairBlock BlockTask 椅子の代わりのオークの木の階段の描画を行うレンダータスク
---@field ScissorsItem ItemTask はさみの描画を行うレンダータスク
HairCut = General.instance({
	ChairBlock = models.models.hair_cut:newBlock("hair_cut.chair"):block("minecraft:oak_stairs"):pos(8, -6, -4):rot(0, 180), --椅子代わりの階段ブロックのレンダータスク
	ScissorsItem = models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.HairCutRAB.Scissors:newItem("hair_cut.scissors"):item("minecraft:shears"):pos(2, 0, -3):rot(-90, 45, 0):scale(0.5, 0.5, 0.5):setVisible(false), --鋏のアイテムレンダータスク。

	---散髪アニメーションを再生する。
	play = function (self)
		AnimationAction.play(self)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		Sleeve.Moving = false
		Arms.hideHeldItem(true)
	end,

	---散髪アニメーションを停止する。
	stop = function (self)
		AnimationAction.stop(self)
		HairCut.ScissorsItem:setVisible(false)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		Sleeve.Moving = true
	end,

	---アニメーション再生中に毎チック実行される関数
	onAnimationTick = function (self)
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
				local splashPos = vectors.rotateAroundAxis(-(player:getBodyYaw() % 360), 0, 0, 0.3, 0, 1):add(player:getPos():add(0, 1))
				for _ = 1, 5 do
					particles:newParticle("splash", splashPos)
				end
			elseif self.AnimationCount == 383 then
				for _, modelPart in ipairs({models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.HairCutRAB.Spray, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.HairCutLAB.Comb}) do
					modelPart:setVisible(false)
				end
				HairCut.ScissorsItem:setVisible(true)
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
				models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.HairCutLAB.HairPiece:setVisible(true)
			elseif self.AnimationCount == 276 then
				sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
			elseif self.AnimationCount == 236 then
				sounds:playSound("entity.wolf.shake", player:getPos(), 1, 1.5)
				FaceParts.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 20, true)
			elseif self.AnimationCount == 216 then
				models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.HairCutLAB.HairPiece:setVisible(false)
			elseif self.AnimationCount == 90 then
				HairCut.ScissorsItem:setVisible(false)
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
}, AnimationAction, function ()
	return BroomCleaning:checkAction()
end, {models.models.hair_cut, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.HairCutRAB, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.HairCutRAB.Spray, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.HairCutRAB.Spray, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.HairCutRAB.Scissors, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.HairCutLAB, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.HairCutLAB.Comb, models.models.dummy_player}, {models.models.hair_cut, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.HairCutRAB, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.HairCutRAB.Spray, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.HairCutRAB.Scissors, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.HairCutLAB, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.HairCutLAB.Comb, models.models.dummy_player}, animations["models.main"]["hair_cut"], {animations["models.hair_cut"]["hair_cut"], animations["models.dummy_player"]["hair_cut"]}, 8)

models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.HairCutLAB.HairPiece:setPrimaryTexture("SKIN")

return HairCut