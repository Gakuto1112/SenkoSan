---@class Sleeve 袖を操作するクラス

events.TICK:register(function ()
	local sleeveVisible = (Costume.CurrentCostume == "NIGHTWEAR" or Costume.CurrentCostume == "MAID_B" or Costume.CurrentCostume == "PURIFICATION" or Costume.CurrentCostume == "YUKATA" or Costume.CurrentCostume == "PARTNER") and not Kotatsu.IsAnimationPlaying and (not renderer:isFirstPerson() or player:getPose() ~= "SLEEPING")
	for _, modelPart in ipairs({models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase}) do
		modelPart:setVisible(sleeveVisible)
	end
	local sleeveRibbonVisible = Costume.CurrentCostume == "PARTNER"
	for _, modelPart in ipairs({models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase.RightSleeve.RightSleeveRibbon, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase.LeftSleeve.LeftSleeveRibbon}) do
		modelPart:setVisible(sleeveVisible and sleeveRibbonVisible)
	end
end)

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