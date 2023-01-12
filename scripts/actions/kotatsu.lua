---@class Kotatsu こたつアニメーションを制御するクラス
---@field Kotatsu.ActionCount integer アニメーションのタイミングを計るカウンター
---@field Kotatsu.BodyYawPrev integer 前チックの体のヨー
---@field Kotatsu.TickEvent function コンストラクタでtickイベントに登録される関数

Kotatsu = General.instance({
	AnimationCount = 0,
	BodyYawPrev = 0,

	onTickEvent = function (self)
		PermanentAnimationAction.onTickEvent(self)
		Kotatsu.BodyYawPrev = player:getBodyYaw()
	end,

	---こたつアニメーションを再生する。
	play = function (self)
		PermanentAnimationAction.play(self)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		if host:isHost() then
			print(Language.getTranslate("action_wheel__main_1__action_7__start"))
		end
		Physics.EnablePyhsics[1] = false
		Camera.CameraOffset = -1
		Nameplate.NamePlateOffset = -1
		Arms.hideHeldItem(true)
		self.AnimationCount = 1
	end,

	---こたつアニメーションを停止する。
	stop = function (self)
		PermanentAnimationAction.stop(self)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		Physics.EnablePyhsics[1] = true
		Camera.CameraOffset = 0
		Nameplate.NamePlateOffset = 0
		self.AnimationCount = 0
	end,

	---アニメーション再生中に毎チック実行される関数
	onAnimationTick = function (self)
		PermanentAnimationAction.onAnimationTick(self)
		if Kotatsu.AnimationCount == 282 then
			sounds:playSound("block.grass.step", player:getPos(), 1, 1)
		elseif Kotatsu.AnimationCount == 275 or Kotatsu.AnimationCount == 287 then
			sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
		elseif Kotatsu.AnimationCount == 300 then
			Kotatsu.AnimationCount = 1
		end
		FaceParts.setEmotion("CLOSED", "CLOSED", "CLOSED", 1, true)
		ActionWheel.ActionCount = 1
	end
}, PermanentAnimationAction, function ()
	return BroomCleaning:checkAction() and player:getBodyYaw() == Kotatsu.BodyYawPrev
end, models.models.kotatsu, models.models.kotatsu, animations["models.main"]["kotatsu"], nil)

return Kotatsu