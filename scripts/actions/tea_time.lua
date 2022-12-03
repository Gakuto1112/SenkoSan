---@class TeaTime お茶飲みのアニメーションを制御するクラス

TeaTime = General.instance({}, AnimationAction, function ()
	return SitDown.IsAnimationPlaying
end, {models.models.tea, models.models.tea.Avatar.Body.Yunomi1.Tea}, {models.models.tea, models.models.tea.Avatar.Body.Yunomi1.Tea}, animations["models.main"]["tea_time"], General.getAnimationsOutOfMain("tea_time"), 40)

---お茶飲みのアニメーションを再生する。
function TeaTime:play()
	AnimationAction.play(self)
	General.setAnimations("PLAY", "earpick_arm_fix")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	self.HideHeldItem = true
end

---お茶飲みのアニメーションを停止する。
function TeaTime.stop(self)
	AnimationAction.stop(self)
	General.setAnimations("STOP", "earpick_arm_fix")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
end

---アニメーション再生中に毎チック実行される関数
function TeaTime.onAnimationTick(self)
	AnimationAction.onAnimationTick(self)
	local yunomi2ParticlePivot = models.models.tea.Avatar.Table.TableItems.Yunomi2.Yunomi2ParticlePivot:partToWorldMatrix()
	particles:newParticle("poof", yunomi2ParticlePivot[4][1], yunomi2ParticlePivot[4][2], yunomi2ParticlePivot[4][3]):scale(0.2):velocity(0, 0, 0):lifetime(15)
	if self.AnimationCount > 50 then
		local yunomi1ParticlePivot = models.models.tea.Avatar.Body.Yunomi1.Yunomi1ParticlePivot:partToWorldMatrix()
		particles:newParticle("poof", yunomi1ParticlePivot[4][1], yunomi1ParticlePivot[4][2], yunomi1ParticlePivot[4][3]):scale(0.2):velocity(0, 0, 0):lifetime(15)
	end
	if self.AnimationCount <= 210 and self.AnimationCount > 50 and (self.AnimationCount - 210) % 20 == 0 then
		if self.AnimationCount == 210 then
			FacePartsClass.setEmotion("CLOSED", "CLOSED", "CLOSED", 160, true)
		end
		sounds:playSound("entity.generic.drink", player:getPos(), 0.5, 1)
	elseif self.AnimationCount == 50 then
		models.models.tea.Avatar.Body.Yunomi1.Tea:setVisible(false)
	elseif self.AnimationCount == 40 then
		FacePartsClass.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
		local playerPos = player:getPos()
		sounds:playSound("entity.player.levelup", playerPos, 1, 1.5)
		sounds:playSound("block.stone.break", player:getPos(), 0.5, 1)
		for _ = 1, 30 do
			particles:newParticle("happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
		end
	end
end

models.models.tea.Avatar.Table.Board:setPrimaryTexture("RESOURCE", "textures/block/spruce_planks.png")
models.models.tea.Avatar.Table.TableLegs:setPrimaryTexture("RESOURCE", "textures/block/spruce_log.png")

return TeaTime