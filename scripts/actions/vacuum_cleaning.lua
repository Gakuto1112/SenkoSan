---@class VacuumCleaning 掃除機での掃除のアニメーションを制御するクラス

VacuumCleaning = General.instance({}, AnimationAction, function ()
	return BroomCleaning:checkAction()
end, models.models.vacuum_cleaning, models.models.vacuum_cleaning, animations["models.main"]["vacuum_cleaning"], General.getAnimationsOutOfMain("vacuum_cleaning"), 0)

---掃除機アニメーションを再生する。
function VacuumCleaning.play(self)
	AnimationAction.play(self)
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	self.HideHeldItem = true
end

---掃除機アニメーションを停止する。
function VacuumCleaning.stop(self)
	if self.AnimationCount > 148 then
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	end
	AnimationAction.stop(self)
end

---アニメーション再生中に毎チック実行される関数
function VacuumCleaning.onAnimationTick(self)
	AnimationAction.onAnimationTick(self)
	if self.AnimationCount == 236 then
		sounds:playSound("block.stone_button.click_on", player:getPos(), 1, 1.5)
	elseif self.AnimationCount <= 231 and self.AnimationCount > 148 then
		if self.AnimationCount <= 231 and self.AnimationCount > 192 then
			if self.AnimationCount == 231 then
				FaceParts.setEmotion("SURPLISED", "SURPLISED", "CLOSED", 39, true)
				Ears.setEarsRot("DROOPING", 230, true)
			end
			sounds:playSound("entity.experience_orb.pickup", player:getPos(), 0.25, 1.5)
		elseif self.AnimationCount <= 189 and self.AnimationCount >= 149 and (self.AnimationCount - 149) % 10 == 0 then
			sounds:playSound("entity.iron_golem.step", player:getPos(), 1, 1)
		end
		if self.AnimationCount == 192 then
			FaceParts.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 76, true)
		end
		sounds:playSound("entity.minecart.riding", player:getPos(), 0.25, 2)
		local exhaustParticlePivot = models.models.vacuum_cleaning.VeccumCleaner.ExhaustParticlePivot:partToWorldMatrix()
		particles:newParticle("poof", exhaustParticlePivot[4][1], exhaustParticlePivot[4][2], exhaustParticlePivot[4][3]):scale(0.3)
	elseif self.AnimationCount == 148 then
		models.models.vacuum_cleaning:setVisible(false)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	elseif self.AnimationCount == 119 then
		FaceParts.setEmotion("SURPLISED", "SURPLISED", "CLOSED", 85, true)
	elseif self.AnimationCount == 34 then
		FaceParts.setEmotion("CLOSED", "CLOSED", "CLOSED", 30, true)
	end
end

return VacuumCleaning