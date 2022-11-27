---@class TailCuddlingClass 尻尾モフモフアニメーションを制御するクラス
---@field TailCuddlingClass.CanCuddleTail boolean 尻尾モフモフのアニメーションが実行可能かどうか
---@field TailCuddlingAnimationCount integer アニメーションの再生時間を示すカウンター。

TailCuddlingClass = {}

TailCuddlingClass.CanCuddleTail = false
TailCuddlingAnimationCount = 0

---尻尾モフモフアニメーションを再生する。
function TailCuddlingClass.play()
	for _, modelPart in ipairs({models.models.tail_cuddling, models.models.tail_cuddling.SittingPlayer}) do
		modelPart:setVisible(true)
	end
	General.setAnimations("PLAY", "tail_cuddling")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	PhysicsClass.EnablePyhsics[1] = false
	UmbrellaClass.EnableUmbrella = false
	TailCuddlingAnimationCount = 380
end

---尻尾モフモフアニメーションを停止する。
function TailCuddlingClass.stop()
	for _, modelPart in ipairs({models.models.tail_cuddling, models.models.tail_cuddling.SittingPlayer}) do
		modelPart:setVisible(false)
	end
	General.setAnimations("STOP", "tail_cuddling")
	FacePartsClass:resetEmotion()
	if TailCuddlingAnimationCount > 20 then
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	end
	for _, modelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
		modelPart:setVisible(true)
	end
	PhysicsClass.EnablePyhsics[1] = true
	UmbrellaClass.EnableUmbrella = true
	TailCuddlingAnimationCount = 0
end

events.TICK:register(function ()
	TailCuddlingClass.CanCuddleTail = General.isAnimationPlaying("models.main", "sit_down") and CostumeClass.CurrentCostume ~= "DISGUISE" and (not ArmorClass.ShowArmor or not ArmorClass.ArmorVisible[2]) and not player:isWet() and WetClass.WetCount == 0
	if TailCuddlingAnimationCount > 0 then
		if TailCuddlingAnimationCount <= 270 and TailCuddlingAnimationCount >= 20 then
			local playerPos = player:getPos()
			for _ = 1, 5 do
				particles:addParticle("minecraft:end_rod", playerPos:copy():add((math.random() - 0.5) * 10, (math.random() - 0.5) * 10, (math.random() - 0.5) * 10))
			end
		end
		if TailCuddlingAnimationCount == 370 then
			if General.PlayerCondition == "LOW" then
				FacePartsClass.setEmotion("TIRED", "TIRED_INVERSED", "NONE", 100, true)
			else
				FacePartsClass.setEmotion("NORMAL", "NORMAL_INVERSED", "NONE", 100, true)
			end
			FacePartsClass.setComplexion("BLUSH", 210, true)
		elseif TailCuddlingAnimationCount == 270 then
			FacePartsClass.setEmotion("SURPLISED", "SURPLISED", "NONE", 90, true)
			sounds:playSound("entity.experience_orb.pickup", player:getPos(), 0.25, 1.5)
		elseif TailCuddlingAnimationCount <= 250 and TailCuddlingAnimationCount >= 160 then
			if (TailCuddlingAnimationCount - 250) % 20 == 0 then
				sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
			end
			if TailCuddlingAnimationCount == 180 then
				FacePartsClass.setEmotion("UNEQUAL", "UNEQUAL", "NONE", 20, true)
				sounds:playSound("minecraft:entity.wolf.shake", player:getPos(), 1, 1.5)
			elseif TailCuddlingAnimationCount == 160 then
				FacePartsClass.setEmotion("CLOSED", "CLOSED", "NONE", 100, true)
			end
		elseif TailCuddlingAnimationCount <= 130 and TailCuddlingAnimationCount >= 20 then
			if (TailCuddlingAnimationCount - 130) % 10 == 0 then
				sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
			end
			if TailCuddlingAnimationCount == 60 then
				FacePartsClass.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
				local playerPos = player:getPos()
				sounds:playSound("minecraft:entity.player.levelup", playerPos, 1, 1.5)
				for _ = 1, 30 do
					particles:addParticle("minecraft:happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
				end
			elseif TailCuddlingAnimationCount == 20 then
				models.models.tail_cuddling.SittingPlayer:setVisible(false)
				sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
			end
		elseif TailCuddlingAnimationCount == 1 then
			TailCuddlingClass.stop()
		end
		TailCuddlingAnimationCount = TailCuddlingAnimationCount > 0 and (client:isPaused() and TailCuddlingAnimationCount or TailCuddlingAnimationCount - 1) or 0
	end
end)

models.models.tail_cuddling.SittingPlayer:setPrimaryTexture("SKIN")
if player:getModelType() == "DEFAULT" then
	for _, modelPart in ipairs({models.models.tail_cuddling.SittingPlayer.SittingPlayerBody.SittingPlayerArms.SittingPlayerRightArms.SittingPlayerRightArmSlim, models.models.tail_cuddling.SittingPlayer.SittingPlayerBody.SittingPlayerArms.SittingPlayerLeftArms.SittingPlayerLeftArmSlim}) do
		modelPart:setVisible(false)
	end
else
	for _, modelPart in ipairs({models.models.tail_cuddling.SittingPlayer.SittingPlayerBody.SittingPlayerArms.SittingPlayerRightArms.SittingPlayerRightArmClassic, models.models.tail_cuddling.SittingPlayer.SittingPlayerBody.SittingPlayerArms.SittingPlayerLeftArms.SittingPlayerLeftArmClassic}) do
		modelPart:setVisible(false)
	end
end

return TailCuddlingClass