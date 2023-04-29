---@class TeaTime お茶飲みのアニメーションを制御するクラス
TeaTime = General.instance({
	---お茶飲みのアニメーションを再生する。
	play = function (self)
		AnimationAction.play(self)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		Arms.RightArmRotOffset = vectors.vec3(-20, -10, 15)
		Arms.LeftArmRotOffset = vectors.vec3(-20, 10, -15)
		Arms.hideHeldItem(true)
	end,

	---お茶飲みのアニメーションを停止する。
	stop = function (self)
		AnimationAction.stop(self)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	end,

	---アニメーション再生中に毎チック実行される関数
	onAnimationTick = function (self)
		AnimationAction.onAnimationTick(self)
		local yunomi2ParticlePivot = models.models.tea.Table.TableItems.Yunomi2.Yunomi2ParticlePivot:partToWorldMatrix()
		particles:newParticle("poof", yunomi2ParticlePivot[4][1], yunomi2ParticlePivot[4][2], yunomi2ParticlePivot[4][3]):scale(0.2):velocity(0, 0, 0):lifetime(15)
		if self.AnimationCount > 50 then
			local yunomi1ParticlePivot = models.models.main.Avatar.Body.Yunomi1.Yunomi1ParticlePivot:partToWorldMatrix()
			particles:newParticle("poof", yunomi1ParticlePivot[4][1], yunomi1ParticlePivot[4][2], yunomi1ParticlePivot[4][3]):scale(0.2):velocity(0, 0, 0):lifetime(15)
		end
		if self.AnimationCount <= 210 and self.AnimationCount > 50 and (self.AnimationCount - 210) % 20 == 0 then
			if self.AnimationCount == 210 then
				FaceParts.setEmotion("CLOSED", "CLOSED", "CLOSED", 160, true)
			end
			sounds:playSound("entity.generic.drink", player:getPos(), 0.5, 1)
		elseif self.AnimationCount == 50 then
		elseif self.AnimationCount == 40 then
			FaceParts.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
			local playerPos = player:getPos()
			sounds:playSound("entity.player.levelup", playerPos, 1, 1.5)
			sounds:playSound("block.stone.break", player:getPos(), 0.5, 1)
			for _ = 1, 30 do
				particles:newParticle("happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
			end
		end
	end
}, AnimationAction, function ()
	return Earpick:checkAction()
end, {models.models.tea, models.models.main.Avatar.Body.Yunomi1}, {models.models.tea, models.models.main.Avatar.Body.Yunomi1}, animations["models.main"]["tea_time"], {animations["models.tea"]["tea_time"], animations["models.main"]["earpick_arm_fix"]}, 40)

models.models.tea.Table.Board:setPrimaryTexture("RESOURCE", "textures/block/spruce_planks.png")
models.models.tea.Table.TableLegs:setPrimaryTexture("RESOURCE", "textures/block/spruce_log.png")

return TeaTime