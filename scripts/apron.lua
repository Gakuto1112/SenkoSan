---@class ApronClass エプロンの挙動を制御するクラス
---@field ApronClass.IsVisible boolean エプロンが可視化状態かどうか

ApronClass = {}

ApronClass.IsVisible = true

events.TICK:register(function ()
	models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setVisible(ApronClass.IsVisible)
end)

events.RENDER:register(function ()
	if ApronClass.IsVisible and not General.isAnimationPlaying("models.main", "sit_down") then
		local apronBottom = models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom
		if player:getPose() == "CROUCHING" then
			apronBottom:setRot(math.max(vanilla_model.RIGHT_LEG:getOriginRot().x, vanilla_model.LEFT_LEG:getOriginRot().x) + 30, 0, 0)
			apronBottom:setPos(0, 4.5, 1.5)
			apronBottom:setPivot(0, 14.5, -2)
		else
			apronBottom:setRot(math.max(vanilla_model.RIGHT_LEG:getOriginRot().x, vanilla_model.LEFT_LEG:getOriginRot().x), 0, 0)
			apronBottom:setPos(0, 0, 0)
			apronBottom:setPivot(0, 13, -1)
		end
	end
end)

return ApronClass