---@class CostumeClass キャラクターのコスチュームを管理し、円滑に切り替えられるようにするクラス
---@field CostumeClass.CurrentCostume CostumeType 現在のコスチューム
---@field CostumeClass.CostumeList table 利用可能なコスチュームのリスト

CostumeClass = {}
CostumeClass.CurrentCostume = "DEFAULT"
CostumeClass.CostumeList = {"default", "disguise"}

---@alias CostumeType
---| "DEFAULT"
---| "NIGHTWEAR"
---| "DISGUISE"

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
	end
end

---コスチュームをリセットし、デフォルトのコスチュームにする。
function CostumeClass.resetCostume()
	for _, modelPart in ipairs({models.models.main.Avatar.Body.Body, models.models.main.Avatar.Body.BodyLayer, models.models.main.Avatar.Body.BodyBottom.BodyBottom, models.models.main.Avatar.Body.BodyBottom.BodyBottomLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArm, models.models.main.Avatar.Body.Arms.RightArm.RightArmLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottom, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottomLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArm, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeg, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeg, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottomLayer}) do
		modelPart:setUVPixels(0, 0)
	end
	models.models.costume_disguise:setVisible(false)
	models.models.main.Avatar.Head.Ears:setVisible(true)
	TailClass.EnablePyhsics = true
	CostumeClass.CurrentCostume = "DEFAULT"
end

events.TICK:register(function ()
	models.models.costume_disguise.Avatar.Head.Hat:setVisible(CostumeClass.CurrentCostume == "DISGUISE" and (ConfigClass.HideArmor or not string.find(General.hasItem(player:getItem(6)), "helmet$")))
end)

models.models.costume_disguise:setVisible(false)
for _, modelPart in ipairs({models.models.costume_disguise.Avatar.Body.BodyBottom, models.models.costume_disguise.Avatar.Body.Arms.RightArm.RightArmBottom, models.models.costume_disguise.Avatar.Body.Arms.LeftArm.LeftArmBottom}) do
	modelPart:setParentType("None")
end

if ConfigClass.DefaultCostume > 1 then
	CostumeClass.setCostume(string.upper(CostumeClass.CostumeList[ConfigClass.DefaultCostume]))
end

return CostumeClass