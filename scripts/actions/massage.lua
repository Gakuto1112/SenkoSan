---@class Massage マッサージのアニメーションを制御するクラス
---@field self.AnimationCount integer アニメーションの再生時間を示すカウンター。

Massage = General.instance({}, AnimationAction, function ()
	return TailCuddling:checkAction()
end, models.models.massage, models.models.massage, animations["models.main"]["massage"], General.getAnimationsOutOfMain("massage"), 0)

---マッサージのアニメーションを再生する。
function Massage.play(self)
	AnimationAction.play(self)
	General.setAnimations("PLAY", "earpick_arm_fix")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
end

---マッサージのアニメーションを停止する。
function Massage.stop(self)
	AnimationAction.stop(self)
	General.setAnimations("STOP", "earpick_arm_fix")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
end

---アニメーション再生中に毎チック実行される関数
function Massage.onAnimationTick(self)
	AnimationAction.onAnimationTick(self)
	local playerPos = player:getPos()
	for _ = 1, 5 do
		particles:newParticle("end_rod", playerPos:copy():add((math.random() - 0.5) * 10, (math.random() - 0.5) * 10, (math.random() - 0.5) * 10))
	end
	if (self.AnimationCount <= 403 and self.AnimationCount >= 373 and (self.AnimationCount - 403) % 15 == 0) or (self.AnimationCount <= 341 and self.AnimationCount >= 311 and (self.AnimationCount - 341) % 15 == 0) or (self.AnimationCount <= 279 and self.AnimationCount >= 249 and (self.AnimationCount - 279) % 15 == 0) or (self.AnimationCount <= 151 and self.AnimationCount >= 59 and (self.AnimationCount - 151) % 8 == 0) then
		sounds:playSound("block.wool.step", player:getPos(), 0.5, 1)
		if self.AnimationCount == 95 then
			FacePartsClass.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
			sounds:playSound("entity.player.levelup", playerPos, 1, 1.5)
			for _ = 1, 30 do
				particles:newParticle("happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
			end
		end
	end
end

models.models.massage.LyingPlayer:setPrimaryTexture("SKIN")
if player:getModelType() == "DEFAULT" then
	for _, modelPart in ipairs({models.models.massage.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerRightArms.LyingPlayerRightArmSlim, models.models.massage.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerLeftArms.LyingPlayerLeftArmSlim}) do
		modelPart:setVisible(false)
	end
else
	for _, modelPart in ipairs({models.models.massage.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerRightArms.LyingPlayerRightArmClassic, models.models.massage.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerLeftArms.LyingPlayerLeftArmClassic}) do
		modelPart:setVisible(false)
	end
end

return Massage