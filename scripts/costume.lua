---@class CostumeClass キャラクターのコスチュームを管理し、円滑に切り替えられるようにするクラス
---@field CostumeClass.CurrentCostume CostumeType 現在のコスチューム
---@field CostumeClass.CostumeList table 利用可能なコスチュームのリスト

CostumeClass = {}
CostumeClass.CurrentCostume = "DEFAULT"
CostumeClass.CostumeList = {"default", "disguise", "maid_a", "maid_b"}

---@alias CostumeType
---| "DEFAULT"
---| "NIGHTWEAR"
---| "DISGUISE"
---| "MAID_A"
---| "MAID_B"

---コスチュームを設定する。
---@param costume CostumeType 設定するコスチューム
function CostumeClass.setCostume(costume)
	CostumeClass.resetCostume()
	CostumeClass.CurrentCostume = costume
	if costume == "NIGHTWEAR" then
		for _, modelPart in ipairs({models.models.main.Avatar.Body.Body, models.models.main.Avatar.Body.BodyLayer, models.models.main.Avatar.Body.BodyBottom.BodyBottom, models.models.main.Avatar.Body.BodyBottom.BodyBottomLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArm, models.models.main.Avatar.Body.Arms.RightArm.RightArmLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottom, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottomLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArm, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeg, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeg, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottomLayer}) do
			modelPart:setUVPixels(0, 48)
		end
		TailClass.EnablePyhsics = false
	elseif costume == "DISGUISE" then
		models.models.costume_disguise:setVisible(true)
		models.models.main.Avatar.Head.Ears:setVisible(false)
	elseif costume == "MAID_A" then
		for _, modelPart in ipairs({models.models.main.Avatar.Body.Body, models.models.main.Avatar.Body.BodyLayer, models.models.main.Avatar.Body.BodyBottom.BodyBottom, models.models.main.Avatar.Body.BodyBottom.BodyBottomLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArm, models.models.main.Avatar.Body.Arms.RightArm.RightArmLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottom, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottomLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArm, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeg, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeg, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottomLayer}) do
			modelPart:setUVPixels(0, 96)
		end
		models.models.costume_maid_a:setVisible(true)
	elseif costume == "MAID_B" then
		for _, modelPart in ipairs({models.models.main.Avatar.Body.Body, models.models.main.Avatar.Body.BodyLayer, models.models.main.Avatar.Body.BodyBottom.BodyBottom, models.models.main.Avatar.Body.BodyBottom.BodyBottomLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArm, models.models.main.Avatar.Body.Arms.RightArm.RightArmLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottom, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottomLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArm, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeg, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeg, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottomLayer}) do
			modelPart:setUVPixels(0, 144)
		end
		models.models.costume_maid_b:setVisible(true)
	end
end

---コスチュームをリセットし、デフォルトのコスチュームにする。
function CostumeClass.resetCostume()
	for _, modelPart in ipairs({models.models.main.Avatar.Body.Body, models.models.main.Avatar.Body.BodyLayer, models.models.main.Avatar.Body.BodyBottom.BodyBottom, models.models.main.Avatar.Body.BodyBottom.BodyBottomLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArm, models.models.main.Avatar.Body.Arms.RightArm.RightArmLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottom, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottomLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArm, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeg, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeg, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottomLayer}) do
		modelPart:setUVPixels(0, 0)
	end
	for _, modelPart in ipairs({models.models.costume_disguise, models.models.costume_maid_a, models.models.costume_maid_b}) do
		modelPart:setVisible(false)
	end
	models.models.main.Avatar.Head.Ears:setVisible(true)
	TailClass.EnablePyhsics = true
	CostumeClass.CurrentCostume = "DEFAULT"
end

events.TICK:register(function ()
	models.models.costume_disguise.Avatar.Head.Hat:setVisible(CostumeClass.CurrentCostume == "DISGUISE" and not ArmorClass.ArmorVisible[1])
	if CostumeClass.CurrentCostume == "MAID_A" then
		models.models.costume_maid_a.Avatar.Body.BodyBottom.Skirt:setRot(player:getPose() == "CROUCHING" and 27.5 or 0, 0, 0)
		models.models.costume_maid_a.Avatar.Head:setVisible(not ArmorClass.ArmorVisible[1])
		models.models.costume_maid_a.Avatar.Body:setVisible(not ArmorClass.ArmorVisible[3])
	else
		for _, modelsPart in ipairs({models.models.costume_maid_a.Avatar.Head, models.models.costume_maid_a.Avatar.Body}) do
			modelsPart:setVisible(false)
		end
	end
	if CostumeClass.CurrentCostume == "MAID_B" then
		models.models.costume_maid_b.Avatar.Body.BodyBottom.Skirt:setRot(player:getPose() == "CROUCHING" and 27.5 or 0, 0, 0)
		models.models.costume_maid_b.Avatar.Head:setVisible(not ArmorClass.ArmorVisible[1])
		models.models.costume_maid_b.Avatar.Body:setVisible(not ArmorClass.ArmorVisible[3])
	else
		for _, modelsPart in ipairs({models.models.costume_maid_b.Avatar.Head, models.models.costume_maid_b.Avatar.Body}) do
			modelsPart:setVisible(false)
		end
	end
end)

for _, modelPart in ipairs({models.models.costume_disguise, models.models.costume_maid_a, models.models.costume_maid_b}) do
	modelPart:setVisible(false)
end
for _, modelPart in ipairs({models.models.costume_disguise.Avatar.Body.BodyBottom, models.models.costume_disguise.Avatar.Body.Arms.RightArm.RightArmBottom, models.models.costume_disguise.Avatar.Body.Arms.LeftArm.LeftArmBottom, models.models.costume_maid_a.Avatar.Body.BodyBottom, models.models.costume_maid_b.Avatar.Body.BodyBottom}) do
	modelPart:setParentType("None")
end

if ConfigClass.DefaultCostume > 1 then
	CostumeClass.setCostume(string.upper(CostumeClass.CostumeList[ConfigClass.DefaultCostume]))
end

return CostumeClass