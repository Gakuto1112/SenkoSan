---@class VanillaModel バニラーのモデルの処理クラス

for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ARMOR}) do
	vanillaModel:setVisible(false)
end
for _, modelPart in ipairs({models.models.main.Avatar.Torso.Body.BodyBottom, models.models.main.Avatar.Torso.Body.BodyBottom.Legs.RightLeg.RightLegBottom, models.models.main.Avatar.Torso.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom, models.models.main.Avatar.Torso.Arms.RightArm.RightArmBottom, models.models.main.Avatar.Torso.Arms.LeftArm.LeftArmBottom}) do
	modelPart:setParentType("None")
end