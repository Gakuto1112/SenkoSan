---@class Sleeve 袖を操作するクラス
---@field Moving boolean 袖の動きが有効かどうか
---@field RightSleeveRotOffset Vector3 右袖の角度のオフセット
---@field LeftSleeveRotOffset Vector3 右袖の角度のオフセット
Sleeve = {
	Moving = true,
	RightSleeveRotOffset = vectors.vec3(),
	LeftSleeveRotOffset = vectors.vec3(),

	---袖を有効にする。
	enable = function ()
		for _, modelPart in ipairs({models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightSleeveBase, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftSleeveBase}) do
			modelPart:setVisible(true)
		end
		if events.RENDER:getRegisteredCount("sleeve_render") == 0 then
			events.RENDER:register(function (_, context)
				local armRot = {models.models.main.Avatar.UpperBody.Arms.RightArm:getTrueRot() + models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom:getTrueRot() + (models.models.main.Avatar.UpperBody.Arms.RightArm:getParentType() == "RightArm" and vanilla_model.RIGHT_ARM:getOriginRot() or vectors.vec3()), models.models.main.Avatar.UpperBody.Arms.LeftArm:getTrueRot() + models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom:getTrueRot() + (models.models.main.Avatar.UpperBody.Arms.LeftArm:getParentType() == "LeftArm" and vanilla_model.LEFT_ARM:getOriginRot() or vectors.vec3())}
				local sleeveRot = {vectors.vec3(), vectors.vec3()}
				if context ~= "FIRST_PERSON" and Sleeve.Moving then
					local playerPose = player:getPose()
					if playerPose == "FALL_FLYING" then
						sleeveRot = {vectors.vec3(math.clamp(90 - armRot[1].x, -80, 80)), vectors.vec3(math.clamp(90 - armRot[2].x, -80, 80))}
					elseif playerPose == "SWIMMING" then
						sleeveRot = {vectors.vec3(math.clamp(armRot[1].x >= 90 and -armRot[1].x + 180 or -armRot[1].x, -80, 80)), vectors.vec3(math.clamp(armRot[2].x >= 90 and -armRot[2].x + 180 or -armRot[2].x, -80, 80))}
					else
						local vehicle = player:getVehicle() ~= nil
						sleeveRot = {vectors.vec3(math.clamp(90 - armRot[1].x, -80, 80), vehicle and 20 or 0), vectors.vec3(math.clamp(90 - armRot[2].x, -80, 80), vehicle and -20 or 0)}
					end
				end
				models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightSleeveBase:setRot(sleeveRot[1]:add(Sleeve.RightSleeveRotOffset):copy():applyFunc(function (axis)
					return math.clamp(axis, -20, 20)
				end))
				models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftSleeveBase:setRot(sleeveRot[2]:add(Sleeve.LeftSleeveRotOffset):copy():applyFunc(function (axis)
					return math.clamp(axis, -20, 20)
				end))
				for index, sleeve in ipairs({models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightSleeveBase.RightSleeve, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftSleeveBase.LeftSleeve}) do
					sleeve:setRot(sleeveRot[index]:applyFunc(function (axis)
						if axis >= 0 then
							return math.max(axis - 20, 0)
						else
							return math.min(axis + 20, 0)
						end
					end))
				end
				if models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightSleeveBase:getTrueRot().x >= 0 then
					models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightSleeveBase:setPivot(5.5, 19, 2)
				else
					models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightSleeveBase:setPivot(5.5, 14, 2)
				end
				if models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightSleeveBase.RightSleeve:getTrueRot().x >= 0 then
					models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightSleeveBase.RightSleeve:setPivot(5.5, 19, 4)
				else
					models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightSleeveBase.RightSleeve:setPivot(5.5, 14, 4)
				end
				if models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftSleeveBase:getTrueRot().x >= 0 then
					models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftSleeveBase:setPivot(-5.5, 19, 2)
				else
					models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftSleeveBase:setPivot(-5.5, 14, 2)
				end
				if models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftSleeveBase.LeftSleeve:getTrueRot().x >= 0 then
					models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftSleeveBase.LeftSleeve:setPivot(-5.5, 19, 4)
				else
					models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftSleeveBase.LeftSleeve:setPivot(-5.5, 14, 4)
				end
			end, "sleeve_render")
		end
	end,

	---袖を無効にする。
	disable = function ()
		for _, modelPart in ipairs({models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightSleeveBase, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftSleeveBase}) do
			modelPart:setVisible(false)
		end
		events.RENDER:remove("sleeve_render")
	end
}

return Sleeve