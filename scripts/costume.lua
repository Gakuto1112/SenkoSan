---@class CostumeClass キャラクターのコスチュームを管理し、円滑に切り替えられるようにするクラス
---@field CostumeClass.CostumeList table 利用可能なコスチュームのリスト
---@field CostumeClass.CurrentCostume CostumeType 現在のコスチューム

CostumeClass = {}
CostumeClass.CostumeList = {"default", "nightwear", "disguise", "maid_a", "maid_b", "swimsuit", "cheerleader", "purification", "kappogi"}
CostumeClass.CurrentCostume = string.upper(CostumeClass.CostumeList[ConfigClass.loadConfig("costume", 1)])

---@alias CostumeType
---| "DEFAULT"
---| "NIGHTWEAR"
---| "DISGUISE"
---| "MAID_A"
---| "MAID_B"
---| "SWIMSUIT"
---| "CHEERLEADER"
---| "PURIFICATION"
---| "KAPPOGI"

---メインモデルのテクスチャのオフセット値を設定する。
---@param offset integer オフセット値
function setCostumeTextureOffset(offset)
	for _, modelPart in ipairs({models.models.main.Avatar.Body.Body, models.models.main.Avatar.Body.BodyLayer, models.models.main.Avatar.Body.BodyBottom.BodyBottom, models.models.main.Avatar.Body.BodyBottom.BodyBottomLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArm, models.models.main.Avatar.Body.Arms.RightArm.RightArmLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottom, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottomLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArm, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeg, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeg, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottomLayer}) do
		modelPart:setUVPixels(0, offset)
	end
end

---コスチュームを設定する。
---@param costume CostumeType 設定するコスチューム
function CostumeClass.setCostume(costume)
	CostumeClass.resetCostume()
	CostumeClass.CurrentCostume = costume
	if costume == "NIGHTWEAR" then
		setCostumeTextureOffset(48)
		ApronClass.IsVisible = false
	elseif costume == "DISGUISE" then
		models.models.costume_disguise:setVisible(true)
		setCostumeTextureOffset(96)
		models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setUVPixels(0, 8)
	elseif costume == "MAID_A" then
		setCostumeTextureOffset(144)
		models.models.costume_maid_a:setVisible(true)
		ApronClass.IsVisible = false
		LegsClass.ReducedLegSwing = true
	elseif costume == "MAID_B" then
		setCostumeTextureOffset(192)
		models.models.costume_maid_b:setVisible(true)
		ApronClass.IsVisible = false
		LegsClass.ReducedLegSwing = true
	elseif costume == "SWIMSUIT" then
		setCostumeTextureOffset(240)
		models.models.costume_swimsuit:setVisible(true)
		ApronClass.IsVisible = false
	elseif costume == "CHEERLEADER" then
		setCostumeTextureOffset(288)
		models.models.costume_cheerleader:setVisible(true)
		ApronClass.IsVisible = false
	elseif costume == "PURIFICATION" then
		setCostumeTextureOffset(336)
		ApronClass.IsVisible = false
	elseif costume == "KAPPOGI" then
		setCostumeTextureOffset(384)
		models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setUVPixels(0, 16)
	end
end

---コスチュームをリセットし、デフォルトのコスチュームにする。
function CostumeClass.resetCostume()
	setCostumeTextureOffset(0)
	for _, modelPart in ipairs({models.models.costume_disguise, models.models.costume_maid_a, models.models.costume_maid_b, models.models.costume_swimsuit, models.models.costume_cheerleader}) do
		modelPart:setVisible(false)
	end
	ApronClass.IsVisible = true
	LegsClass.ReducedLegSwing = false
	models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setUVPixels(0, 0)
	CostumeClass.CurrentCostume = "DEFAULT"
end

events.TICK:register(function ()
	local hat = models.models.costume_disguise.Avatar.Head.Hat
	local ears = models.models.main.Avatar.Head.Ears
	if CostumeClass.CurrentCostume == "DISGUISE" then
		if ArmorClass.ArmorVisible[1] then
			hat:setVisible(false)
			ears:setVisible(true)
			EarsClass.EnableJerkEar = true
		else
			hat:setVisible(true)
			ears:setVisible(false)
			EarsClass.EnableJerkEar = false
		end
		local bodyBottom = models.models.costume_disguise.Avatar.Body.BodyBottom
		if player:getPose() == "CROUCHING" then
			bodyBottom:setPos(0, 4, 0)
			bodyBottom:setRot(30, 0, 0)
		else
			bodyBottom:setPos(0, 0, 0)
			bodyBottom:setRot(0, 0, 0)
		end
	else
		hat:setVisible(false)
		ears:setVisible(true)
		EarsClass.EnableJerkEar = true
	end
	if CostumeClass.CurrentCostume == "MAID_A" then
		local skirt = models.models.costume_maid_a.Avatar.Body.BodyBottom.Skirt
		skirt:setRot(player:getPose() == "CROUCHING" and 27.5 or 0, 0, 0)
		models.models.costume_maid_a.Avatar.Head:setVisible(not ArmorClass.ArmorVisible[1])
		models.models.costume_maid_a.Avatar.Body:setVisible(not ArmorClass.ArmorVisible[3])
		if player:getVehicle() then
			if ArmorClass.ArmorVisible[3] then
				models.models.main.Avatar.Body.BodyBottom.Legs:setVisible(true)
			else
				models.models.main.Avatar.Body.BodyBottom.Legs:setVisible(false)
				skirt.Skirt2:setPos(0, 0.75, 0)
				skirt.Skirt2:setScale(1.05, 1, 1.05)
				skirt.Skirt2.Skirt3:setPos(0, 0.75, 0)
				skirt.Skirt2.Skirt3:setScale(1.05, 1, 1.05)
				skirt.Skirt2.Skirt3.Skirt4:setPos(0, 1.5, 0)
				skirt.Skirt2.Skirt3.Skirt4:setScale(1.05, 1, 1.05)
				skirt.Skirt2.Skirt3.Skirt4.Skirt5:setPos(0, 2.5, 0)
				skirt.Skirt2.Skirt3.Skirt4.Skirt5:setScale(1.05, 1, 1.05)
				skirt.Skirt2.Skirt3.Skirt4.Skirt5.Skirt6:setPos(0, 2.5, 0)
				skirt.Skirt2.Skirt3.Skirt4.Skirt5.Skirt6:setScale(1.05, 1, 1.05)
			end
		else
			models.models.main.Avatar.Body.BodyBottom.Legs:setVisible(true)
			skirt.Skirt2:setPos(0, 0, 0)
			skirt.Skirt2.Skirt3:setPos(0, 0, 0)
			skirt.Skirt2.Skirt3.Skirt4:setPos(0, 0, 0)
			skirt.Skirt2.Skirt3.Skirt4.Skirt5:setPos(0, 0, 0)
			skirt.Skirt2.Skirt3.Skirt4.Skirt5.Skirt6:setPos(0, 0, 0)
		end
	else
		for _, modelsPart in ipairs({models.models.costume_maid_a.Avatar.Head, models.models.costume_maid_a.Avatar.Body}) do
			modelsPart:setVisible(false)
		end
	end
	if CostumeClass.CurrentCostume == "MAID_B" then
		local skirt = models.models.costume_maid_b.Avatar.Body.BodyBottom.Skirt
		skirt:setRot(player:getPose() == "CROUCHING" and 27.5 or 0, 0, 0)
		models.models.costume_maid_b.Avatar.Head:setVisible(not ArmorClass.ArmorVisible[1])
		models.models.costume_maid_b.Avatar.Body:setVisible(not ArmorClass.ArmorVisible[3])
		if player:getVehicle() then
			if ArmorClass.ArmorVisible[3] then
				models.models.main.Avatar.Body.BodyBottom.Legs:setVisible(true)
			else
				models.models.main.Avatar.Body.BodyBottom.Legs:setVisible(false)
				skirt.Skirt2:setPos(0, 2.5, 0)
				skirt.Skirt2:setScale(1.05, 1, 1.2)
				skirt.Skirt2.Skirt3:setPos(0, 2.5, 0)
				skirt.Skirt2.Skirt3:setScale(1.05, 1, 1.2)
				skirt.Skirt2.Skirt3.Skirt4:setPos(0, 2.5, 0)
				skirt.Skirt2.Skirt3.Skirt4:setScale(1.05, 1, 1.2)
			end
		else
			models.models.main.Avatar.Body.BodyBottom.Legs:setVisible(true)
			skirt.Skirt2:setPos(0, 0, 0)
			skirt.Skirt2.Skirt3:setPos(0, 0, 0)
			skirt.Skirt2.Skirt3.Skirt4:setPos(0, 0, 0)
		end
	else
		for _, modelsPart in ipairs({models.models.costume_maid_b.Avatar.Head, models.models.costume_maid_b.Avatar.Body}) do
			modelsPart:setVisible(false)
		end
	end
	if CostumeClass.CurrentCostume == "SWIMSUIT" then
		models.models.costume_swimsuit.Avatar.Body.BodyBottom.Swimsuit:setRot(player:getPose() == "CROUCHING" and 27.5 or 0, 0, 0)
		models.models.costume_swimsuit.Avatar.Head:setVisible(string.find(player:getItem(6).id, "^minecraft:.+_helmet$") ~= nil and not ArmorClass.ArmorVisible[1])
		models.models.costume_swimsuit.Avatar.Body:setVisible(not ArmorClass.ArmorVisible[3])
	else
		for _, modelsPart in ipairs({models.models.costume_swimsuit.Avatar.Head, models.models.costume_swimsuit.Avatar.Body}) do
			modelsPart:setVisible(false)
		end
	end
	if CostumeClass.CurrentCostume == "CHEERLEADER" then
		models.models.costume_cheerleader.Avatar.Body.BodyBottom.Skirt:setRot(player:getPose() == "CROUCHING" and 27.5 or 0, 0, 0)
		models.models.costume_cheerleader.Avatar.Body.BodyBottom.Skirt:setVisible(not ArmorClass.ArmorVisible[3])
		local rightPonPon = models.models.costume_cheerleader.Avatar.Body.Arms.RightArm.RightArmBottom.RightPonPon
		local leftPonPon = models.models.costume_cheerleader.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftPonPon
		if ActionWheelClass.ActionCount == 0 then
			local leftHanded = player:isLeftHanded()
			rightPonPon:setVisible(player:getHeldItem(leftHanded).id == "minecraft:air" and (not UmbrellaClass.EnableUmbrella or not leftHanded))
			leftPonPon:setVisible(player:getHeldItem(not leftHanded).id == "minecraft:air" and (not UmbrellaClass.EnableUmbrella or leftHanded))
		else
			for _, modelPart in ipairs({rightPonPon, leftPonPon}) do
				modelPart:setVisible(false)
			end
		end
	else
		for _, modelPart in ipairs({models.models.costume_cheerleader.Avatar.Body.BodyBottom.Skirt, models.models.costume_cheerleader.Avatar.Body.Arms.RightArm.RightArmBottom.RightPonPon, models.models.costume_cheerleader.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftPonPon}) do
			modelPart:setVisible(false)
		end
	end
	if CostumeClass.CurrentCostume ~= "MAID_A" and CostumeClass.CurrentCostume ~= "MAID_B" then
		if renderer:isFirstPerson() and player:getPose() == "SLEEPING" then
			models.models.main.Avatar.Body.BodyBottom.Legs:setVisible(false)
		else
			models.models.main.Avatar.Body.BodyBottom.Legs:setVisible(true)
		end
	end
end)

events.RENDER:register(function ()
	local legAngle = math.abs(vanilla_model.RIGHT_LEG:getOriginRot().x) / 80
	if CostumeClass.CurrentCostume == "MAID_A" then
		local skirt = models.models.costume_maid_a.Avatar.Body.BodyBottom.Skirt
		skirt.Skirt2:setScale(1, 1, 1 + 0.1 * legAngle)
		skirt.Skirt2.Skirt3:setScale(1, 1, 1 + 0.09 * legAngle)
		skirt.Skirt2.Skirt3.Skirt4:setScale(1, 1, 1 + 0.05 * legAngle)
		skirt.Skirt2.Skirt3.Skirt4.Skirt5:setScale(1, 1, 1 + 0.05 * legAngle)
		skirt.Skirt2.Skirt3.Skirt4.Skirt5.Skirt6:setScale(1, 1, 1 + 0.02 * legAngle)
	elseif CostumeClass.CurrentCostume == "MAID_B" then
		local skirt = models.models.costume_maid_b.Avatar.Body.BodyBottom.Skirt
		skirt:setScale(1, 1, 1 + 0.5 * legAngle)
		skirt.Skirt2:setScale(1, 1, 1 + 0.25 * legAngle)
		skirt.Skirt2.Skirt3:setScale(1, 1, 1 + 0.15 * legAngle)
		skirt.Skirt2.Skirt3.Skirt4:setScale(1, 1, 1 + 0.1 * legAngle)
	end
end)

if CostumeClass.CurrentCostume ~= "DEFAULT" then
	CostumeClass.setCostume(CostumeClass.CurrentCostume)
end

return CostumeClass