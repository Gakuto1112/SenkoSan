---@class Armor 防具の表示を制御するクラス
---@field ShowArmor boolean 防具を表示するかどうか
---@field ArmorSlotItemsPrev table<ItemStack> 前チックの防具スロットのアイテム
---@field ArmorVisible table<boolean> 各防具の部位（ヘルメット、チェストプイート、レギンス、ブーツ）が可視状態かどうか。
Armor = {
	ShowArmor = Config.loadConfig("showArmor", false),
	ArmorSlotItemsPrev = {world.newItem("minecraft:air"), world.newItem("minecraft:air"), world.newItem("minecraft:air"), world.newItem("minecraft:air")},
	ArmorVisible = {false, false, false, false}
}

events.TICK:register(function ()
	---防具の色を取得する。
	---@param armorItem ItemStack 調べるアイテムのオブジェクト
	---@return number color 防具モデルに設定すべき色
	local function getArmorColor(armorItem)
		if armorItem.id:find("^minecraft:leather_") then
			if armorItem.tag then
				if armorItem.tag.display then
					return armorItem.tag.display.color and armorItem.tag.display.color or 10511680
				else
					return 10511680
				end
			else
				return 10511680
			end
		else
			return 16777215
		end
	end

	local armorSlotItems = Armor.ShowArmor and {player:getItem(6), player:getItem(5), player:getItem(4), player:getItem(3)} or {world.newItem("minecraft:air"), world.newItem("minecraft:air"), world.newItem("minecraft:air"), world.newItem("minecraft:air")}
	for index, armorSlotItem in ipairs(armorSlotItems) do
		if armorSlotItem.id ~= Armor.ArmorSlotItemsPrev[index].id then
			--防具変更
			if index == 1 then
				local helmetFound = armorSlotItems[1].id:find("^minecraft:.+_helmet$") == 1
				models.models.main.Avatar.Head.ArmorH.Helmet:setVisible(helmetFound)
				Armor.ArmorVisible[1] = helmetFound
				if helmetFound then
					local material = armorSlotItems[1].id:match("^minecraft:(%a+)_helmet$")
					models.models.main.Avatar.Head.ArmorH.Helmet.Helmet:setPrimaryTexture("RESOURCE", "minecraft:textures/models/armor/"..(material == "golden" and "gold" or material).."_layer_1.png")
					models.models.main.Avatar.Head.ArmorH.Helmet.Ears:setUVPixels(0, material == "leather" and 0 or (material == "chainmail" and 8 or (material == "iron" and 16 or (material == "golden" and 24 or (material == "diamond" and 32 or 40)))))
				end
				models.models.main.Avatar.Head.ArmorH.Helmet.HelmetOverlay:setVisible(armorSlotItems[1].id == "minecraft:leather_helmet")
			elseif index == 2 then
				local chestplateFound = armorSlotItems[2].id:find("^minecraft:.+_chestplate$") == 1
				for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Chestplate, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom, models.models.main.Avatar.Body.BodyBottom.Tail.ArmorT, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom}) do
					armorPart:setVisible(chestplateFound)
				end
				Armor.ArmorVisible[2] = chestplateFound
				if chestplateFound then
					local material = armorSlotItems[2].id:match("^minecraft:(%a+)_chestplate$")
					for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Chestplate.Chestplate, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom.ChestplateBottom, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplate, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom.RightChestplateBottom, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplate, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom.LeftChestplateBottom}) do
						armorPart:setPrimaryTexture("RESOURCE", "minecraft:textures/models/armor/"..(material == "golden" and "gold" or material).."_layer_1.png")
					end
					models.models.main.Avatar.Body.BodyBottom.Tail.ArmorT.TailChestplate:setUVPixels(0, material == "leather" and 0 or (material == "chainmail" and 8 or (material == "iron" and 16 or (material == "golden" and 24 or (material == "diamond" and 32 or 40)))))
				end
				local overlayVisible = armorSlotItems[2].id == "minecraft:leather_chestplate"
				for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Chestplate.ChestplateOverlay, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom.ChestplateBottomOverlay, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplateOverlay, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom.RightChestplateBottomOverlay, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplateOverlay, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom.LeftChestplateBottomOverlay}) do
					armorPart:setVisible(overlayVisible)
				end
			elseif index == 3 then
				local leggingsFound = armorSlotItems[3].id:find("^minecraft:.+_leggings$") == 1
				for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Leggings, models.models.main.Avatar.Body.BodyBottom.ArmorBB.LeggingsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightLeggings, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightLeggingsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftLeggings, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftLeggingsBottom}) do
					armorPart:setVisible(leggingsFound)
				end
				Armor.ArmorVisible[3] = leggingsFound
				if leggingsFound then
					local material = armorSlotItems[3].id:match("^minecraft:(%a+)_leggings$")
					for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Leggings.Leggings, models.models.main.Avatar.Body.BodyBottom.ArmorBB.LeggingsBottom.LeggingsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightLeggings.RightLeggings, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightLeggingsBottom.RightLeggingsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftLeggings.LeftLeggings, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftLeggingsBottom.LeftLeggingsBottom}) do
						armorPart:setPrimaryTexture("RESOURCE", "minecraft:textures/models/armor/"..(material == "golden" and "gold" or material).."_layer_2.png")
					end
				end
				local overlayVisible = armorSlotItems[3].id == "minecraft:leather_leggings"
				for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Leggings.LeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.ArmorBB.LeggingsBottom.LeggingsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightLeggings.RightLeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightLeggingsBottom.RightLeggingsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftLeggings.LeftLeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftLeggingsBottom.LeftLeggingsBottomOverlay}) do
					armorPart:setVisible(overlayVisible)
				end
			else
				local bootsFound = armorSlotItems[4].id:find("^minecraft:.+_boots$") == 1
				for _, armorPart in ipairs({models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightBoots, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightBootsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftBoots, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftBootsBottom}) do
					armorPart:setVisible(bootsFound)
				end
				Armor.ArmorVisible[4] = bootsFound
				if bootsFound then
					local material = armorSlotItems[4].id:match("^minecraft:(%a+)_boots$")
					for _, armorPart in ipairs({models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightBoots.RightBoots, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightBootsBottom.RightBootsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftBoots.LeftBoots, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftBootsBottom.LeftBootsBottom}) do
						armorPart:setPrimaryTexture("RESOURCE", "minecraft:textures/models/armor/"..(material == "golden" and "gold" or material).."_layer_1.png")
					end
				end
				local overlayVisible = armorSlotItems[4].id == "minecraft:leather_boots"
				for _, armorPart in ipairs({models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightBoots.RightBootsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightBootsBottom.RightBootsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftBoots.LeftBootsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftBootsBottom.LeftBootsBottomOverlay}) do
					armorPart:setVisible(overlayVisible)
				end
			end
			Costume.onArmorChenge(index)
		end
		local glint = armorSlotItem:hasGlint()
		if glint ~= Armor.ArmorSlotItemsPrev[index]:hasGlint() then
			--エンチャント変更
			local renderType = glint and "GLINT" or "NONE"
			if index == 1 then
				models.models.main.Avatar.Head.ArmorH.Helmet:setSecondaryRenderType(renderType)
			elseif index == 2 then
				for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Chestplate, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom, models.models.main.Avatar.Body.BodyBottom.Tail.ArmorT, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom}) do
					armorPart:setSecondaryRenderType(renderType)
				end
			elseif index == 3 then
				for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Leggings, models.models.main.Avatar.Body.BodyBottom.ArmorBB.LeggingsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightLeggings, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightLeggingsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftLeggings, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftLeggingsBottom}) do
					armorPart:setSecondaryRenderType(renderType)
				end
			else
				for _, armorPart in ipairs({models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightBoots, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightBootsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftBoots, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftBootsBottom}) do
					armorPart:setSecondaryRenderType(renderType)
				end
			end
		end
		local armorColor = getArmorColor(armorSlotItem)
		if armorColor ~= getArmorColor(Armor.ArmorSlotItemsPrev[index]) then
			--色変更
			local colorVector = vectors.intToRGB(armorColor)
			if index == 1 then
				for _, armorPart in ipairs({models.models.main.Avatar.Head.ArmorH.Helmet.Helmet, models.models.main.Avatar.Head.ArmorH.Helmet.Ears}) do
					armorPart:setColor(colorVector)
				end
			elseif index == 2 then
				for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Chestplate.Chestplate, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom.ChestplateBottom, models.models.main.Avatar.Body.BodyBottom.Tail.ArmorT.TailChestplate, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplate, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom.RightChestplateBottom, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplate, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom.LeftChestplateBottom}) do
					armorPart:setColor(colorVector)
				end
			elseif index == 3 then
				for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Leggings.Leggings, models.models.main.Avatar.Body.BodyBottom.ArmorBB.LeggingsBottom.LeggingsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightLeggings.RightLeggings, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightLeggingsBottom.RightLeggingsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftLeggings.LeftLeggings, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftLeggingsBottom.LeftLeggingsBottom}) do
					armorPart:setColor(colorVector)
				end
			else
				for _, armorPart in ipairs({models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightBoots.RightBoots, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightBootsBottom.RightBootsBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftBoots.LeftBoots, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftBootsBottom.LeftBootsBottom}) do
					armorPart:setColor(colorVector)
				end
			end
		end
	end
	Armor.ArmorSlotItemsPrev = armorSlotItems
end)

for _, overlayPart in ipairs({models.models.main.Avatar.Head.ArmorH.Helmet.HelmetOverlay, models.models.main.Avatar.Body.ArmorB.Chestplate.ChestplateOverlay, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplateOverlay, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplateOverlay, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplateOverlay, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom.RightChestplateBottomOverlay, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplateOverlay, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom.LeftChestplateBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightBoots.RightBootsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightBootsBottom.RightBootsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftBoots.LeftBootsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftBootsBottom.LeftBootsBottomOverlay}) do
	overlayPart:setPrimaryTexture("RESOURCE", "minecraft:textures/models/armor/leather_layer_1_overlay.png")
end
for _, overlayPart in ipairs({models.models.main.Avatar.Body.ArmorB.Leggings.LeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightLeggings.RightLeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightLeggingsBottom.RightLeggingsBottomOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftLeggings.LeftLeggingsOverlay, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftLeggingsBottom.LeftLeggingsBottomOverlay}) do
	overlayPart:setPrimaryTexture("RESOURCE", "minecraft:textures/models/armor/leather_layer_2_overlay.png")
end

return Armor