---@class FoxJump キツネジャンプのアニメーションを制御するクラス
---@field FoxJump.TargetPos Vector3 ジャンプする先の座標

FoxJump = General.instance({}, AnimationAction, function ()
	FoxJump.TargetPos = vectors.rotateAroundAxis(-(player:getBodyYaw() % 360), 0, 0, 1, 0, 1, 0):add(player:getPos()):add(0, 0.5, 0)
	local block1_1 = world.getBlockState(FoxJump.TargetPos:copy():add(0, -1, 0))
	local block10 = world.getBlockState(FoxJump.TargetPos)
	return BroomCleaning:checkAction() and (block10.id == "minecraft:air" or block10.id == "minecraft:snow") and (block1_1.id == "minecraft:snow_block" or (block1_1.id == "minecraft:snow" and tonumber(block1_1.properties["layers"]) >= 6 or false)) and world.getBlockState(FoxJump.TargetPos:copy():add(0, 1, 0)).id == "minecraft:air" and world.getBlockState(FoxJump.TargetPos:copy():add(0, 2, 0)).id == "minecraft:air" and world.getBlockState(player:getPos():add(0, 2, 0)).id == "minecraft:air"
end, nil, nil, animations["models.main"]["fox_jump"], General.getAnimations("fox_jump", false), 10)

FoxJump.TargetPos = vectors.vec3(0, 0, 0)

---キツネジャンプアニメーションを再生する。
function FoxJump.play(self)
	AnimationAction.play(self)
	self.HideHeldItem = true
end

---アニメーション再生中に毎チック実行される関数
function FoxJump.onAnimationTick(self)
	AnimationAction.onAnimationTick(self)
	if self.AnimationCount == 98 then
		sounds:playSound("entity.snowball.throw", player:getPos(), 1, 1.5)
		FaceParts.setEmotion("UNEQUAL", "UNEQUAL", "OPENED", 11, true)
	elseif self.AnimationCount == 87 or (self.AnimationCount <= 83 and self.AnimationCount >= 32 and (self.AnimationCount - 83) % 3 == 0) or self.AnimationCount == 18 then
		sounds:playSound("block.snow.break", player:getPos(), 1, 1)
		for _ = 1, 5 do
			particles:newParticle("block minecraft:snow_block", FoxJump.TargetPos)
		end
		if self.AnimationCount == 87 then
			FaceParts.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 69, true)
		elseif self.AnimationCount == 18 then
			sounds:playSound("entity.snowball.throw", player:getPos(), 1, 1.5)
		end
	elseif self.AnimationCount == 1 then
		self:stop()
		ShakeBody:play(true)
	end
end

return FoxJump