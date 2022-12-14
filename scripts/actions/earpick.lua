---@class Earpick 耳かきのアニメーションを制御するクラス

Earpick = General.instance({}, AnimationAction, function ()
	return SitDown.IsAnimationPlaying and not player:isUsingItem()
end, {models.models.main.Avatar.Body.Arms.RightArm.EarpickRA, models.models.ear_cleaning}, {models.models.main.Avatar.Body.Arms.RightArm.EarpickRA, models.models.ear_cleaning}, animations["models.main"]["earpick"], {animations["models.ear_cleaning"]["earpick"], animations["models.main"]["earpick_arm_fix"]}, 0)

---耳かきアニメーションを再生する。
function Earpick.play(self)
	AnimationAction.play(self)
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	Arms.hideHeldItem(true)
end

---耳かきアニメーションを停止する。
function Earpick.stop(self)
	AnimationAction.stop(self)
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
end

---アニメーション再生中に毎チック実行される関数
function Earpick.onAnimationTick(self)
	AnimationAction.onAnimationTick(self)
	local playerPos = player:getPos()
	for _ = 1, 5 do
		particles:newParticle("end_rod", playerPos:copy():add((math.random() - 0.5) * 10, (math.random() - 0.5) * 10, (math.random() - 0.5) * 10))
	end
	if self.AnimationCount == 184 then
		FaceParts.setEmotion("CLOSED", "CLOSED", "CLOSED", 40, true)
	elseif self.AnimationCount == 41 then
		FaceParts.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
		sounds:playSound("entity.player.levelup", playerPos, 1, 1.5)
		for _ = 1, 30 do
			particles:newParticle("happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
		end
	end
end

models.models.ear_cleaning.LyingPlayer:setPrimaryTexture("SKIN")
if player:getModelType() == "DEFAULT" then
	for _, modelPart in ipairs({models.models.ear_cleaning.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerRightArms.LyingPlayerRightArmSlim, models.models.ear_cleaning.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerLeftArms.LyingPlayerLeftArmSlim}) do
		modelPart:setVisible(false)
	end
else
	for _, modelPart in ipairs({models.models.ear_cleaning.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerRightArms.LyingPlayerRightArmClassic, models.models.ear_cleaning.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerLeftArms.LyingPlayerLeftArmClassic}) do
		modelPart:setVisible(false)
	end
end

return Earpick