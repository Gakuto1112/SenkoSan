---@class EarpickClass 耳かきのアニメーションを制御するクラス
---@field AnimationCount integer アニメーションの再生時間を示すカウンター。-1は停止中。

EarpickClass = {}

AnimationCount = -1

---耳かきアニメーションを再生する。
function EarpickClass.play()
	for _, modelPart in ipairs({models.models.ear_cleaning.Avatar, models.models.ear_cleaning.LyingPlayer}) do
		modelPart:setVisible(true)
	end
	General.setAnimations("PLAY", "earpick")
	General.setAnimations("PLAY", "earpick_arm_fix")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	AnimationCount = 0
end

---耳かきアニメーションを停止する。
function EarpickClass.stop()
	for _, modelPart in ipairs({models.models.ear_cleaning.Avatar, models.models.ear_cleaning.LyingPlayer}) do
		modelPart:setVisible(false)
	end
	General.setAnimations("STOP", "earpick")
	General.setAnimations("STOP", "earpick_arm_fix")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	AnimationCount = -1
end

events.TICK:register(function ()
	if AnimationCount >= 0 then
		local playerPos = player:getPos()
		for _ = 1, 5 do
			particles:addParticle("minecraft:end_rod", playerPos.x + (math.random() - 0.5) * 10, playerPos.y + (math.random() - 0.5) * 10, playerPos.z + (math.random() - 0.5) * 10)
		end
		local leftHanded = player:isLeftHanded()
		if General.hasItem(player:getHeldItem(leftHanded)) ~= "none" then
			vanilla_model.RIGHT_ITEM:setVisible(false)
			models.models.main.Avatar.Body.Arms.RightArm:setRot(-20, 0, 0)
			models.models.ear_cleaning.Avatar.RightArm:setRot(-20, 0, 0)
		else
			vanilla_model.RIGHT_ITEM:setVisible(true)
			models.models.main.Avatar.Body.Arms.RightArm:setRot(0, 0, 0)
			models.models.ear_cleaning.Avatar.RightArm:setRot(0, 0, 0)
		end
		if General.hasItem(player:getHeldItem(not leftHanded)) ~= "none" then
			vanilla_model.LEFT_ITEM:setVisible(false)
			models.models.main.Avatar.Body.Arms.LeftArm:setRot(-20, 0, 0)
		else
			vanilla_model.LEFT_ITEM:setVisible(true)
			models.models.main.Avatar.Body.Arms.LeftArm:setRot(0, 0, 0)
		end
	else
		vanilla_model.RIGHT_ITEM:setVisible(true)
		vanilla_model.LEFT_ITEM:setVisible(true)
		local playerPose = player:getPose()
		if playerPose ~= "CROUCHING" and playerPose ~= "SLEEPING" then
			models.models.main.Avatar.Body.Arms.RightArm:setRot(0, 0, 0)
			models.models.main.Avatar.Body.Arms.LeftArm:setRot(0, 0, 0)
		end
	end
	if AnimationCount == 33 then
		FacePartsClass.setEmotion("CLOSED", "CLOSED", "CLOSED", 40, true)
	elseif AnimationCount == 160 then
		FacePartsClass.setEmotion("CLOSED", "CLOSED", "OPENED", 40, true)
		local playerPos = player:getPos()
		sounds:playSound("minecraft:entity.player.levelup", playerPos, 1, 1.5)
		for _ = 1, 30 do
			particles:addParticle("minecraft:happy_villager", playerPos.x + (math.random() - 0.5) * 4, playerPos.y + (math.random() - 0.5) * 4 + 1, playerPos.z + (math.random() - 0.5) * 4)
		end
	end
	if AnimationCount == 200 then
		EarpickClass.stop()
		AnimationCount = -1
	else
		AnimationCount = AnimationCount >= 0 and AnimationCount + 1 or -1
	end
end)

models.models.ear_cleaning.LyingPlayer:setPrimaryTexture("SKIN")
if player:getModelType() == "DEFAULT" then
	for _, modelPart in ipairs({models.models.ear_cleaning.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerRightArms.LyingPlayerRightArmSlim, models.models.ear_cleaning.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerLeftArms.LyingPlayerLeftArmSlim}) do
		modelPart:setVisible(false)
	end
else
	for _, modelPart in ipairs({models.models.ear_cleaning.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerRightArms.LyingPlayerRightArmClassic, models.models.ear_cleaning.LyingPlayer.LyingPlayerBody.LyingPlayerArms.LyingPlayerLeftArms.LyingPlayerLeftArmClassic}) do
		modelPart:setVisible(false)
	end
end
for _, modelPart in ipairs({models.models.ear_cleaning.Avatar, models.models.ear_cleaning.LyingPlayer}) do
	modelPart:setVisible(false)
end

return EarpickClass