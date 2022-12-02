---@class BroomCleaning 箒掃除のアニメーションを制御するクラス

BroomCleaning = General.instance({}, AnimationAction, function ()
	return SitDown:checkAction() and not General.isAnimationPlaying("models.main", "sit_down")
end, models.models.broom_cleaning, models.models.broom_cleaning, animations["models.main"]["broom_cleaning"], General.getAnimationsOutOfMain("broom_cleaning"), 35)

---お掃除アニメーションを再生する。
function BroomCleaning.play(self)
	AnimationAction.play(self)
	self.HideHeldItem = true
	models.models.broom_cleaning.Avatar.Dust:setOpacity(1)
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
end

---お掃除アニメーションを停止する。
function BroomCleaning.stop(self)
	AnimationAction.stop(self)
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
end

---アニメーション再生中に毎チック実行される関数
function BroomCleaning.onAnimationTick(self)
	AnimationAction.onAnimationTick(self)
	if (self.AnimationCount + 8) % 17 == 0 and self.AnimationCount > 49 then
		sounds:playSound("entity.cat.hiss", player:getPos(), 0.5, 2)
		models.models.broom_cleaning.Avatar.Dust:setOpacity(models.models.broom_cleaning.Avatar.Dust:getOpacity() - 0.14)
		local dustParticlePivot = models.models.broom_cleaning.Avatar.Dust.DustParticlePivot:partToWorldMatrix()
		for _ = 1, 5 do
			particles:newParticle("block gravel", dustParticlePivot[4][1], dustParticlePivot[4][2], dustParticlePivot[4][3])
		end
	elseif self.AnimationCount == 41 then
		FacePartsClass.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
		local playerPos = player:getPos()
		sounds:playSound("entity.player.levelup", playerPos, 1, 1.5)
		for _ = 1, 30 do
			particles:newParticle("happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
		end
	end
end

return BroomCleaning