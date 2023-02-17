EarCuddling = General.instance({
    ---お耳モフモフアニメーションを再生する。
    play = function (self)
        AnimationAction.play(self)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
        FaceParts.setComplexion("BLUSH", 382, true)
        Physics.EnablePyhsics[1] = false
    end,

    ---お耳モフモフアニメーションを停止する。
    stop = function (self)
        if self.AnimationCount > 102 then
            sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
        end
        AnimationAction.stop(self)
		Physics.EnablePyhsics[1] = true
    end,

    ---アニメーションを再生中に毎チック実行される関数
    onAnimationTick = function (self)
        AnimationAction.onAnimationTick(self)
        if self.AnimationCount == 322 then
            FaceParts.setEmotion("UNEQUAL", "UNEQUAL", "NONE", 70, true)
        elseif self.AnimationCount <= 252 and self.AnimationCount > 132 then
            if self.AnimationCount <= 252 and self.AnimationCount > 142 and (self.AnimationCount - 252) % 20 == 0 then
                if self.AnimationCount == 252 then
                    FaceParts.setEmotion("SURPLISED", "SURPLISED", "NONE", 120, true)
                    sounds:playSound("entity.experience_orb.pickup", player:getPos(), 0.25, 1.5)
                end
                sounds:playSound("block.wool.step", player:getPos(), 0.5, 1)
            end
            local playerPos = player:getPos()
			for _ = 1, 5 do
				particles:newParticle("minecraft:end_rod", playerPos:copy():add((math.random() - 0.5) * 10, (math.random() - 0.5) * 10, (math.random() - 0.5) * 10))
			end
        elseif self.AnimationCount == 132 then
            FaceParts.setEmotion("SURPLISED", "SURPLISED", "OPENED", 30, true)
            sounds:playSound("entity.player.attack.strong", player:getPos(), 1, 1)
        elseif self.AnimationCount <= 102 and self.AnimationCount > 60 then
            if self.AnimationCount == 102 then
                sounds:playSound("entity.lightning_bolt.thunder", player:getPos(), 1, 1)
                sounds:playSound("entity.lightning_bolt.impact", player:getPos(), 1, 1)
                models.models.dummy_player:setVisible(false)
                FaceParts.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 42, true)
            end
			sounds:playSound("entity.experience_orb.pickup", player:getPos(), 0.25, 1.5)
        elseif self.AnimationCount == 60 then
            FaceParts.setEmotion("TEAR", "TEAR", "NONE", 60, true)
            local playerPos = player:getPos()
            for _ = 1, 30 do
				particles:newParticle("angry_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
			end
        end
    end

}, AnimationAction, function ()
    return Earpick:checkAction() and ((Costume.CurrentCostume ~= "DISGUISE" and Costume.CurrentCostume ~= "KNIT" and Costume.CurrentCostume ~= "FOX_HOODIE_RED" and Costume.CurrentCostume ~= "FOX_HOODIE_WHITE" and Costume.CurrentCostume ~= "CASUAL" and Costume.CurrentCostume ~= "SANTA") or Armor.ArmorVisible[1])
end, models.models.dummy_player, models.models.dummy_player, animations["models.main"]["ear_cuddling"], {animations["models.dummy_player"]["ear_cuddling"], animations["models.costume_maid_a"]["ear_cuddling"], animations["models.costume_maid_b"]["ear_cuddling"]}, 60)

return EarCuddling