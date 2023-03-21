---@class VanillaModel バニラーのモデルの処理クラス

for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ARMOR}) do
	vanillaModel:setVisible(false)
end
for _, modelPart in ipairs({models.models.main.Avatar.Body.BodyBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom}) do
	modelPart:setParentType("None")
end