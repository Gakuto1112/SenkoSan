---@class ShakeBody ブルブルアニメーションを制御するクラス
---@field ShakeBody.SnowParticle boolean 雪のパーティクルを表示するかどうか

ShakeBody = General.instance({}, AnimationAction, function ()
	return not player:isUnderwater() and not player:isInLava() and not Warden.WardenNearby
end, nil, nil, animations["models.main"]["shake"], nil, 0)

ShakeBody.SnowParticle = false

---ブルブルアニメーションを再生する。
---@param snowParticle boolean 雪のパーティクルを表示するかどうか
function ShakeBody.play(self, snowParticle)
	AnimationAction.play(self)
	Umbrella.EnableUmbrella = true
	sounds:playSound("entity.wolf.shake", player:getPos(), 1, 1.5)
	FaceParts.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 20, true)
	ShakeBody.SnowParticle = snowParticle
end

---ブルブルアニメーションを停止する。
function ShakeBody.stop(self)
	AnimationAction.stop(self)
	if not Wet.IsWet then
		Wet.WetCount = 0
	end
end

---アニメーション再生中に毎チック実行される関数
function ShakeBody.onAnimationTick(self)
	AnimationAction.onAnimationTick(self)
	if self.AnimationCount % 5 == 0 then
		if ShakeBody.SnowParticle then
			for _ = 1, 6 do
				particles:newParticle("block snow_block", player:getPos():add(math.random() - 0.5, math.random() + 0.5, math.random() - 0.5))
			end
		elseif not Wet.IsWet and Wet.WetCount > 0 then
			for _ = 1, 4 do
				particles:newParticle("splash", player:getPos():add(math.random() - 0.5, math.random() + 0.5, math.random() - 0.5))
			end
		end
	end
end

return ShakeBody