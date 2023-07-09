---@class Apron エプロンの挙動を制御するクラス
---@field RotOffset Vector3 エプロンの角度のオフセット
Apron = {
	RotOffset = vectors.vec3(),

	---エプロンを有効にする。
	enable = function ()
		models.models.main.Avatar.LowerBody.BodyBottomPivot.Apron:setVisible(true)
		events.RENDER:remove("apron_render")
		events.RENDER:register(function ()
			local leftLegRot = vanilla_model.LEFT_LEG:getOriginRot().x
			models.models.main.Avatar.LowerBody.BodyBottomPivot.Apron:setRot(vectors.vec3(leftLegRot > 0 and leftLegRot * 2 or 0, 0.28647) + Apron.RotOffset)
		end, "apron_render")
	end,

	---エプロンを無効にする。
	disable = function ()
		models.models.main.Avatar.LowerBody.BodyBottomPivot.Apron:setVisible(false)
		events.RENDER:remove("apron_render")
	end
}

return Apron