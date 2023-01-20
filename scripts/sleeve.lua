---@class Sleeve 袖を操作するクラス
events.RENDER:register(function ()
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
end)