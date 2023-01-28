---@class Massage マッサージのアニメーションを制御するクラス
---@field self.AnimationCount integer アニメーションの再生時間を示すカウンター。

Massage = General.instance({
	---マッサージのアニメーションを再生する。
	play = function (self)
		AnimationAction.play(self)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		Arms.RightArmRotOffset = vectors.vec3(-20, -10, 15)
		Arms.LeftArmRotOffset = vectors.vec3(-20, 10, -15)
		Arms.hideHeldItem(true)
	end,

	---マッサージのアニメーションを停止する。
	stop = function (self)
		AnimationAction.stop(self)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		Arms.resetArmRotOffset()
	end,

	---アニメーション再生中に毎チック実行される関数
	onAnimationTick = function (self)
		AnimationAction.onAnimationTick(self)
		local playerPos = player:getPos()
		for _ = 1, 5 do
			particles:newParticle("end_rod", playerPos:copy():add((math.random() - 0.5) * 10, (math.random() - 0.5) * 10, (math.random() - 0.5) * 10))
		end
		if (self.AnimationCount <= 403 and self.AnimationCount >= 373 and (self.AnimationCount - 403) % 15 == 0) or (self.AnimationCount <= 341 and self.AnimationCount >= 311 and (self.AnimationCount - 341) % 15 == 0) or (self.AnimationCount <= 279 and self.AnimationCount >= 249 and (self.AnimationCount - 279) % 15 == 0) or (self.AnimationCount <= 151 and self.AnimationCount >= 59 and (self.AnimationCount - 151) % 8 == 0) then
			sounds:playSound("block.wool.step", player:getPos(), 0.5, 1)
			if self.AnimationCount == 95 then
				FaceParts.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
				sounds:playSound("entity.player.levelup", playerPos, 1, 1.5)
				for _ = 1, 30 do
					particles:newParticle("happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
				end
			end
		end
	end
}, AnimationAction, function ()
	return Earpick:checkAction()
end, models.models.dummy_player, models.models.dummy_player, animations["models.main"]["massage"], {animations["models.dummy_player"]["massage"], animations["models.costume_maid_a"]["massage"], animations["models.costume_maid_b"]["massage"]}, 0)

return Massage