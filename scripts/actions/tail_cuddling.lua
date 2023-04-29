---@class TailCuddling 尻尾モフモフアニメーションを制御するクラス
TailCuddling = General.instance({
	---尻尾モフモフアニメーションを再生する。
	play = function (self)
		AnimationAction.play(self)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		Physics.EnablePyhsics[1] = false
	end,

	---尻尾モフモフアニメーションを停止する。
	stop = function (self)
		if self.AnimationCount > 20 then
			sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		end
		AnimationAction.stop(self)
		Physics.EnablePyhsics[1] = true
	end,

	---アニメーション再生中に毎チック実行される関数
	onAnimationTick = function (self)
		AnimationAction.onAnimationTick(self)
		if self.AnimationCount <= 270 and self.AnimationCount >= 20 then
			local playerPos = player:getPos()
			for _ = 1, 5 do
				particles:newParticle("minecraft:end_rod", playerPos:copy():add((math.random() - 0.5) * 10, (math.random() - 0.5) * 10, (math.random() - 0.5) * 10))
			end
		end
		if self.AnimationCount == 370 then
			if General.PlayerCondition == "LOW" then
				FaceParts.setEmotion("TIRED", "TIRED_INVERSED", "NONE", 100, true)
			else
				FaceParts.setEmotion("NORMAL", "NORMAL_INVERSED", "NONE", 100, true)
			end
			FaceParts.setComplexion("BLUSH", 210, true)
		elseif self.AnimationCount == 270 then
			FaceParts.setEmotion("SURPLISED", "SURPLISED", "NONE", 90, true)
			sounds:playSound("entity.experience_orb.pickup", player:getPos(), 0.25, 1.5)
		elseif self.AnimationCount <= 250 and self.AnimationCount >= 160 then
			if (self.AnimationCount - 250) % 20 == 0 then
				sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
			end
			if self.AnimationCount == 180 then
				FaceParts.setEmotion("UNEQUAL", "UNEQUAL", "NONE", 20, true)
				sounds:playSound("minecraft:entity.wolf.shake", player:getPos(), 1, 1.5)
			elseif self.AnimationCount == 160 then
				FaceParts.setEmotion("CLOSED", "CLOSED", "NONE", 100, true)
			end
		elseif self.AnimationCount <= 130 and self.AnimationCount >= 20 then
			if (self.AnimationCount - 130) % 10 == 0 then
				sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
			end
			if self.AnimationCount == 60 then
				FaceParts.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
				local playerPos = player:getPos()
				sounds:playSound("minecraft:entity.player.levelup", playerPos, 1, 1.5)
				for _ = 1, 30 do
					particles:newParticle("minecraft:happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
				end
			elseif self.AnimationCount == 20 then
				models.models.dummy_player:setVisible(false)
				sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
			end
		end
	end
}, AnimationAction, function ()
	return Earpick:checkAction() and Costume.CurrentCostume ~= "DISGUISE" and (not Armor.ShowArmor or not Armor.ArmorVisible[2]) and not player:isWet() and Wet.WetCount == 0
end, models.models.dummy_player, models.models.dummy_player, animations["models.main"]["tail_cuddling"], animations["models.dummy_player"]["tail_cuddling"], 0)

return TailCuddling