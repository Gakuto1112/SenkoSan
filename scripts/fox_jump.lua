---@class FoxJumpClass キツネジャンプのアニメーションを制御するクラス
---@field FoxJumpClass.CanFoxJump boolean キツネジャンプが実行可能かどうか
---@field FoxJumpAnimationCount integer アニメーションの再生時間を示すカウンター。

FoxJumpClass = {}
FoxJumpClass.CanFoxJump = false
FoxJumpAnimationCount = 0


---キツネジャンプのアニメーションを再生する。
function FoxJumpClass.play()
	General.setAnimations("PLAY", "fox_jump")
	UmbrellaClass.EnableUmbrella = false
	FoxJumpAnimationCount = 128
end

---キツネジャンプアニメーションを停止する。
function FoxJumpClass.stop()
	General.setAnimations("STOP", "fox_jump")
	FacePartsClass:resetEmotion()
	UmbrellaClass.EnableUmbrella = true
	FoxJumpAnimationCount = 0
end

events.TICK:register(function ()
	local targetPos = vectors.rotateAroundAxis(-(player:getBodyYaw() % 360), 0, 0, 1, 0, 1, 0):add(player:getPos()):add(0, 0.5, 0)
	local block1_1 = world.getBlockState(targetPos:copy():add(0, -1, 0))
	local block10 = world.getBlockState(targetPos)
	local block1_1SnowLayer = block1_1.id == "minecraft:snow" and tonumber(block1_1.properties["layers"]) >= 6 or false
	FoxJumpClass.CanFoxJump = BroomCleaningClass.CanBroomCleaning and (block10.id == "minecraft:air" or block10.id == "minecraft:snow") and (block1_1.id == "minecraft:snow_block" or block1_1SnowLayer) and world.getBlockState(targetPos:copy():add(0, 1, 0)).id == "minecraft:air" and world.getBlockState(targetPos:copy():add(0, 2, 0)).id == "minecraft:air" and world.getBlockState(player:getPos():add(0, 2, 0)).id == "minecraft:air"
	if FoxJumpAnimationCount > 0 then
		if FoxJumpAnimationCount == 98 then
			sounds:playSound("entity.snowball.throw", player:getPos(), 1, 1.5)
			FacePartsClass.setEmotion("UNEQUAL", "UNEQUAL", "OPENED", 11, true)
		elseif FoxJumpAnimationCount == 87 or (FoxJumpAnimationCount <= 83 and FoxJumpAnimationCount >= 32 and (FoxJumpAnimationCount - 83) % 3 == 0) or FoxJumpAnimationCount == 18 then
			sounds:playSound("block.snow.break", player:getPos(), 1, 1)
			for _ = 1, 5 do
				particles:newParticle("block minecraft:snow_block", targetPos)
			end
			if FoxJumpAnimationCount == 87 then
				FacePartsClass.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 69, true)
			elseif FoxJumpAnimationCount == 18 then
				sounds:playSound("entity.snowball.throw", player:getPos(), 1, 1.5)
			end
		elseif FoxJumpAnimationCount == 1 then
			ActionWheelClass.bodyShake(true)
		end
		FoxJumpAnimationCount = FoxJumpAnimationCount > 0 and (client:isPaused() and FoxJumpAnimationCount or FoxJumpAnimationCount - 1) or 0
	end
end)

return FoxJumpClass