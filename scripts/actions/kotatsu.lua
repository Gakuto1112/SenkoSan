---@class Kotatsu こたつアニメーションを制御するクラス
---@field ActionCount integer アニメーションのタイミングを計るカウンター
---@field BodyYawPrev integer 前チックの体のヨー
Kotatsu = General.instance({
	AnimationCount = 0,
	BodyYawPrev = 0,

	---コンストラクタでtickイベントに登録される関数
	onTickEvent = function (self)
		PermanentAnimationAction.onTickEvent(self)
		Kotatsu.BodyYawPrev = player:getBodyYaw()
	end,

	---こたつアニメーションを再生する。
	play = function (self)
		PermanentAnimationAction.play(self)
		for _, modelPart in ipairs({models.models.main.Avatar.UpperBody.Body.CMaidAB, models.models.main.Avatar.UpperBody.Body.CMaidBB, models.models.main.Avatar.UpperBody.Body.CMiniSkirtB}) do
			modelPart:setVisible(false)
		end
		if SitDown.IsAnimationPlaying then
			SitDown:stop()
		end
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		if host:isHost() and General.ShowMessage then
			print(Language.getTranslate("action_wheel__main_1__action_7__start"))
		end
		Physics.EnablePyhsics[1] = false
		Camera.CameraOffset = -1
		Nameplate.NamePlateOffset = -1
		Arms.hideHeldItem(true)
		ActionWheel.setKotatsuToggle(true)
		self.AnimationCount = 1
	end,

	---こたつアニメーションを停止する。
	stop = function (self)
		PermanentAnimationAction.stop(self)
		sounds:playSound("entity.item.pickup", player:getPos(), 1, 0.5)
		if not Armor.ArmorVisible[3] then
			if Costume.CurrentCostume == "MAID_A" then

				models.models.main.Avatar.UpperBody.Body.CMaidAB:setVisible(true)
			elseif Costume.CurrentCostume == "MAID_B" then
				models.models.main.Avatar.UpperBody.Body.CMaidBB:setVisible(true)
			elseif Costume.CurrentCostume == "CHEERLEADER" or Costume.CurrentCostume == "SAILOR" or Costume.CurrentCostume == "HALLOWEEN" then
				models.models.main.Avatar.UpperBody.Body.CMiniSkirtB:setVisible(true)
			end
		end
		Physics.EnablePyhsics[1] = true
		Camera.CameraOffset = 0
		Nameplate.NamePlateOffset = 0
		ActionWheel.setKotatsuToggle(false)
		self.AnimationCount = 0
	end,

	---アニメーション再生中に毎チック実行される関数
	onAnimationTick = function (self)
		PermanentAnimationAction.onAnimationTick(self)
		if self.AnimationCount == 282 then
			sounds:playSound("block.grass.step", player:getPos(), 1, 1)
		elseif self.AnimationCount == 275 or self.AnimationCount == 287 then
			sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
		elseif self.AnimationCount == 300 then
			self.AnimationCount = 1
		end
		FaceParts.setEmotion("CLOSED", "CLOSED", "CLOSED", 1, true)
		ActionWheel.ActionCount = 1
	end
}, PermanentAnimationAction, function ()
	local isNotPlayerYawChanged = player:getBodyYaw() == Kotatsu.BodyYawPrev
	Kotatsu.BodyYawPrev = player:getBodyYaw()
	return SitDown:checkAction() and isNotPlayerYawChanged and not player:isUsingItem()
end, models.models.kotatsu, models.models.kotatsu, animations["models.main"]["kotatsu"], nil)

models.models.kotatsu.Carpet:setPrimaryTexture("RESOURCE", "textures/block/brown_wool.png")
models.models.kotatsu.Cover.Cover3:setPrimaryTexture("RESOURCE", "textures/block/white_wool.png")
for _, modelPart in ipairs({models.models.kotatsu.Cover.Cover1, models.models.kotatsu.Cover.Cover2}) do
	modelPart:setPrimaryTexture("RESOURCE", "textures/block/lime_wool.png")
end
models.models.kotatsu.Cover:setPrimaryTexture("RESOURCE", "textures/block/lime_wool.png")
models.models.kotatsu.Board:setPrimaryTexture("RESOURCE", "textures/block/spruce_planks.png")

return Kotatsu