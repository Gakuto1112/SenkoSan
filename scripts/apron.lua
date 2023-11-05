---@class Apron エプロンの挙動を制御するクラス
---@field RotOffset Vector3 エプロンの角度のオフセット
Apron = {
	RotOffset = vectors.vec3(),

	---エプロンを有効にする。
	enable = function ()
		models.models.main.Avatar.LowerBody.Apron:setVisible(true)
		if events.RENDER:getRegisteredCount("apron_render") == 0 then
			events.RENDER:register(function ()
				local rightLegLot = vanilla_model.RIGHT_LEG:getOriginRot()
				models.models.main.Avatar.LowerBody.Apron:setRot(vectors.vec3(math.max(vanilla_model.LEFT_LEG:getOriginRot().x - rightLegLot.x, 0), -rightLegLot.y, -rightLegLot.z) + Apron.RotOffset)
			end, "apron_render")
		end
	end,

	---エプロンを無効にする。
	disable = function ()
		models.models.main.Avatar.LowerBody.Apron:setVisible(false)
		events.RENDER:remove("apron_render")
	end
}

return Apron