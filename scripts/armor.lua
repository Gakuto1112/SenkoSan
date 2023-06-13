---@class Armor 防具の表示を制御するクラス
---@field ShowArmor boolean 防具を表示するかどうか
---@field ArmorSlotItemsPrev table<ItemStack> 前チックの防具スロットのアイテム
---@field ArmorVisible table<boolean> 各防具の部位（ヘルメット、チェストプイート、レギンス、ブーツ）が可視状態かどうか。
Armor = {
	ShowArmor = Config.loadConfig("showArmor", false),
	ArmorSlotItemsPrev = {world.newItem("minecraft:air"), world.newItem("minecraft:air"), world.newItem("minecraft:air"), world.newItem("minecraft:air")},
	ArmorVisible = {false, false, false, false}
}

--[[
	各キューデータの中身
	{
		texture: 処理するテクスチャ
		palette: 使用するパレットのテクスチャ
		iterationCount: 現在の繰り返しカウント
	}

]]
local textureQueue = {} --テクスチャの処理のキュー

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

	---テクスチャの処理のキューにデータを挿入する。
	---@param texture Texture 処理を行うテクスチャ
	---@param paletteName string 使用するパレットの名前
	local function addTextureQueue(texture, paletteName)
		if textures["trim_palette_"..paletteName] == nil then
			textures:fromVanilla("trim_palette_"..paletteName, "minecraft:textures/trims/color_palettes/"..paletteName..".png")
		end
		table.insert(textureQueue, 1, {
			texture = texture,
			palette = textures["trim_palette_"..paletteName],
			iterationCount = 0
		});
	end

	---バニラパーツの防具装飾のテクスチャを取得する。テクスチャの処理は次のチック以降行われる。
	---@param trimData table? 防具装飾のデータ
	---@param armorId string 防具アイテムのID。
	---@param tailArmor boolean 尻尾防具用の装飾のテクスチャを取得するならtrueにする。
	---@return Texture? trimTexture 色を付けた防具装飾のテクスチャ。防具や防具装飾が非バニラの場合はnilを返す。
	local function getTrimTexture(trimData, armorId, tailArmor)
		if trimData and trimData.pattern:find("^minecraft:.+$") and trimData.material:find("^minecraft:.+$") and armorId:find("^minecraft:.+_.+$") then
			local normalizedPatternName = trimData.pattern:match("^minecraft:(%a+)$")
			local normalizedArmorMaterialName = armorId:match("^minecraft:(%a+)_.+$")
			normalizedArmorMaterialName = normalizedArmorMaterialName == "golden" and "gold" or normalizedArmorMaterialName
			local normalizedMaterialName = trimData.material:match("^minecraft:(%a+)$")
			normalizedMaterialName = normalizedMaterialName..(normalizedArmorMaterialName == normalizedMaterialName and "_darker" or "")
			local isLeggings = armorId:find("^minecraft:.+_leggings$")
			local textureName = "trim_"..normalizedPatternName.."_"..normalizedMaterialName..(tailArmor and "_tail" or (isLeggings and "_leggings" or ""))
			if textures[textureName] then
				return textures[textureName]
			else
				local texture = tailArmor and textures:copy(textureName, textures["textures.armor_trims."..normalizedPatternName]) or textures:fromVanilla(textureName, "minecraft:textures/trims/models/armor/"..normalizedPatternName..(armorId:find("^minecraft:.+_leggings$") ~= nil and "_leggings" or "")..".png")
				addTextureQueue(texture, normalizedMaterialName)
				return texture
			end
		end
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
			--トリム変更
			if index == 1 then
				local trimTexture = getTrimTexture(trim, armorSlotItems[1].id, false)
				if trimTexture then
					models.models.main.Avatar.Head.ArmorH.Helmet.HelmetTrim:setVisible(true)
					models.models.main.Avatar.Head.ArmorH.Helmet.HelmetTrim:setPrimaryTexture("CUSTOM", trimTexture)
				else
					models.models.main.Avatar.Head.ArmorH.Helmet.HelmetTrim:setVisible(false)
				end
			elseif index == 2 then
				local trimTexture = getTrimTexture(trim, armorSlotItems[2].id, false)
				if trimTexture then
					for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Chestplate.ChestplateTrim, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom.ChestplateBottomTrim, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplateTrim, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom.RightChestplateBottomTrim, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplateTrim, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom.LeftChestplateBottomTrim}) do
						armorPart:setVisible(true)
						armorPart:setPrimaryTexture("CUSTOM", trimTexture)
					end
					models.models.main.Avatar.Body.BodyBottom.Tail.ArmorT.TailChestplateTrim:setVisible(true)
					local tailTrimTexture = getTrimTexture(trim, armorSlotItems[2].id, true)
					models.models.main.Avatar.Body.BodyBottom.Tail.ArmorT.TailChestplateTrim:setPrimaryTexture("CUSTOM", tailTrimTexture)
				else
					for _, armorPart in ipairs({models.models.main.Avatar.Body.ArmorB.Chestplate.ChestplateTrim, models.models.main.Avatar.Body.BodyBottom.ArmorBB.ChestplateBottom.ChestplateBottomTrim, models.models.main.Avatar.Body.Arms.RightArm.ArmorRA.RightChestplate.RightChestplateTrim, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.ArmorRAB.RightChestplateBottom.RightChestplateBottomTrim, models.models.main.Avatar.Body.Arms.LeftArm.ArmorLA.LeftChestplate.LeftChestplateTrim, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.ArmorLAB.LeftChestplateBottom.LeftChestplateBottomTrim}) do
						armorPart:setVisible(false)
					end
					models.models.main.Avatar.Body.BodyBottom.Tail.ArmorT.TailChestplateTrim:setVisible(false)
				end
			elseif index == 3 then
				local trimTexture = getTrimTexture(trim, armorSlotItems[3].id, false)
				if trimTexture then
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
				local trimTexture = getTrimTexture(trim, armorSlotItems[4].id, false)
				if trimTexture then
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