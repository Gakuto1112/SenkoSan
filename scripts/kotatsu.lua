---@class Kotatsu こたつアニメーションを制御するクラス
---@field Kotatsu.ActionCount integer アニメーションのタイミングを計るカウンター
---@field Kotatsu.BodyYawPrev integer 前チックの体のヨー
---@field Kotatsu.TickEvent function コンストラクタでtickイベントに登録される関数

Kotatsu = General.instance({}, PermanentAnimationAction, function ()
	return BroomCleaning:checkAction() and player:getBodyYaw() == Kotatsu.BodyYawPrev
end, models.models.kotatsu, models.models.kotatsu, animations["models.main"]["kotatsu"], General.getAnimationsOutOfMain("kotatsu"))

Kotatsu.AnimationCount = 0
Kotatsu.BodyYawPrev = 0

function Kotatsu.onTickEvent(self)
	PermanentAnimationAction.onTickEvent(self)
	if self.IsAnimationPlaying then
		self:onAnimationTick()
	end
	Kotatsu.BodyYawPrev = player:getBodyYaw()
end

---こたつアニメーションを再生する。
function Kotatsu.play(self)
	PermanentAnimationAction.play(self)
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	print(LanguageClass.getTranslate("action_wheel__main_1__action_7__start"))
	PhysicsClass.EnablePyhsics[1] = false
	CameraClass.CameraOffset = -1
	NameplateClass.NamePlateOffset = -1
	self.HideHeldItem = true
	self.AnimationCount = 1
end

---こたつアニメーションを停止する。
function Kotatsu.stop(self)
	PermanentAnimationAction.stop(self)
	sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
	PhysicsClass.EnablePyhsics[1] = true
	CameraClass.CameraOffset = 0
	NameplateClass.NamePlateOffset = 0
	self.AnimationCount = 0
end

---アニメーション再生中に毎チック実行される関数
function Kotatsu.onAnimationTick(self)
	PermanentAnimationAction.onAnimationTick(self)
	if Kotatsu.AnimationCount == 282 then
		sounds:playSound("block.grass.step", player:getPos(), 1, 1)
	elseif Kotatsu.AnimationCount == 275 or Kotatsu.AnimationCount == 287 then
		sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
	elseif Kotatsu.AnimationCount == 300 then
		Kotatsu.AnimationCount = 1
	end
	FacePartsClass.setEmotion("CLOSED", "CLOSED", "CLOSED", 1, true)
	ActionWheelClass.ActionCount = 1
end

return Kotatsu