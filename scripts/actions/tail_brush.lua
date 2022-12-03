---@class TailBrush 尻尾の手入れアニメーションを制御するクラス

TailBrush = General.instance({}, AnimationAction, function ()
	return SitDown:checkAction() and not player:isWet()
end, {models.models.tail_brush, models.models.tail_brush.Avatar.Body.Arms.RightArm.RightArmBottom.Brush}, {models.models.tail_brush, models.models.tail_brush.Avatar.Body.Arms.RightArm.RightArmBottom.Brush}, animations["models.main"]["tail_brush"], General.getAnimations("tail_brush", false), 0)

---尻尾の手入れアニメーションを再生する。
function TailBrush.play(self)
	AnimationAction.play(self)
	if SitDown.IsAnimationPlaying then
		General.setAnimations("PLAY", "tail_brush_sitdown")
	end
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	self.HideHeldItem = true
	Physics.EnablePyhsics[1] = false
end

---尻尾の手入れアニメーションを停止する。
function TailBrush.stop(self)
	if self.AnimationCount > 90 then
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	end
	AnimationAction.stop(self)
	General.setAnimations("STOP", "tail_brush_sitdown")
	Physics.EnablePyhsics[1] = true
end

---アニメーション再生中に毎チック実行される関数
function TailBrush.onAnimationTick(self)
	AnimationAction.onAnimationTick(self)
	if (self.AnimationCount + 50) % 20 == 0 and self.AnimationCount <= 150 and self.AnimationCount >= 110 then
		sounds:playSound("block.grass.step", player:getPos(), 1, 1)
	elseif self.AnimationCount == 90 then
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		models.models.tail_brush.Avatar.Body.Arms.RightArm.RightArmBottom.Brush:setVisible(false)
	elseif (self.AnimationCount + 80) % 20 == 0 and self.AnimationCount <= 80 and self.AnimationCount >= 40  then
		if self.AnimationCount == 80 then
			FaceParts.setEmotion("CLOSED", "CLOSED", "CLOSED", 60, true)
		end
		sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
	end
end

return TailBrush