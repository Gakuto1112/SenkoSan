---@class Costume キャラクターのコスチュームを管理し、円滑に切り替えられるようにするクラス
---@field Costume.CostumeList table 利用可能なコスチュームのリスト
---@field Costume.CurrentCostume CostumeType 現在のコスチューム

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
---| "YUKATA"
---| "KNIT"
---| "FOX_HOODIE_RED"
---| "FOX_HOODIE_WHITE"
---| "TRACKSUIT"
---| "CASUAL"
---| "SAILOR"
---| "CHINA_DRESS"
---| "SANTA"

Costume = {
	CostumeList = {"default", "nightwear", "disguise", "maid_a", "maid_b", "swimsuit", "cheerleader", "purification", "kappogi", "yukata", "knit", "fox_hoodie_red", "fox_hoodie_white", "tracksuit", "casual", "sailor", "china_dress", "santa"},
	CurrentCostume = "DEFAULT",

	---メインモデルのテクスチャのオフセット値を設定する。
	---@param offset integer オフセット値
	setCostumeTextureOffset = function (offset)
		for _, modelPart in ipairs({models.models.main.Avatar.Body.Body, models.models.main.Avatar.Body.BodyLayer, models.models.main.Avatar.Body.BodyBottom.BodyBottom, models.models.main.Avatar.Body.BodyBottom.BodyBottomLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArm, models.models.main.Avatar.Body.Arms.RightArm.RightArmLayer, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottom, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightArmBottomLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArm, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmLayer, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftArmBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeg, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLegBottomLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeg, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegLayer, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLegBottomLayer}) do
			modelPart:setUVPixels(0, offset * 48)
		end
	end,

	---コスチュームを設定する。
	---@param costume CostumeType 設定するコスチューム
	setCostume = function (costume)
		Costume.resetCostume()
		Costume.CurrentCostume = costume
		if costume == "NIGHTWEAR" then
			Costume.setCostumeTextureOffset(1)
			Apron.IsVisible = false
		elseif costume == "DISGUISE" then
			for _, modelPart in ipairs({models.models.main.Avatar.Head.CDisguiseH, models.models.main.Avatar.Body.BodyBottom.Tail.CDisguiseT}) do
				modelPart:setVisible(true)
			end
			Costume.setCostumeTextureOffset(2)
			models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setUVPixels(16, 0)
		elseif costume == "MAID_A" then
			Costume.setCostumeTextureOffset(3)
			Apron.IsVisible = false
			Legs.ReducedLegSwing = true
		elseif costume == "MAID_B" then
			Costume.setCostumeTextureOffset(4)
			Apron.IsVisible = false
			Legs.ReducedLegSwing = true
		elseif costume == "SWIMSUIT" then
			Costume.setCostumeTextureOffset(5)
			models.models.main.Avatar.Body.BodyBottom.CMiniSkirtBB:setUVPixels(0, 0)
			Apron.IsVisible = false
		elseif costume == "CHEERLEADER" then
			Costume.setCostumeTextureOffset(6)
			models.models.costume_cheerleader:setVisible(true)
			models.models.main.Avatar.Body.BodyBottom.CMiniSkirtBB:setUVPixels(0, 14)
			Apron.IsVisible = false
		elseif costume == "PURIFICATION" then
			Costume.setCostumeTextureOffset(7)
			Apron.IsVisible = false
		elseif costume == "KAPPOGI" then
			Costume.setCostumeTextureOffset(8)
			models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setUVPixels(32, 0)
		elseif costume == "YUKATA" then
			Costume.setCostumeTextureOffset(9)
			Apron.IsVisible = false
		elseif costume == "FOX_HOODIE_RED" then
			Costume.setCostumeTextureOffset(10)
			models.models.main.Avatar.Head.CFoxHoodH:setUVPixels(0, 0)
			Apron.IsVisible = false
		elseif costume == "FOX_HOODIE_WHITE" then
			Costume.setCostumeTextureOffset(11)
			models.models.main.Avatar.Head.CFoxHoodH:setUVPixels(0, 8)
			Apron.IsVisible = false
		elseif costume == "TRACKSUIT" then
			Costume.setCostumeTextureOffset(12)
			Apron.IsVisible = false
		elseif costume == "CASUAL" then
			Costume.setCostumeTextureOffset(13)
			Apron.IsVisible = false
		elseif costume == "SAILOR" then
			Costume.setCostumeTextureOffset(14)
			models.models.main.Avatar.Body.BodyBottom.CMiniSkirtBB:setUVPixels(0, 28)
			Apron.IsVisible = false
		elseif costume == "CHINA_DRESS" then
			Costume.setCostumeTextureOffset(15)
			Apron.IsVisible = false
		elseif costume == "SANTA" then
			Costume.setCostumeTextureOffset(16)
		end
	end,

	---コスチュームをリセットし、デフォルトのコスチュームにする。
	resetCostume = function ()
		Costume.setCostumeTextureOffset(0)
		for _, modelPart in ipairs({models.models.main.Avatar.Head.CDisguiseH, models.models.main.Avatar.Body.BodyBottom.Tail.CDisguiseT, models.models.costume_cheerleader}) do
			modelPart:setVisible(false)
		end
		Apron.IsVisible = true
		Legs.ReducedLegSwing = false
		models.models.main.Avatar.Body.BodyBottom.Legs.ApronBottom:setUVPixels(0, 0)
		Costume.CurrentCostume = "DEFAULT"
	end,

	---コスチュームの初期処理
	costumeInit = function()
		local loadedData = Config.loadConfig("costume", 1)
		if loadedData <= #Costume.CostumeList then
			Costume.CurrentCostume = string.upper(Costume.CostumeList[loadedData])
			if Costume.CurrentCostume ~= "DEFAULT" then
				Costume.setCostume(Costume.CurrentCostume)
			end
		else
			Costume.CurrentCostume = "DEFAULT"
			Config.saveConfig("costume", 1)
		end
	end
}

events.TICK:register(function ()
	if Costume.CurrentCostume == "DISGUISE" then
		local hat = models.models.main.Avatar.Head.CDisguiseH
		local ears = models.models.main.Avatar.Head.Ears
		if Armor.ArmorVisible[1] then
			hat:setVisible(false)
			ears:setVisible(true)
		else
			hat:setVisible(true)
			ears:setVisible(false)
		end
	else
		models.models.main.Avatar.Head.CDisguiseH:setVisible(false)
		models.models.main.Avatar.Head.Ears:setVisible((Costume.CostumeList ~= "KNIT" and Costume.CurrentCostume ~= "FOX_HOODIE_RED" and Costume.CurrentCostume ~= "FOX_HOODIE_WHITE" and Costume.CurrentCostume ~= "CASUAL") or Armor.ArmorVisible[1])
	end
	if Costume.CurrentCostume == "MAID_A" then
		local skirt = models.models.main.Avatar.Body.BodyBottom.CMaidABB
		skirt:setRot(General.IsSneaking and 27.5 or 0, 0, 0)
		models.models.main.Avatar.Head.CMaidAH:setVisible(not Armor.ArmorVisible[1])
		skirt:setVisible(not Armor.ArmorVisible[3] and not Kotatsu.IsAnimationPlaying)
		if player:getVehicle() then
			if Armor.ArmorVisible[3] then
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
		for _, modelsPart in ipairs({models.models.main.Avatar.Head.CMaidAH, models.models.main.Avatar.Body.BodyBottom.CMaidABB}) do
			modelsPart:setVisible(false)
		end
	end
	if Costume.CurrentCostume == "MAID_B" then
		local skirt = models.models.main.Avatar.Body.BodyBottom.CMaidBBB
		skirt:setRot(General.IsSneaking and 27.5 or 0, 0, 0)
		models.models.main.Avatar.Head.CMaidBH:setVisible(not Armor.ArmorVisible[1])
		skirt:setVisible(not Armor.ArmorVisible[3] and not Kotatsu.IsAnimationPlaying)
		if player:getVehicle() then
			if Armor.ArmorVisible[3] then
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
		for _, modelsPart in ipairs({models.models.main.Avatar.Head.CMaidBH, models.models.main.Avatar.Body.BodyBottom.CMaidBBB}) do
			modelsPart:setVisible(false)
		end
	end
	models.models.main.Avatar.Head.CSwimsuitH:setVisible(Costume.CurrentCostume == "SWIMSUIT" and string.find(player:getItem(6).id, "^minecraft:.+_helmet$") ~= nil and not Armor.ArmorVisible[1])
	if Costume.CurrentCostume == "CHEERLEADER" then
		local rightPonPon = models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.CCheerleaderRAB
		local leftPonPon = models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.CCheerleaderLAB
		if not ActionWheel.IsAnimationPlaying then
			local leftHanded = player:isLeftHanded()
			rightPonPon:setVisible(player:getHeldItem(leftHanded).id == "minecraft:air" and (not Umbrella.Umbrella or not leftHanded))
			leftPonPon:setVisible(player:getHeldItem(not leftHanded).id == "minecraft:air" and (not Umbrella.Umbrella or leftHanded))
		else
			for _, modelPart in ipairs({rightPonPon, leftPonPon}) do
				modelPart:setVisible(false)
			end
		end
	else
		for _, modelPart in ipairs({models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.CCheerleaderRAB, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.CCheerleaderLAB}) do
			modelPart:setVisible(false)
		end
	end
	if Costume.CurrentCostume == "YUKATA" then
		local foxMask = models.models.main.Avatar.Head.CFoxMaskH
		local helmetItemID = player:getItem(6).id
		foxMask:setVisible(string.find(helmetItemID, "^minecraft:.+_helmet$") ~= nil and not Armor.ArmorVisible[1])
		foxMask:setPrimaryTexture("RESOURCE", (helmetItemID == "minecraft:leather_helmet" or helmetItemID == "minecraft:chainmail_helmet" or helmetItemID == "minecraft:iron_helmet") and "textures/entity/fox/fox.png" or "textures/entity/fox/snow_fox.png")
	else
		models.models.main.Avatar.Head.CFoxMaskH:setVisible(false)
	end
	local santa = models.models.main.Avatar.Head.CSantaH
	local leftEar = models.models.main.Avatar.Head.Ears.LeftEarPivot
	if Costume.CurrentCostume ~= "SANTA" or Armor.ArmorVisible[1] then
		santa:setVisible(false)
		leftEar:setVisible(models.models.main.Avatar.Head.Ears:getVisible())
	else
		santa:setVisible(true)
		leftEar:setVisible(false)
	end
	models.models.main.Avatar.Head.CKnitH:setVisible(Costume.CurrentCostume == "KNIT" and not Armor.ArmorVisible[1])
	models.models.main.Avatar.Head.CFoxHoodH:setVisible((Costume.CurrentCostume == "FOX_HOODIE_RED" or Costume.CurrentCostume == "FOX_HOODIE_WHITE") and not Armor.ArmorVisible[1])
	models.models.main.Avatar.Head.CBeretH:setVisible(Costume.CurrentCostume == "CASUAL" and not Armor.ArmorVisible[1])
	Ears.EnableJerkEar = (Costume.CurrentCostume ~= "DISGUISE" and Costume.CurrentCostume ~= "CASUAL") or Armor.ArmorVisible[1]
	if Costume.CurrentCostume ~= "MAID_A" and Costume.CurrentCostume ~= "MAID_B" then
		if renderer:isFirstPerson() and player:getPose() == "SLEEPING" then
			models.models.main.Avatar.Body.BodyBottom.Legs:setVisible(false)
		else
			models.models.main.Avatar.Body.BodyBottom.Legs:setVisible(true)
		end
	end
	if Costume.CurrentCostume == "SWIMSUIT" or Costume.CurrentCostume == "CHEERLEADER" or Costume.CurrentCostume == "SAILOR" then
		local skirt = models.models.main.Avatar.Body.BodyBottom.CMiniSkirtBB
		skirt:setVisible(not Armor.ArmorVisible[3] and not Kotatsu.IsAnimationPlaying)
		skirt:setRot((General.IsSneaking or player:getVehicle()) and 27.5 or 0, 0, 0)
		skirt:setPos(0, 0, General.IsSneaking and 1.25 or 0)
	else
		models.models.main.Avatar.Body.BodyBottom.CMiniSkirtBB:setVisible(false)
	end
	HairAccessory.visible((Costume.CurrentCostume ~= "FOX_HOODIE_RED" and Costume.CurrentCostume ~= "FOX_HOODIE_WHITE" and Costume.CurrentCostume ~= "SANTA") or Armor.ArmorVisible[1])
end)

events.RENDER:register(function ()
	local legAngle = math.abs(vanilla_model.RIGHT_LEG:getOriginRot().x) / 80
	if Costume.CurrentCostume == "MAID_A" then
		local skirt = models.models.main.Avatar.Body.BodyBottom.CMaidABB
		skirt.Skirt2:setScale(1, 1, 1 + 0.1 * legAngle)
		skirt.Skirt2.Skirt3:setScale(1, 1, 1 + 0.09 * legAngle)
		skirt.Skirt2.Skirt3.Skirt4:setScale(1, 1, 1 + 0.05 * legAngle)
		skirt.Skirt2.Skirt3.Skirt4.Skirt5:setScale(1, 1, 1 + 0.05 * legAngle)
		skirt.Skirt2.Skirt3.Skirt4.Skirt5.Skirt6:setScale(1, 1, 1 + 0.02 * legAngle)
	elseif Costume.CurrentCostume == "MAID_B" then
		local skirt = models.models.main.Avatar.Body.BodyBottom.CMaidBBB
		skirt:setScale(1, 1, 1 + 0.5 * legAngle)
		skirt.Skirt2:setScale(1, 1, 1 + 0.25 * legAngle)
		skirt.Skirt2.Skirt3:setScale(1, 1, 1 + 0.15 * legAngle)
		skirt.Skirt2.Skirt3.Skirt4:setScale(1, 1, 1 + 0.1 * legAngle)
	end
end)

Costume.costumeInit()

return Costume