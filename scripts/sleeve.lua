---@class Sleeve 袖を操作するクラス
---@field Sleeve.Moving boolean 袖の動きが有効かどうか

Sleeve = {
	Moving = true,

	---袖を有効にする。
	enable = function ()
		for _, modelPart in ipairs({models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase}) do
			modelPart:setVisible(true)
		end
		events.RENDER:remove("sleeve_render")
		events.RENDER:register(function ()
			local sleeveRot = {vectors.vec3(), vectors.vec3()}
			local rotLimit = {{{-20, 20}, {-20, 20}}, {{-60, 60}, {-70, 70}}} --袖の可動範囲：1. 袖ベース：{1-1. 前後方向, 1-2. 左右方向}, 2. 袖：{2-1. 前後方向, 2-2. 左右方向}
			if not renderer:isFirstPerson() and Sleeve.Moving then
				local playerPose = player:getPose()
				if playerPose == "FALL_FLYING" then
					sleeveRot = {vectors.vec3(math.clamp(90 - vanilla_model.RIGHT_ARM:getOriginRot().x, rotLimit[1][1][1] + rotLimit[1][2][1], rotLimit[1][1][2] + rotLimit[3][1][2])), vectors.vec3(math.clamp(90 - vanilla_model.LEFT_ARM:getOriginRot().x, rotLimit[1][1][1] + rotLimit[2][1][1], rotLimit[1][1][2] + rotLimit[2][1][2]))}
				elseif playerPose == "SWIMMING" then
					local rightOriginArmRot = vanilla_model.RIGHT_ARM:getOriginRot()
					local leftOriginArmRot = vanilla_model.LEFT_ARM:getOriginRot()
					sleeveRot = {vectors.vec3(math.clamp(rightOriginArmRot.x >= 90 and -rightOriginArmRot.x + 180 or -rightOriginArmRot.x, rotLimit[1][1][1] + rotLimit[2][1][1], rotLimit[1][1][2] + rotLimit[2][1][2])), vectors.vec3(math.clamp(leftOriginArmRot.x >= 90 and -leftOriginArmRot.x + 180 or -leftOriginArmRot.x, rotLimit[1][1][1] + rotLimit[2][1][1], rotLimit[1][1][2] + rotLimit[2][1][2]))}
				else
					local leftHanded = player:isLeftHanded()
					local vehicle = player:getVehicle()
					sleeveRot = {vectors.vec3(math.clamp((Umbrella.IsUsing and leftHanded) and 70 or (90 - vanilla_model.RIGHT_ARM:getOriginRot().x), rotLimit[1][1][1] + rotLimit[2][1][1], rotLimit[1][1][2] + rotLimit[2][1][2]), vehicle and 20 or 0), vectors.vec3(math.clamp((Umbrella.IsUsing and not leftHanded) and 70 or (90 - vanilla_model.LEFT_ARM:getOriginRot().x), rotLimit[1][1][1] + rotLimit[2][1][1], rotLimit[1][1][2] + rotLimit[2][1][2]), vehicle and -20 or 0)}
				end
			end
			for index, sleeveBase in ipairs({models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase}) do
				sleeveBase:setRot(sleeveRot[index]:copy():applyFunc(function (element, vectorIndex)
					return vectorIndex <= 2 and math.clamp(element, rotLimit[1][vectorIndex][1], rotLimit[1][vectorIndex][2]) or element
				end))
			end
			for index, sleeve in ipairs({models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase.RightSleeve, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase.LeftSleeve}) do
				sleeve:setRot(sleeveRot[index]:applyFunc(function (element, vectorIndex)
					if vectorIndex <= 2 then
						if element >= 0 then
							return math.max(element + rotLimit[1][vectorIndex][1], 0)
						else
							return math.min(element + rotLimit[1][vectorIndex][2], 0)
						end
					else
						return element
					end
				end))
			end
			if models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase:getRot().x + models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase:getAnimRot().x >= 0 then
				models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase:setPivot(5.5, 19, 2)
				models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase.RightSleeve:setPivot(5.5, 19, 4)
			else
				models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase:setPivot(5.5, 14, 2)
				models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase.RightSleeve:setPivot(5.5, 14, 4)
			end
			if models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase:getRot().x + models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase:getAnimRot().x >= 0 then
				models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase:setPivot(-5.5, 19, 2)
				models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase.LeftSleeve:setPivot(-5.5, 19, 4)
			else
				models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase:setPivot(-5.5, 14, 2)
				models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase.LeftSleeve:setPivot(-5.5, 14, 4)
			end
		end, "sleeve_render")
	end,

	---袖を無効にする。
	disable = function ()
		for _, modelPart in ipairs({models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase}) do
			modelPart:setVisible(false)
		end
		events.RENDER:remove("sleeve_render")
	end
}

return Sleeve