---@class ArmorClass 防具の表示を制御するクラス
---@field ModelRoot CustomModelPart モデルのルートパス
---@field ArmorRoot CustomModelPart 防具モデルのルートパス
---@field ArmorClass.ShowArmor boolean 防具を表示するかどうか
---@field ShowArmorPrev boolean 前チックの防具を表示するどうか
---@field ArmorClass.ArmorVisible table 各防具の部位（ヘルメット、チェストプイート、レギンス、ブーツ）が可視状態かどうか。

---@alias ArmorType
---| "HELMET"
---| "CHESTPLATE"
---| "LEGGINGS"
---| "BOOTS"

ArmorClass = {}

ModelRoot = models.models.main
ArmorRoot = models.models.armor
ArmorClass.ShowArmor = ConfigClass.ShowArmor
ShowArmorPrev = ConfigClass.ShowArmor
ArmorClass.ArmorVisible = {false, false, false, false}

---防具の設定。有効な防具であれば、trueを返す。
---@param armorItem ItemStack 対象の防具のアイテムスタック
---@param armorType ArmorType 設定する防具の種類
---@param armorPartList table 設定する防具のモデルのパーツリスト
---@param overlayPartList table 設定する防具のオーバーレイのパーツリスト
---@return boolean
function setArmor(armorItem, armorType, armorPartList, overlayPartList)
	if string.find(armorItem.id, "^minecraft:.+_"..string.lower(armorType)) then
		local material = string.match(armorItem.id, ":.+_")
		local glint = armorItem:hasGlint()
		material = string.sub(material, 2, string.len(material) - 1)
		if material == "leather" then
			if armorItem.tag.display ~= nil then
				if armorItem.tag.display.color ~= nil then
					for _, armorPart in ipairs(armorPartList) do
						armorPart:setColor(vectors.intToRGB(armorItem.tag.display.color))
					end
				else
					for _, armorPart in ipairs(armorPartList) do
						armorPart:setColor(160 / 255, 101 / 255, 64 / 255)
					end
				end
			else
				for _, armorPart in ipairs(armorPartList) do
					armorPart:setColor(160 / 255, 101 / 255, 64 / 255)
				end
			end
			for _, overlayPart in ipairs(overlayPartList) do
				overlayPart:setVisible(true)
				overlayPart:setSecondaryRenderType(glint and "GLINT" or nil)
			end
		else
			for _, armorPart in ipairs(armorPartList) do
				armorPart:setColor(1, 1, 1)
			end
			for _, overlayPart in ipairs(overlayPartList) do
				overlayPart:setVisible(false)
			end
		end
		for _, armorPart in ipairs(armorPartList) do
			if armorPart:getName() == "Tail" then
				local materialID = {leather = 0, chainmail = 1, iron = 2, golden = 3, diamond = 4, netherite = 5}
				armorPart.TailChestplate:setUVPixels(0, materialID[material] * 8)
			else
				armorPart:setPrimaryTexture("resource", "minecraft:textures/models/armor/"..(material == "golden" and "gold" or material).."_layer_"..(armorType == "LEGGINGS" and 2 or 1)..".png")
			end
			armorPart:setSecondaryRenderType(glint and "GLINT" or nil)
		end
		return true
	else
		for _, overlayPart in ipairs(overlayPartList) do
			overlayPart:setVisible(false)
		end
		return false
	end
end

---腕の防具を設定する。腕が表示されているかどうかも考慮される。
---@param armorEnabled  boolean 防具を表示するかどうか
function setArmArmor(armorEnabled)
	ArmorRoot.Avatar.Body.Arms.RightArm:setVisible(ModelRoot.Avatar.Body.Arms.RightArm:getVisible() and armorEnabled)
	ArmorRoot.Avatar.Body.Arms.LeftArm:setVisible(ModelRoot.Avatar.Body.Arms.LeftArm:getVisible() and armorEnabled)
	if ModelRoot.Avatar.Body.Arms.RightArm:getVisible() and armorEnabled then
		ArmorRoot.Avatar.Body.Arms.RightArm.RightChestplate:setVisible(true)
		ArmorRoot.Avatar.Body.Arms.RightArm.RightArmBottom.RightChestplateBottom:setVisible(true)
	else
		ArmorRoot.Avatar.Body.Arms.RightArm.RightChestplate:setVisible(false)
		ArmorRoot.Avatar.Body.Arms.RightArm.RightArmBottom.RightChestplateBottom:setVisible(false)
	end
	if ModelRoot.Avatar.Body.Arms.LeftArm:getVisible() and armorEnabled then
		ArmorRoot.Avatar.Body.Arms.LeftArm.LeftChestplate:setVisible(true)
		ArmorRoot.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftChestplateBottom:setVisible(true)
	else
		ArmorRoot.Avatar.Body.Arms.LeftArm.LeftChestplate:setVisible(false)
		ArmorRoot.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftChestplateBottom:setVisible(false)
	end
end

events.TICK:register(function()
	local isSleeping = renderer:isFirstPerson() and playerPose == "SLEEPING"
	if ArmorClass.ShowArmor then
		local helmet = ArmorRoot.Avatar.Head.Helmet
		local chetplate = {ArmorRoot.Avatar.Body.Chestplate, ArmorRoot.Avatar.Body.BodyBottom.ChestplateBottom, ArmorRoot.Avatar.Body.Arms.RightArm.RightChestplate, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftChestplate, ArmorRoot.Avatar.Body.Arms.RightArm.RightChestplate, ArmorRoot.Avatar.Body.Arms.RightArm.RightArmBottom.RightChestplateBottom, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftChestplate, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftChestplateBottom, models.models.armor.Avatar.Body.BodyBottom.Tail}
		local leggings = {ArmorRoot.Avatar.Body.Leggings, ArmorRoot.Avatar.Body.BodyBottom.LeggingsBottom, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeggings, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLeggingsBottom, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeggings, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLeggingsBottom}
		local boots = {ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightBoots, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightBootsBottom, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftBootsBottom}
		local helmetItem = player:getItem(6)
		local playerPose = player:getPose()
		if setArmor(helmetItem, "HELMET", {helmet}, {helmet.HelmetOverlay}) and not isSleeping then
			helmet:setVisible(true)
			ArmorClass.ArmorVisible[1] = true
		else
			helmet:setVisible(false)
			helmet.HelmetOverlay:setVisible(false)
			ArmorClass.ArmorVisible[1] = false
		end
		local chestplateOverlay = {ArmorRoot.Avatar.Body.Chestplate.ChestplateOverlay, ArmorRoot.Avatar.Body.BodyBottom.ChestplateBottom.ChestplateBottomOverlay, ArmorRoot.Avatar.Body.Arms.RightArm.RightChestplate.RightChestplateOverlay, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftChestplate.LeftChestplateOverlay, ArmorRoot.Avatar.Body.Arms.RightArm.RightChestplate.RightChestplateOverlay, ArmorRoot.Avatar.Body.Arms.RightArm.RightArmBottom.RightChestplateBottom.RightChestplateBottomOverlay, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftChestplate.LeftChestplateOverlay, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftChestplateBottom.LeftChestplateBottomOverlay}
		if setArmor(player:getItem(5), "CHESTPLATE", chetplate, chestplateOverlay) and not isSleeping and not renderer:isFirstPerson() then
			for i = 1, 2 do
				chetplate[i]:setVisible(true)
			end
			models.models.armor.Avatar.Body.BodyBottom.Tail:setVisible(true)
			setArmArmor(true)
			ArmorClass.ArmorVisible[2] = true
		else
			for i = 1, 2 do
				chetplate[i]:setVisible(false)
			end
			models.models.armor.Avatar.Body.BodyBottom.Tail:setVisible(false)
			for _, modelPart in ipairs(chestplateOverlay) do
				modelPart:setVisible(false)
			end
			setArmArmor(false)
			ArmorClass.ArmorVisible[2] = false
		end
		local leggingsOverlay = {ArmorRoot.Avatar.Body.Leggings.LeggingsOverlay, ArmorRoot.Avatar.Body.BodyBottom.LeggingsBottom.LeggingsBottomOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeggings.RightLeggingsOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLeggingsBottom.RightLeggingsBottomOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeggings.LeftLeggingsOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLeggingsBottom.LeftLeggingsBottomOverlay}
		if setArmor(player:getItem(4),"LEGGINGS", leggings, leggingsOverlay) and not isSleeping then
			for _, armorPart in ipairs(leggings) do
				armorPart:setVisible(true)
			end
			ApronClass.IsVisible = false
			ArmorClass.ArmorVisible[3] = true
		else
			for _, armorPart in ipairs(leggings) do
				armorPart:setVisible(false)
			end
			for _, modelPart in ipairs(leggingsOverlay) do
				modelPart:setVisible(false)
			end
			if (CostumeClass.CurrentCostume == "DEFAULT" or CostumeClass.CurrentCostume == "DISGUISE" or CostumeClass.CurrentCostume == "KAPPOGI") and not isSleeping then
				ApronClass.IsVisible = true
			end
			ArmorClass.ArmorVisible[3] = false
		end
		local bootsOverlay = {ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightBoots.RightBootsOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightBootsBottom.RightBootsBottomOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftBoots.LeftBootsOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftBootsBottom.LeftBootsBottomOverlay}
		if setArmor(player:getItem(3), "BOOTS", boots, bootsOverlay) and not isSleeping and not ((CostumeClass.CurrentCostume == "MAID_A" or CostumeClass.CurrentCostume == "MAID_B") and player:getVehicle() and not ArmorClass.ArmorVisible[3]) then
			for _, armorPart in ipairs(boots) do
				armorPart:setVisible(true)
			end
			ArmorClass.ArmorVisible[4] = true
		else
			for _, armorPart in ipairs(boots) do
				armorPart:setVisible(false)
			end
			for _, modelPart in ipairs(bootsOverlay) do
				modelPart:setVisible(false)
			end
			ArmorClass.ArmorVisible[4] = false
		end
		ArmorRoot.Avatar.Head:setParentType(playerPose == "SLEEPING" and "None" or "Head")
	elseif ShowArmorPrev then
		for _, modelPart in ipairs({ArmorRoot.Avatar.Head.Helmet, ArmorRoot.Avatar.Body.Chestplate, ArmorRoot.Avatar.Body.BodyBottom.ChestplateBottom, ArmorRoot.Avatar.Body.Arms.RightArm.RightChestplate, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftChestplate, ArmorRoot.Avatar.Body.Arms.RightArm.RightChestplate, ArmorRoot.Avatar.Body.Arms.RightArm.RightArmBottom.RightChestplateBottom, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftChestplate, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftChestplateBottom, models.models.armor.Avatar.Body.BodyBottom.Tail, ArmorRoot.Avatar.Body.Leggings, ArmorRoot.Avatar.Body.BodyBottom.LeggingsBottom, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeggings, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLeggingsBottom, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeggings, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLeggingsBottom, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightBoots, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightBootsBottom, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftBootsBottom, ArmorRoot.Avatar.Head.Helmet.HelmetOverlay, ArmorRoot.Avatar.Body.Chestplate.ChestplateOverlay, ArmorRoot.Avatar.Body.BodyBottom.ChestplateBottom.ChestplateBottomOverlay, ArmorRoot.Avatar.Body.Arms.RightArm.RightChestplate.RightChestplateOverlay, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftChestplate.LeftChestplateOverlay, ArmorRoot.Avatar.Body.Arms.RightArm.RightChestplate.RightChestplateOverlay, ArmorRoot.Avatar.Body.Arms.RightArm.RightArmBottom.RightChestplateBottom.RightChestplateBottomOverlay, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftChestplate.LeftChestplateOverlay, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftChestplateBottom.LeftChestplateBottomOverlay, ArmorRoot.Avatar.Body.Leggings.LeggingsOverlay, ArmorRoot.Avatar.Body.BodyBottom.LeggingsBottom.LeggingsBottomOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeggings.RightLeggingsOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLeggingsBottom.RightLeggingsBottomOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeggings.LeftLeggingsOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLeggingsBottom.LeftLeggingsBottomOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightBoots.RightBootsOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightBootsBottom.RightBootsBottomOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftBoots.LeftBootsOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftBootsBottom.LeftBootsBottomOverlay}) do
			modelPart:setVisible(false)
		end
		ApronClass.IsVisible = CostumeClass.CurrentCostume == "DEFAULT" or CostumeClass.CurrentCostume == "DISGUISE" or CostumeClass.CurrentCostume == "KAPPOGI"
		ArmorClass.ArmorVisible = {false, false, false, false}
	end
	ShowArmorPrev = ArmorClass.ShowArmor
end)

ArmorRoot:setVisible(ConfigClass.ShowArmor)
for _, armorPart in ipairs({ArmorRoot.Avatar.Body.Arms.RightArm.RightChestplate, ArmorRoot.Avatar.Body.Arms.RightArm.RightArmBottom.RightChestplateBottom, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftChestplate, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftChestplate}) do
	armorPart:setVisible(ConfigClass.ShowArmor)
end
for _, modelPart in ipairs({ArmorRoot.Avatar.Body.BodyBottom, ArmorRoot.Avatar.Body.Arms.RightArm.RightArmBottom, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftArmBottom, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeggings, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLeggingsBottom, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeggings, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLeggingsBottom}) do
	modelPart:setParentType("None")
end
for _, overlayPart in ipairs({ArmorRoot.Avatar.Head.Helmet.HelmetOverlay, ArmorRoot.Avatar.Body.Chestplate.ChestplateOverlay, ArmorRoot.Avatar.Body.Arms.RightArm.RightChestplate.RightChestplateOverlay, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftChestplate.LeftChestplateOverlay, ArmorRoot.Avatar.Body.Arms.RightArm.RightChestplate.RightChestplateOverlay, ArmorRoot.Avatar.Body.Arms.RightArm.RightArmBottom.RightChestplateBottom.RightChestplateBottomOverlay, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftChestplate.LeftChestplateOverlay, ArmorRoot.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftChestplateBottom.LeftChestplateBottomOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightBoots.RightBootsOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightBootsBottom.RightBootsBottomOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftBoots.LeftBootsOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftBootsBottom.LeftBootsBottomOverlay}) do
	overlayPart:setPrimaryTexture("resource", "minecraft:textures/models/armor/leather_layer_1_overlay.png")
end
for _, overlayPart in ipairs({ArmorRoot.Avatar.Body.Leggings.LeggingsOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLeggings.RightLeggingsOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.RightLeggingsBottom.RightLeggingsBottomOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLeggings.LeftLeggingsOverlay, ArmorRoot.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.LeftLeggingsBottom.LeftLeggingsBottomOverlay}) do
	overlayPart:setPrimaryTexture("resource", "minecraft:textures/models/armor/leather_layer_2_overlay.png")
end

return ArmorClass