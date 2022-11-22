---@class KotatsuClass こたつアニメーションを制御するクラス
---@field KotatsuClass.CanKotatsu boolean こたつアニメーションが再生可能かどうか
---@field KotatsuAnimationCount integer こたつアニメーションのタイミングを計るカウンター
---@field BodyYawPrev integer 前チックの体のヨー

KotatsuClass = {}

KotatsuClass.CanKotatsu = false
KotatsuAnimationCount = 0
BodyYawPrev = 0

---こたつアニメーションを再生する。
function KotatsuClass.play()
	models.models.kotatsu:setVisible(true)
	General.setAnimations("PLAY", "kotatsu")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	print(LanguageClass.getTranslate("action_wheel__main_1__action_7__start"))
	PhysicsClass.EnablePyhsics[1] = false
	KotatsuAnimationCount = 1
end

---こたつアニメーションを停止する。
function KotatsuClass.stop()
	models.models.kotatsu:setVisible(false)
	General.setAnimations("STOP", "kotatsu")
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	for _, modelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
		modelPart:setVisible(true)
	end
	ArmsClass.ItemHeldContradicts = {false, false}
	PhysicsClass.EnablePyhsics[1] = true
	KotatsuAnimationCount = 0
end

events.TICK:register(function ()
	local bodyYaw = player:getBodyYaw()
	KotatsuClass.CanKotatsu = BroomCleaningClass.CanBroomCleaning and bodyYaw == BodyYawPrev
	if KotatsuAnimationCount > 0 then
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
		if KotatsuAnimationCount == 282 then
			sounds:playSound("block.grass.step", player:getPos(), 1, 1)
		elseif KotatsuAnimationCount == 275 or KotatsuAnimationCount == 287 then
			sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
		end
		FacePartsClass.setEmotion("CLOSED", "CLOSED", "CLOSED", 1, true)
		ActionWheelClass.ActionCount = 1
		KotatsuAnimationCount = KotatsuAnimationCount == 300 and 1 or KotatsuAnimationCount + 1
	end
	BodyYawPrev = bodyYaw
end)

return KotatsuClass