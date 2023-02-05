---@class TailBrush 尻尾の手入れアニメーションを制御するクラス

TailBrush = General.instance({
	---尻尾の手入れアニメーションを再生する。
	play = function (self)
		AnimationAction.play(self)
		if SitDown.IsAnimationPlaying then
			animations["models.main"]["tail_brush_sitdown"]:play()
		end
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		Arms.hideHeldItem(true)
		Physics.EnablePyhsics[1] = false
		Sleeve.Moving = false
	end,

	---尻尾の手入れアニメーションを停止する。
	stop = function (self)
		if self.AnimationCount > 90 then
			sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		end
		AnimationAction.stop(self)
		animations["models.main"]["tail_brush_sitdown"]:stop()
		Physics.EnablePyhsics[1] = true
		if not SitDown.IsAnimationPlaying then
			Sleeve.Moving = true
		end
		Afk.TailBrushByAfk = false
	end,

	---アニメーション再生中に毎チック実行される関数
	onAnimationTick = function (self)
		AnimationAction.onAnimationTick(self)
		if (self.AnimationCount + 50) % 20 == 0 and self.AnimationCount <= 150 and self.AnimationCount >= 110 then
			sounds:playSound("block.grass.step", player:getPos(), 1, 1)
		elseif self.AnimationCount == 90 then
			sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
			models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.BrushRAB:setVisible(false)
		elseif (self.AnimationCount + 80) % 20 == 0 and self.AnimationCount <= 80 and self.AnimationCount >= 40  then
			if self.AnimationCount == 80 then
				FaceParts.setEmotion("CLOSED", "CLOSED", "CLOSED", 60, true)
			end
			sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
		end
	end
}, AnimationAction, function ()
	return player:getPose() == "STANDING" and not player:isInLava() and player:getFrozenTicks() == 0 and not player:getVehicle() and player:getVelocity():length() == 0 and Hurt.Damaged == "NONE" and not Warden.WardenNearby and Wet.WetCount == 0 and not player:isUsingItem() and not Kotatsu.IsAnimationPlaying
end, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.BrushRAB, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.BrushRAB, animations["models.main"]["tail_brush"], nil, 0)

return TailBrush