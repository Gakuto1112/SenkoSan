---@class Hem 裾の挙動を制御するクラス
---@field RotOffset Vector3 裾の角度のオフセット
Hem = {
	RotOffset = vectors.vec3(),

	---エプロンを有効にする。
	enable = function ()
		models.models.main.Avatar.UpperBody.Body.Hem:setVisible(true)
		if events.RENDER:getRegisteredCount("hem_render") == 0 then
			events.RENDER:register(function ()
				if player:isCrouching() then
					models.models.main.Avatar.UpperBody.Body.Hem:setRot(vectors.vec3(math.min(vanilla_model.RIGHT_LEG:getOriginRot().x, vanilla_model.LEFT_LEG:getOriginRot().x) + 30) + Hem.RotOffset)
					models.models.main.Avatar.UpperBody.Body.Hem:offsetPivot(0, -1, 1)
				else
					models.models.main.Avatar.UpperBody.Body.Hem:setRot(vectors.vec3(math.min(vanilla_model.RIGHT_LEG:getOriginRot().x, vanilla_model.LEFT_LEG:getOriginRot().x)) + Hem.RotOffset)
					models.models.main.Avatar.UpperBody.Body.Hem:offsetPivot()
				end
			end, "hem_render")
		end
	end,

	---裾を無効にする。
	disable = function ()
		models.models.main.Avatar.UpperBody.Body.Hem:setVisible(false)
		events.RENDER:remove("hem_render")
	end
}

Hem.enable()

return Hem