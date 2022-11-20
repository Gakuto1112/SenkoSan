---@class TailBrushClass 尻尾の手入れアニメーションを制御するクラス
---@field TailBrushClass.CanBrushTail boolean 尻尾の手入れのアニメーションが実行可能かどうか
---@field TailBrushAnimationCount integer アニメーションの再生時間を示すカウンター。

TailBrushClass = {}

TailBrushClass.CanBrushTail = false
TailBrushAnimationCount = 0

---尻尾の手入れアニメーションを再生する。
function TailBrushClass.play()
	for _, modelPart in ipairs({models.models.tail_brush, models.models.tail_brush.Avatar.Body.Arms.RightArm.RightArmBottom.Brush}) do
		modelPart:setVisible(true)
	end
	General.setAnimations("PLAY", "tail_brush")
	if General.isAnimationPlaying("models.main", "sit_down") then
		General.setAnimations("PLAY", "tail_brush_sitdown")
	end
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	PhysicsClass.EnablePyhsics[1] = false
	TailBrushAnimationCount = 200
end

---尻尾の手入れアニメーションを停止する。
function TailBrushClass.stop()
	for _, modelPart in ipairs({models.models.tail_brush, models.models.tail_brush.Avatar.Body.Arms.RightArm.RightArmBottom.Brush}) do
		modelPart:setVisible(false)
	end
	General.setAnimations("STOP", "tail_brush")
	General.setAnimations("STOP", "tail_brush_sitdown")
	FacePartsClass:resetEmotion()
	if TailBrushAnimationCount > 90 then
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	end
	for _, modelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
		modelPart:setVisible(true)
	end
	ArmsClass.ItemHeldContradicts = {false, false}
	PhysicsClass.EnablePyhsics[1] = true
	TailBrushAnimationCount = 0
end

events.TICK:register(function ()
	TailBrushClass.CanBrushTail = SitDownClass.CanSitDown and not player:isWet()
	if TailBrushAnimationCount > 0 then
		local leftHanded = player:isLeftHanded()
		if player:getHeldItem(leftHanded).id ~= "minecraft:air" then
			vanilla_model.RIGHT_ITEM:setVisible(false)
			ArmsClass.ItemHeldContradicts[1] = true
			models.models.broom_cleaning.Avatar.Body.Arms.RightArm:setRot(-15, 0, 0)
		else
			vanilla_model.RIGHT_ITEM:setVisible(true)
			ArmsClass.ItemHeldContradicts[1] = false
			models.models.broom_cleaning.Avatar.Body.Arms.RightArm:setRot(0, 0, 0)
		end
		if player:getHeldItem(not leftHanded).id ~= "minecraft:air" then
			vanilla_model.LEFT_ITEM:setVisible(false)
			ArmsClass.ItemHeldContradicts[2] = true
		else
			vanilla_model.LEFT_ITEM:setVisible(true)
			ArmsClass.ItemHeldContradicts[2] = false
		end
		if (TailBrushAnimationCount + 50) % 20 == 0 and TailBrushAnimationCount <= 150 and TailBrushAnimationCount >= 110 then
			sounds:playSound("block.grass.step", player:getPos(), 1, 1)
		elseif TailBrushAnimationCount == 90 then
			sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
			models.models.tail_brush.Avatar.Body.Arms.RightArm.RightArmBottom.Brush:setVisible(false)
		elseif (TailBrushAnimationCount + 80) % 20 == 0 and TailBrushAnimationCount <= 80 and TailBrushAnimationCount >= 40  then
			if TailBrushAnimationCount == 80 then
				FacePartsClass.setEmotion("CLOSED", "CLOSED", "CLOSED", 60, true)
			end
			sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
		elseif TailBrushAnimationCount == 1 then
			TailBrushClass.stop()
		end
		TailBrushAnimationCount = TailBrushAnimationCount > 0 and (client:isPaused() and TailBrushAnimationCount or TailBrushAnimationCount - 1) or 0
	end
end)

return TailBrushClass