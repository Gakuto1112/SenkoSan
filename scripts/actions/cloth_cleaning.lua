---@class ClothCleaning 雑巾がけのアニメーションを制御するクラス

ClothCleaning = General.instance({}, AnimationAction, function ()
	return BroomCleaning:checkAnimation()
end, {models.models.cloth_cleaning, models.models.cloth_cleaning.Stain}, {models.models.cloth_cleaning, models.models.cloth_cleaning.Stain}, animations["models.main"]["cloth_cleaning"], General.getAnimationsOutOfMain("cloth_cleaning"), 40)

---雑巾がけアニメーションを再生する。
function ClothCleaning.play(self)
	AnimationAction.play(self)
	models.models.cloth_cleaning.Avatar.Body.Arms.RightArm.RightArmBottom.Cloth.Cloth:setUVPixels(0, 0)
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	self.HideHeldItem = true
end

---雑巾がけアニメーションを停止する。
function ClothCleaning.stop(self)
	AnimationAction.stop(self)
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
end

---アニメーション再生中に毎チック実行される関数

function ClothCleaning.onAnimationTick(self)
	AnimationAction.onAnimationTick(self)
	if self.AnimationCount == 91 then
		models.models.cloth_cleaning.Stain:setVisible(false)
		models.models.cloth_cleaning.Avatar.Body.Arms.RightArm.RightArmBottom.Cloth.Cloth:setUVPixels(0, 6)
	elseif self.AnimationCount == 41 then
		FacePartsClass.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
		local playerPos = player:getPos()
		sounds:playSound("entity.player.levelup", playerPos, 1, 1.5)
		for _ = 1, 30 do
			particles:newParticle("happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
		end
	end
end

return ClothCleaning