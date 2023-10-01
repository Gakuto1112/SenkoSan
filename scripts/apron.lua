---@class Apron エプロンの挙動を制御するクラス
---@field RotOffset Vector3 エプロンの角度のオフセット
Apron = {
	RotOffset = vectors.vec3(),

	---エプロンを有効にする。
	enable = function ()
		models.models.main.Avatar.LowerBody.Apron:setVisible(true)
		if events.RENDER:getRegisteredCount("apron_render") == 0 then
			events.RENDER:register(function ()
				local leftLegRot = vanilla_model.LEFT_LEG:getOriginRot().x
				models.models.main.Avatar.LowerBody.Apron:setRot(vectors.vec3(leftLegRot > 0 and leftLegRot * 2 or 0, 0.28647) + Apron.RotOffset)
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