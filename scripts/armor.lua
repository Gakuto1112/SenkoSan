---@class Armor 防具の表示を制御するクラス
---@field Armor.ShowArmor boolean 防具を表示するかどうか
---@field Armor.ShowArmorPrev boolean 前チックの防具を表示するどうか
---@field Armor.ArmorVisible table 各防具の部位（ヘルメット、チェストプイート、レギンス、ブーツ）が可視状態かどうか。

---@alias ArmorType
---| "HELMET"
---| "CHESTPLATE"
---| "LEGGINGS"
---| "BOOTS"

Armor = {}

Armor.ShowArmor = Config.loadConfig("showArmor", false)
Armor.ShowArmorPrev = Armor.ShowArmor
Armor.ArmorVisible = {false, false, false, false}

---防具の設定。有効な防具であれば、trueを返す。
---@param armorItem ItemStack 対象の防具のアイテムスタック
---@param armorType ArmorType 設定する防具の種類
---@param armorPartList table 設定する防具のモデルのパーツリスト
---@param overlayPartList table 設定する防具のオーバーレイのパーツリスト
---@return boolean isArmorValid 引数の防具が有効かどうか
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
			if armorPart:getName() == "ArmorT" then
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
	models.models.main.Avatar.Body.Arms.RightArm.ArmorRA:setVisible(models.models.main.Avatar.Body.Arms.RightArm:getVisible() and armorEnabled)
	models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA:setVisible(models.models.main.Avatar.Body.Arms.LeftArm:getVisible() and armorEnabled)
	if models.models.main.Avatar.Body.Arms.RightArm:getVisible() and armorEnabled then
		models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate:setVisible(true)
		models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom:setVisible(true)
	else
		models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate:setVisible(false)
		models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom:setVisible(false)
	end
	if models.models.main.Avatar.Body.Arms.LeftArm:getVisible() and armorEnabled then
		models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate:setVisible(true)
		models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom:setVisible(true)
	else
		models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate:setVisible(false)
		models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom:setVisible(false)
	end
end

events.TICK:register(function()
	local playerPose = player:getPose()
	local isSleeping = renderer:isFirstPerson() and playerPose == "SLEEPING"
	if Armor.ShowArmor then
		local helmet = models.models.main.Avatar.Head.ArmorH.Helmet
		local chetplate = {models.models.main.Avatar.Body.ArmorB.Chestplate, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom, models.models.main.Avatar.Body.BodyBottom.Tail.ArmorT}
		local leggings = {models.models.main.Avatar.Body.ArmorB.Leggings, models.models.main.Avatar.Body.BodyBottom.ArmorBB.LeggingsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightLeggings, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightLeggingsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftLeggings, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftLeggingsBottom}
		local boots = {models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightBoots, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightBootsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftBootsBottom}
		local helmetItem = player:getItem(6)
		if setArmor(helmetItem, "HELMET", {helmet}, {helmet.HelmetOverlay}) and not isSleeping then
			helmet:setVisible(true)
			Armor.ArmorVisible[1] = true
		else
			helmet:setVisible(false)
			helmet.HelmetOverlay:setVisible(false)
			Armor.ArmorVisible[1] = false
		end
		local chestplateOverlay = {models.models.main.Avatar.Body.ArmorB.Chestplate.ChestplateOverlay, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom.ChestplateBottomOverlay, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplateOverlay, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplateOverlay, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplateOverlay, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom.RightChestplateBottomOverlay, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplateOverlay, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom.LeftChestplateBottomOverlay}
		local chestplateEnabled = setArmor(player:getItem(5), "CHESTPLATE", chetplate, chestplateOverlay)
		if chestplateEnabled and not isSleeping and not renderer:isFirstPerson() and not Kotatsu.IsAnimationPlaying then
			for i = 1, 2 do
				chetplate[i]:setVisible(true)
			end
			models.models.main.Avatar.Body.BodyBottom.Tail.ArmorT:setVisible(true)
			setArmArmor(true)
			Armor.ArmorVisible[2] = true
		else
			for i = 1, 2 do
				chetplate[i]:setVisible(false)
			end
			models.models.main.Avatar.Body.BodyBottom.Tail.ArmorT:setVisible(chestplateEnabled and not isSleeping)
			for _, modelPart in ipairs(chestplateOverlay) do
				modelPart:setVisible(false)
			end
			setArmArmor(false)
			Armor.ArmorVisible[2] = false
		end
		local leggingsOverlay = {models.models.main.Avatar.Body.ArmorB.Leggings.LeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.ArmorBB.LeggingsBottom.LeggingsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightLeggings.RightLeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightLeggingsBottom.RightLeggingsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftLeggings.LeftLeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftLeggingsBottom.LeftLeggingsBottomOverlay}
		if setArmor(player:getItem(4),"LEGGINGS", leggings, leggingsOverlay) and not isSleeping and not Kotatsu.IsAnimationPlaying then
			for _, armorPart in ipairs(leggings) do
				armorPart:setVisible(true)
			end
			Apron.IsVisible = false
			Armor.ArmorVisible[3] = true
		else
			for _, armorPart in ipairs(leggings) do
				armorPart:setVisible(false)
			end
			for _, modelPart in ipairs(leggingsOverlay) do
				modelPart:setVisible(false)
			end
			if (Costume.CurrentCostume == "DEFAULT" or Costume.CurrentCostume == "DISGUISE" or Costume.CurrentCostume == "KAPPOGI") and not isSleeping and not Kotatsu.IsAnimationPlaying then
				Apron.IsVisible = true
			end
			Armor.ArmorVisible[3] = false
		end
		local bootsOverlay = {models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightBoots.RightBootsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightBootsBottom.RightBootsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftBoots.LeftBootsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftBootsBottom.LeftBootsBottomOverlay}
		if setArmor(player:getItem(3), "BOOTS", boots, bootsOverlay) and not isSleeping and not ((Costume.CurrentCostume == "MAID_A" or Costume.CurrentCostume == "MAID_B") and player:getVehicle() and not Armor.ArmorVisible[3]) then
			for _, armorPart in ipairs(boots) do
				armorPart:setVisible(true)
			end
			Armor.ArmorVisible[4] = true
		else
			for _, armorPart in ipairs(boots) do
				armorPart:setVisible(false)
			end
			for _, modelPart in ipairs(bootsOverlay) do
				modelPart:setVisible(false)
			end
			Armor.ArmorVisible[4] = false
		end
	elseif Armor.ShowArmorPrev then
		for _, modelPart in ipairs({models.models.main.Avatar.Head.ArmorH.Helmet, models.models.main.Avatar.Body.ArmorB.Chestplate, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom, models.models.main.Avatar.Body.BodyBottom.Tail.ArmorT, models.models.main.Avatar.Body.ArmorB.Leggings, models.models.main.Avatar.Body.BodyBottom.ArmorBB.LeggingsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightLeggings, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightLeggingsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftLeggings, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftLeggingsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightBoots, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightBootsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftBootsBottom, models.models.main.Avatar.Head.ArmorH.Helmet.HelmetOverlay, models.models.main.Avatar.Body.ArmorB.Chestplate.ChestplateOverlay, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom.ChestplateBottomOverlay, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplateOverlay, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplateOverlay, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplateOverlay, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom.RightChestplateBottomOverlay, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplateOverlay, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom.LeftChestplateBottomOverlay, models.models.main.Avatar.Body.ArmorB.Leggings.LeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.ArmorBB.LeggingsBottom.LeggingsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightLeggings.RightLeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightLeggingsBottom.RightLeggingsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftLeggings.LeftLeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftLeggingsBottom.LeftLeggingsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightBoots.RightBootsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightBootsBottom.RightBootsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftBoots.LeftBootsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftBootsBottom.LeftBootsBottomOverlay}) do
			modelPart:setVisible(false)
		end
		Apron.IsVisible = Costume.CurrentCostume == "DEFAULT" or Costume.CurrentCostume == "DISGUISE" or Costume.CurrentCostume == "KAPPOGI"
		Armor.ArmorVisible = {false, false, false, false}
	end
	Armor.ShowArmorPrev = Armor.ShowArmor
end)

for _, overlayPart in ipairs({models.models.main.Avatar.Head.ArmorH.Helmet.HelmetOverlay, models.models.main.Avatar.Body.ArmorB.Chestplate.ChestplateOverlay, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplateOverlay, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplateOverlay, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplateOverlay, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom.RightChestplateBottomOverlay, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplateOverlay, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom.LeftChestplateBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightBoots.RightBootsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightBootsBottom.RightBootsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftBoots.LeftBootsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftBootsBottom.LeftBootsBottomOverlay}) do
	overlayPart:setPrimaryTexture("resource", "minecraft:textures/models/armor/leather_layer_1_overlay.png")
end
for _, overlayPart in ipairs({models.models.main.Avatar.Body.ArmorB.Leggings.LeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightLeggings.RightLeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightLeggingsBottom.RightLeggingsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftLeggings.LeftLeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftLeggingsBottom.LeftLeggingsBottomOverlay}) do
	overlayPart:setPrimaryTexture("resource", "minecraft:textures/models/armor/leather_layer_2_overlay.png")
end

return Armor