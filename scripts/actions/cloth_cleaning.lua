---@class ClothCleaning 雑巾がけのアニメーションを制御するクラス

ClothCleaning = General.instance({}, AnimationAction, function ()
	return BroomCleaning:checkAction()
end, {models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ClothRAB, models.models.cloth_cleaning.Stain}, {models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ClothRAB, models.models.cloth_cleaning.Stain}, animations["models.main"]["cloth_cleaning"], {animations["models.cloth_cleaning"]["cloth_cleaning"], animations["models.costume_maid_a"]["cloth_cleaning"], animations["models.costume_maid_b"]["cloth_cleaning"]}, 40)

---雑巾がけアニメーションを再生する。
function ClothCleaning.play(self)
	AnimationAction.play(self)
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	Arms.hideHeldItem(true)
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
	elseif self.AnimationCount == 41 then
		FaceParts.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
		local playerPos = player:getPos()
		sounds:playSound("entity.player.levelup", playerPos, 1, 1.5)
		for _ = 1, 30 do
			particles:newParticle("happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
		end
	end
end

return ClothCleaning