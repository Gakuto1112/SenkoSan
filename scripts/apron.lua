---@class Apron エプロンの挙動を制御するクラス
---@field Apron.RotOffset Vector3 エプロンの角度のオフセット

Apron = {
	RotOffset = vectors.vec3(),

	---エプロンを有効にする。
	enable = function ()
		models.models.main.Avatar.Body.BodyBottom.Legs.Apron:setVisible(true)
		events.RENDER:remove("apron_render")
		events.RENDER:register(function ()
			if not SitDown.IsAnimationPlaying then
				if player:isCrouching() then
					local legsYRot = math.rad(models.models.main.Avatar.Body.BodyBottom.Legs:getTrueRot().y)
					models.models.main.Avatar.Body.BodyBottom.Legs.Apron:setRot(vectors.vec3(math.max(vanilla_model.RIGHT_LEG:getOriginRot().x, vanilla_model.LEFT_LEG:getOriginRot().x) + 30 * math.cos(legsYRot), 0, 30 * math.sin(legsYRot)) + Apron.RotOffset)
					models.models.main.Avatar.Body.BodyBottom.Legs.Apron:setPos(-legsYRot * 1.2, 4.5, -math.abs(legsYRot) * 0.6 + 1.4)
					models.models.main.Avatar.Body.BodyBottom.Legs.Apron:setPivot(0, 14.5, -2)
				else
					models.models.main.Avatar.Body.BodyBottom.Legs.Apron:setRot(vectors.vec3(math.max(vanilla_model.RIGHT_LEG:getOriginRot().x, vanilla_model.LEFT_LEG:getOriginRot().x)) + Apron.RotOffset)
					models.models.main.Avatar.Body.BodyBottom.Legs.Apron:setPos()
					models.models.main.Avatar.Body.BodyBottom.Legs.Apron:setPivot(0, 13, -1)
				end
			end
		end, "apron_render")
	end,

	---エプロンを無効にする。
	disable = function ()
		models.models.main.Avatar.Body.BodyBottom.Legs.Apron:setVisible(false)
		events.RENDER:remove("apron_render")
	end
}

return Apron