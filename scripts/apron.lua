---@class Apron エプロンの挙動を制御するクラス

Apron = {
	---エプロンを有効にする。
	enable = function ()
		models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setVisible(true)
		events.RENDER:remove("apron_render")
		events.RENDER:register(function ()
			if not SitDown.IsAnimationPlaying then
				if player:isCrouching() then
					models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setRot(math.max(vanilla_model.RIGHT_LEG:getOriginRot().x, vanilla_model.LEFT_LEG:getOriginRot().x) + 30, 0, 0)
					models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setPos(0, 4.5, 1.5)
					models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setPivot(0, 14.5, -2)
				else
					models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setRot(math.max(vanilla_model.RIGHT_LEG:getOriginRot().x, vanilla_model.LEFT_LEG:getOriginRot().x), 0, 0)
					models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setPos(0, 0, 0)
					models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setPivot(0, 13, -1)
				end
			end
		end, "apron_render")
	end,

	---エプロンを無効にする。
	disable = function ()
		models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setVisible(false)
		events.RENDER:remove("apron_render")
	end
}

return Apron