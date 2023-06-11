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

	---防具装飾が同じものか比較する。
	---@param trim1 table|nil 比較する防具装飾のテーブル1
	---@param trim2 table|nil 比較する防具装飾のテーブル2
	---@return boolean isTrimSame 2つの防具装飾が同じものかどうか
	local function compareTrims(trim1, trim2)
		if type(trim1) == type(trim2) then
			if trim1 then
				if trim1.pattern ~= trim2.pattern then
					return false
				elseif trim1.material ~= trim2.material then
					return false
				else
					return true
				end
			else
				return true
			end
		else
			return false
		end
	end

	---防具装飾のテクスチャを取得する。
	---@param trimPattern string 防具装飾の模様
	---@param trimMaterial string 防具装飾の素材
	---@param armorId string 防具アイテムのID
	---@return Texture|nil trimTexture 色を付けた防具装飾のテクスチャ。防具や防具装飾が非バニラの場合はnilを返す。
	local function getTrimTexture(trimPattern, trimMaterial, armorId)
		if trimPattern:find("^minecraft:.+$") and trimMaterial:find("^minecraft:.+$") and armorId:find("^minecraft:.+_.+$") then
			local pattern = trimPattern:match("^minecraft:(%a+)$")
			local material = trimMaterial:match("^minecraft:(%a+)$")
			local isLeggings = armorId:find("^minecraft:.+_leggings$")
			local textureName = "trim_"..pattern.."_"..material..(isLeggings and "_leggings" or "")
			if textures[textureName] == nil then
				local trim = textures:fromVanilla(textureName, "minecraft:textures/trims/models/armor/"..pattern..(isLeggings and "_leggings" or "")..".png")
				local armorMaterial = armorId:match("^minecraft:(%a+)_.+$")
				armorMaterial = armorMaterial == "golden" and "gold" or armorMaterial
				local isSameMaterial = material == armorMaterial
				local paletteName = "trim_palette_"..material..(isSameMaterial and "_darker" or "")
				local palette = textures[paletteName]
				if palette == nil then
					palette = textures:fromVanilla(paletteName, "minecraft:textures/trims/color_palettes/"..material..(isSameMaterial and "_darker" or "")..".png")
				end
				for y = 0, 31 do
					for x = 0, 63 do
						local pixel = trim:getPixel(x, y)
						if pixel.w == 1 then
							trim:setPixel(x, y, palette:getPixel(7 - math.floor(pixel.x * 8), 0))
						end
					end
				end
				return trim
			else
				return textures[textureName]
			end
		end
		return nil
	end

	local armorSlotItems = Armor.ShowArmor and {Sleep.HeadVisible and player:getItem(6) or world.newItem("minecraft:air"), player:getItem(5), player:getItem(4), player:getItem(3)} or {world.newItem("minecraft:air"), world.newItem("minecraft:air"), world.newItem("minecraft:air"), world.newItem("minecraft:air")}
	for index, armorSlotItem in ipairs(armorSlotItems) do
		if armorSlotItem.id ~= Armor.ArmorSlotItemsPrev[index].id then
			--防具変更
			if index == 1 then
				local helmetFound = armorSlotItems[1].id:find("^minecraft:.+_helmet$") ~= nil
				models.models.main.Avatar.Head.ArmorH:setVisible(helmetFound)
				Armor.ArmorVisible[1] = helmetFound
				if helmetFound then
					local material = armorSlotItems[1].id:match("^minecraft:(%a+)_helmet$")
					models.models.main.Avatar.Head.ArmorH.Helmet.Helmet:setPrimaryTexture("RESOURCE", "minecraft:textures/models/armor/"..(material == "golden" and "gold" or material).."_layer_1.png")
					models.models.main.Avatar.Head.ArmorH.Helmet.Ears:setUVPixels(0, material == "leather" and 0 or (material == "chainmail" and 8 or (material == "iron" and 16 or (material == "golden" and 24 or (material == "diamond" and 32 or 40)))))
				end
				models.models.main.Avatar.Head.ArmorH.Helmet.HelmetOverlay:setVisible(armorSlotItems[1].id == "minecraft:leather_helmet")
			elseif index == 2 then
				local chestplateFound = armorSlotItems[2].id:find("^minecraft:.+_chestplate$") ~= nil
				for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Chestplate, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom, models.models.main.Avatar.Body.BodyBottom.Tail.ArmorT, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB}) do
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
				local leggingsFound = armorSlotItems[3].id:find("^minecraft:.+_leggings$") ~= nil
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
				local bootsFound = armorSlotItems[4].id:find("^minecraft:.+_boots$") ~= nil
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
		local trim = armorSlotItems[index].tag.Trim
		if not compareTrims(trim, Armor.ArmorSlotItemsPrev[index].tag.Trim) then
			local trimFound = trim ~= nil
			--トリム変更
			if index == 1 then
				if trimFound then
					models.models.main.Avatar.Head.ArmorH.Helmet.HelmetTrim:setVisible(true)
					local trimTexture = getTrimTexture(trim.pattern, trim.material, armorSlotItems[1].id)
					if trimTexture ~= nil then
						models.models.main.Avatar.Head.ArmorH.Helmet.HelmetTrim:setPrimaryTexture("CUSTOM", trimTexture)
					end
				else
					models.models.main.Avatar.Head.ArmorH.Helmet.HelmetTrim:setVisible(false)
				end
			elseif index == 2 then
				if trimFound then
					local trimTexture = getTrimTexture(trim.pattern, trim.material, armorSlotItems[2].id)
					for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Chestplate.ChestplateTrim, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom.ChestplateBottomTrim, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplateTrim, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom.RightChestplateBottomTrim, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplateTrim, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom.LeftChestplateBottomTrim}) do
						armorPart:setVisible(true)
						armorPart:setPrimaryTexture("CUSTOM", trimTexture)
					end
				else
					for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Chestplate.ChestplateTrim, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom.ChestplateBottomTrim, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplateTrim, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom.RightChestplateBottomTrim, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplateTrim, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom.LeftChestplateBottomTrim}) do
						armorPart:setVisible(false)
					end
				end
			elseif index == 3 then
				if trimFound then
					local trimTexture = getTrimTexture(trim.pattern, trim.material, armorSlotItems[3].id)
					for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Leggings.LeggingsTrim, models.models.main.Avatar.Body.BodyBottom.ArmorBB.LeggingsBottom.LeggingsBottomTrim, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightLeggings.RightLeggingsTrim, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightLeggingsBottom.RightLeggingsBottomTrim, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftLeggings.LeftLeggingsTrim, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftLeggingsBottom.LeftLeggingsBottomTrim}) do
						armorPart:setVisible(true)
						armorPart:setPrimaryTexture("CUSTOM", trimTexture)
					end
				else
					for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Leggings.LeggingsTrim, models.models.main.Avatar.Body.BodyBottom.ArmorBB.LeggingsBottom.LeggingsBottomTrim, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightLeggings.RightLeggingsTrim, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightLeggingsBottom.RightLeggingsBottomTrim, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftLeggings.LeftLeggingsTrim, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftLeggingsBottom.LeftLeggingsBottomTrim}) do
						armorPart:setVisible(false)
					end
				end
			else
				if trimFound then
					local trimTexture = getTrimTexture(trim.pattern, trim.material, armorSlotItems[4].id)
					for _, armorPart in ipairs({models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightBoots.RightBootsTrim, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightBootsBottom.RightBootsBottomTrim, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftBoots.LeftBootsTrim, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftBootsBottom.LeftBootsBottomTrim}) do
						armorPart:setVisible(true)
						armorPart:setPrimaryTexture("CUSTOM", trimTexture)
					end
				else
					for _, armorPart in ipairs({models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.ArmorRL.RightBoots.RightBootsTrim, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom.ArmorRLB.RightBootsBottom.RightBootsBottomTrim, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.ArmorLL.LeftBoots.LeftBootsTrim, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom.ArmorLLB.LeftBootsBottom.LeftBootsBottomTrim}) do
						armorPart:setVisible(false)
					end
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