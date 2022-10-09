---@class BroomClass 箒掃除のアニメーションを制御するクラス
---@field BroomClass.canBroomCleaning boolean 箒掃除のアニメーションが実行可能かどうか
---@field BroomAnimationCount integer アニメーションの再生時間を示すカウンター。-1は停止中。

BroomClass = {}
BroomClass.canBroomCleaning = false
BroomAnimationCount = 0
Count = 0

---お掃除アニメーションを再生する。
function BroomClass.play()
	models.models.broom:setVisible(true)
	models.models.broom.Avatar.Dust:setOpacity(1)
	General.setAnimations("PLAY", "broom_cleaning")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	BroomAnimationCount = 169
end

---お掃除アニメーションを停止する。
function BroomClass.stop()
	models.models.broom:setVisible(false)
	General.setAnimations("STOP", "broom_cleaning")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	for _, modelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
		modelPart:setVisible(true)
	end
	ArmsClass.ItemHeldContradicts = {false, false}
	BroomAnimationCount = 0
end

events.TICK:register(function ()
	Count = Count + 1
	BroomClass.canBroomCleaning = player:getPose() == "STANDING" and player:isOnGround() and not player:getVehicle() and player:getVelocity():length() == 0 and HurtClass.Damaged == "NONE" and animations["models.main"]["sit_down"]:getPlayState() ~= "PLAYING" and not WardenClass.WardenNearby
	if BroomAnimationCount > 0 then
		local leftHanded = player:isLeftHanded()
		if General.hasItem(player:getHeldItem(leftHanded)) ~= "none" then
			vanilla_model.RIGHT_ITEM:setVisible(false)
			ArmsClass.ItemHeldContradicts[1] = true
			models.models.broom.Avatar.Body.Arms.RightArm:setRot(-15, 0, 0)
		else
			vanilla_model.RIGHT_ITEM:setVisible(true)
			ArmsClass.ItemHeldContradicts[1] = false
			models.models.broom.Avatar.Body.Arms.RightArm:setRot(0, 0, 0)
		end
		if General.hasItem(player:getHeldItem(not leftHanded)) ~= "none" then
			vanilla_model.LEFT_ITEM:setVisible(false)
			ArmsClass.ItemHeldContradicts[2] = true
		else
			vanilla_model.LEFT_ITEM:setVisible(true)
			ArmsClass.ItemHeldContradicts[2] = false
		end
	end
	if (BroomAnimationCount + 8) % 17 == 0 and BroomAnimationCount > 49 then
		sounds:playSound("minecraft:entity.cat.hiss", player:getPos(), 0.5, 2)
		models.models.broom.Avatar.Dust:setOpacity(models.models.broom.Avatar.Dust:getOpacity() - 0.14)
		local dustPos = vectors.rotateAroundAxis(-(player:getBodyYaw() % 360), 0, 0, 0.65, 0, 1, 0):add(player:getPos())
		for _ = 1, 5 do
			particles:addParticle("minecraft:block minecraft:gravel", dustPos)
		end
	elseif BroomAnimationCount == 41 then
		FacePartsClass.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
		local playerPos = player:getPos()
		sounds:playSound("minecraft:entity.player.levelup", playerPos, 1, 1.5)
		for _ = 1, 30 do
			particles:addParticle("minecraft:happy_villager", playerPos:copy():add((math.random() - 0.5) * 4, (math.random() - 0.5) * 4 + 1, (math.random() - 0.5) * 4))
		end
	elseif BroomAnimationCount == 1 then
		BroomClass.stop()
	end
	BroomAnimationCount = BroomAnimationCount > 0 and BroomAnimationCount - 1 or 0
end)

models.models.broom:setVisible(false)
models.models.broom.Avatar.Body.Arms.RightArm.RightArmBottom:setParentType("None")

return BroomClass