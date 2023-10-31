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
---| "KIMONO"
---| "HALLOWEEN"

---@class Costume キャラクターのコスチュームを管理し、円滑に切り替えられるようにするクラス
---@field CostumeList table<string> 利用可能なコスチュームのリスト
---@field CurrentCostume CostumeType 現在のコスチューム
Costume = {
	CostumeList = {"default", "nightwear", "disguise", "maid_a", "maid_b", "swimsuit", "cheerleader", "purification", "kappogi", "yukata", "knit", "fox_hoodie_red", "fox_hoodie_white", "tracksuit", "casual", "sailor", "china_dress", "kimono", "halloween", "santa"},
	CurrentCostume = "DEFAULT",
	CostumeEvents = {
		---メイド服Aのチック処理
		MaidATick = function ()
			models.models.main.Avatar.UpperBody.Body.CMaidAB:setRot(player:getPose() == "CROUCHING" and 27.5 or 0)
			if player:getVehicle() then
				if not Armor.ArmorVisible[3] then
					models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2:setPos(0, 0.75)
					models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2:setScale(1.05, 1, 1.05)
					models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3:setPos(0, 0.75)
					models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3:setScale(1.05, 1, 1.05)
					models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3.Skirt4:setPos(0, 1.5)
					models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3.Skirt4:setScale(1.05, 1, 1.05)
					models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3.Skirt4.Skirt5:setPos(0, 2.5)
					models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3.Skirt4.Skirt5:setScale(1.05, 1, 1.05)
					models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3.Skirt4.Skirt5.Skirt6:setPos(0, 2.5)
					models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3.Skirt4.Skirt5.Skirt6:setScale(1.05, 1, 1.05)
				end
			else
				models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2:setPos()
				models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3:setPos()
				models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3.Skirt4:setPos()
				models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3.Skirt4.Skirt5:setPos()
				models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3.Skirt4.Skirt5.Skirt6:setPos()
			end
		end,

		---メイド服Aのレンダー処理
		MaidARender = function ()
			local legAngle = math.abs(vanilla_model.RIGHT_LEG:getOriginRot().x) / 80
			models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2:setScale(1, 1, 1 + 0.1 * legAngle)
			models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3:setScale(1, 1, 1 + 0.09 * legAngle)
			models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3.Skirt4:setScale(1, 1, 1 + 0.05 * legAngle)
			models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3.Skirt4.Skirt5:setScale(1, 1, 1 + 0.05 * legAngle)
			models.models.main.Avatar.UpperBody.Body.CMaidAB.Skirt2.Skirt3.Skirt4.Skirt5.Skirt6:setScale(1, 1, 1 + 0.02 * legAngle)
		end,

		---メイド服Bのチック処理
		MaidBTick = function ()
			models.models.main.Avatar.UpperBody.Body.CMaidBB:setRot(player:getPose() == "CROUCHING" and 27.5 or 0, 0, 0)
			if player:getVehicle() then
				if not Armor.ArmorVisible[3] then
					models.models.main.Avatar.UpperBody.Body.CMaidBB.Skirt2:setPos(0, 2.5)
					models.models.main.Avatar.UpperBody.Body.CMaidBB.Skirt2:setScale(1.05, 1, 1.2)
					models.models.main.Avatar.UpperBody.Body.CMaidBB.Skirt2.Skirt3:setPos(0, 2.5)
					models.models.main.Avatar.UpperBody.Body.CMaidBB.Skirt2.Skirt3:setScale(1.05, 1, 1.2)
					models.models.main.Avatar.UpperBody.Body.CMaidBB.Skirt2.Skirt3.Skirt4:setPos(0, 2.5)
					models.models.main.Avatar.UpperBody.Body.CMaidBB.Skirt2.Skirt3.Skirt4:setScale(1.05, 1, 1.2)
				end
			else
				models.models.main.Avatar.UpperBody.Body.CMaidBB.Skirt2:setPos()
				models.models.main.Avatar.UpperBody.Body.CMaidBB.Skirt2.Skirt3:setPos()
				models.models.main.Avatar.UpperBody.Body.CMaidBB.Skirt2.Skirt3.Skirt4:setPos()
			end
		end,

		---メイド服Bのレンダー処理
		MaidBRender = function ()
			local legAngle = math.abs(vanilla_model.RIGHT_LEG:getOriginRot().x) / 80
			models.models.main.Avatar.UpperBody.Body.CMaidBB:setScale(1, 1, 1 + 0.5 * legAngle)
			models.models.main.Avatar.UpperBody.Body.CMaidBB.Skirt2:setScale(1, 1, 1 + 0.25 * legAngle)
			models.models.main.Avatar.UpperBody.Body.CMaidBB.Skirt2.Skirt3:setScale(1, 1, 1 + 0.15 * legAngle)
			models.models.main.Avatar.UpperBody.Body.CMaidBB.Skirt2.Skirt3.Skirt4:setScale(1, 1, 1 + 0.1 * legAngle)
		end,

		---ポンポンのチック処理
		PonPonTick = function ()
			if not ActionWheel.IsAnimationPlaying then
				local leftHanded = player:isLeftHanded()
				models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.CCheerleaderRAB:setVisible(player:getHeldItem(leftHanded).id == "minecraft:air" and (not Umbrella.IsUsing or not leftHanded))
				models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.CCheerleaderLAB:setVisible(player:getHeldItem(not leftHanded).id == "minecraft:air" and (not Umbrella.IsUsing or leftHanded))
			else
				for _, modelPart in ipairs({models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.CCheerleaderRAB,  models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.CCheerleaderLAB}) do
					modelPart:setVisible(false)
				end
			end
		end,

		---浴衣のチック処理
		YukataTick = function ()
			if Costume.CurrentCostume == "YUKATA" then
				local helmetItemID = player:getItem(6).id
				models.models.main.Avatar.Head.CFoxMaskH:setVisible(helmetItemID:find("^minecraft:.+_helmet$") ~= nil and not Armor.ArmorVisible[1])
				models.models.main.Avatar.Head.CFoxMaskH:setPrimaryTexture("RESOURCE", (helmetItemID == "minecraft:leather_helmet" or helmetItemID == "minecraft:chainmail_helmet" or helmetItemID == "minecraft:iron_helmet") and "textures/entity/fox/fox.png" or "textures/entity/fox/snow_fox.png")
			end
		end,

		---ミニスカートのチック処理
		MiniskirtTick = function ()
			local crouching = player:getPose() == "CROUCHING"
			models.models.main.Avatar.UpperBody.Body.CMiniSkirtB:setRot((crouching or player:getVehicle()) and 27.5 or 0, 0, 0)
			models.models.main.Avatar.UpperBody.Body.CMiniSkirtB:setPos(0, 0, crouching and 1.25 or 0)
		end,

		---ハロウィン衣装のレンダー処理
		HalloweenRender = function ()
			local legRot = math.map(vanilla_model.RIGHT_LEG:getOriginRot().x, -90, 90, 0, 30)
			models.models.main.Avatar.UpperBody.Body.CHalloweenB.BatWingLeftPivot:setRot(0, legRot)
			models.models.main.Avatar.UpperBody.Body.CHalloweenB.BatWingRightPivot:setRot(0, -legRot)
		end
	},

	---メインモデルのテクスチャのオフセット値を設定する。
	---@param offset integer オフセット値
	setCostumeTextureOffset = function (offset)
		for _, modelPart in ipairs({models.models.main.Avatar.UpperBody.Body.Body, models.models.main.Avatar.UpperBody.Body.BodyLayer, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArm, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmLayer, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightArmBottom, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightArmBottomLayer, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArm, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmLayer, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftArmBottom, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftArmBottomLayer, models.models.main.Avatar.LowerBody.Legs.RightLeg.RightLeg, models.models.main.Avatar.LowerBody.Legs.RightLeg.RightLegLayer, models.models.main.Avatar.LowerBody.Legs.RightLeg.RightLegBottom.RightLegBottom, models.models.main.Avatar.LowerBody.Legs.RightLeg.RightLegBottom.RightLegBottomLayer, models.models.main.Avatar.LowerBody.Legs.LeftLeg.LeftLeg, models.models.main.Avatar.LowerBody.Legs.LeftLeg.LeftLegLayer, models.models.main.Avatar.LowerBody.Legs.LeftLeg.LeftLegBottom.LeftLegBottom, models.models.main.Avatar.LowerBody.Legs.LeftLeg.LeftLegBottom.LeftLegBottomLayer, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightSleeveBase.RightSleeveBase, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightSleeveBase.RightSleeve.RightSleeve, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftSleeveBase.LeftSleeveBase, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftSleeveBase.LeftSleeve.LeftSleeve}) do
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
			Sleeve.enable()
			Apron.disable()
		elseif costume == "DISGUISE" then
			local earVisible = player:getItem(6).id == "minecraft:chainmail_helmet"
			models.models.main.Avatar.Head.Ears:setVisible(earVisible)
			models.models.main.Avatar.Head.CFoxHoodH:setVisible(not Armor.ArmorVisible[1])
			models.models.main.Avatar.UpperBody.Body.Hairs.BackHair:setVisible(Armor.ArmorVisible[1])
			Apron.disable()
			Costume.setCostumeTextureOffset(2)
			models.models.main.Avatar.Head.CFoxHoodH:setUVPixels(0, 0)
		elseif costume == "MAID_A" then
			models.models.main.Avatar.Head.CMaidBrimH:setVisible(not Armor.ArmorVisible[1])
			models.models.main.Avatar.UpperBody.Body.CMaidAB:setVisible(not Armor.ArmorVisible[3] and not (Kotatsu and Kotatsu.IsAnimationPlaying or false))
			Costume.setCostumeTextureOffset(3)
			events.TICK:register(Costume.CostumeEvents.MaidATick, "costume_maid_a_tick")
			events.RENDER:register(Costume.CostumeEvents.MaidARender, "costume_maid_a_render")
			Apron.disable()
			Legs.ReducedLegSwing = true
		elseif costume == "MAID_B" then
			models.models.main.Avatar.Head.CMaidBrimH:setVisible(not Armor.ArmorVisible[1])
			models.models.main.Avatar.UpperBody.Body.CMaidBB:setVisible(not Armor.ArmorVisible[3] and not (Kotatsu and Kotatsu.IsAnimationPlaying or false))
			Sleeve.enable()
			Costume.setCostumeTextureOffset(4)
			events.TICK:register(Costume.CostumeEvents.MaidBTick, "costume_maid_b_tick")
			events.RENDER:register(Costume.CostumeEvents.MaidBRender, "costume_maid_b_render")
			Apron.disable()
			Legs.ReducedLegSwing = true
		elseif costume == "SWIMSUIT" then
			models.models.main.Avatar.UpperBody.Body.Hairs.BackHair:setVisible(Armor.ArmorVisible[1])
			models.models.main.Avatar.Head.CSwimsuitH:setVisible(not Armor.ArmorVisible[1])
			Costume.setCostumeTextureOffset(5)
			Apron.disable()
		elseif costume == "CHEERLEADER" then
			models.models.main.Avatar.UpperBody.Body.CMiniSkirtB:setVisible(not Armor.ArmorVisible[3] and not (Kotatsu and Kotatsu.IsAnimationPlaying or false))
			Costume.setCostumeTextureOffset(6)
			models.models.main.Avatar.UpperBody.Body.CMiniSkirtB:setUVPixels(0, 0)
			events.TICK:register(Costume.CostumeEvents.PonPonTick, "costume_ponpon_tick")
			events.TICK:register(Costume.CostumeEvents.MiniskirtTick, "costume_miniskirt_tick")
			Apron.disable()
		elseif costume == "PURIFICATION" then
			Costume.setCostumeTextureOffset(7)
			Sleeve.enable()
			Apron.disable()
		elseif costume == "KAPPOGI" then
			Costume.setCostumeTextureOffset(8)
			models.models.main.Avatar.LowerBody.Apron:setUVPixels(16, 0)
		elseif costume == "YUKATA" then
			events.TICK:register(Costume.CostumeEvents.YukataTick, "costume_yukata_tick")
			Costume.setCostumeTextureOffset(9)
			Sleeve.enable()
			Apron.disable()
		elseif costume == "KNIT" then
			models.models.main.Avatar.Head.Ears:setVisible(player:getItem(6).id == "minecraft:chainmail_helmet")
			models.models.main.Avatar.Head.CKnitH:setVisible(not Armor.ArmorVisible[1])
		elseif costume == "FOX_HOODIE_RED" then
			models.models.main.Avatar.Head.Ears:setVisible(player:getItem(6).id == "minecraft:chainmail_helmet")
			models.models.main.Avatar.UpperBody.Body.Hairs.BackHair:setVisible(Armor.ArmorVisible[1])
			models.models.main.Avatar.Head.CFoxHoodH:setVisible(not Armor.ArmorVisible[1])
			Costume.setCostumeTextureOffset(10)
			models.models.main.Avatar.Head.CFoxHoodH:setUVPixels(0, 8)
			Apron.disable()
		elseif costume == "FOX_HOODIE_WHITE" then
			models.models.main.Avatar.Head.Ears:setVisible(player:getItem(6).id == "minecraft:chainmail_helmet")
			models.models.main.Avatar.UpperBody.Body.Hairs.BackHair:setVisible(Armor.ArmorVisible[1])
			models.models.main.Avatar.Head.CFoxHoodH:setVisible(not Armor.ArmorVisible[1])
			Costume.setCostumeTextureOffset(11)
			models.models.main.Avatar.Head.CFoxHoodH:setUVPixels(0, 16)
			Apron.disable()
		elseif costume == "TRACKSUIT" then
			Costume.setCostumeTextureOffset(12)
			Apron.disable()
		elseif costume == "CASUAL" then
			local earVisible = player:getItem(6).id == "minecraft:chainmail_helmet"
			models.models.main.Avatar.Head.Ears:setVisible(earVisible)
			models.models.main.Avatar.Head.CBeretH:setVisible(not Armor.ArmorVisible[1])
			Costume.setCostumeTextureOffset(13)
			Ears.EnableJerkEar = earVisible
			Apron.disable()
		elseif costume == "SAILOR" then
			models.models.main.Avatar.UpperBody.Body.CMiniSkirtB:setVisible(not Armor.ArmorVisible[3] and not (Kotatsu and Kotatsu.IsAnimationPlaying or false))
			Costume.setCostumeTextureOffset(14)
			models.models.main.Avatar.UpperBody.Body.CMiniSkirtB:setUVPixels(0, 14)
			events.TICK:register(Costume.CostumeEvents.MiniskirtTick, "costume_miniskirt_tick")
			Apron.disable()
		elseif costume == "CHINA_DRESS" then
			Costume.setCostumeTextureOffset(15)
			Apron.disable()
		elseif costume == "SANTA" then
			models.models.main.Avatar.Head.Ears.LeftEarPivot:setVisible(player:getItem(6).id == "minecraft:chainmail_helmet")
			models.models.main.Avatar.Head.CSantaH:setVisible(not Armor.ArmorVisible[1])
			Costume.setCostumeTextureOffset(18)
		elseif costume == "KIMONO" then
			models.models.main.Avatar.Head.CKimonoH:setVisible(true)
			models.models.main.Avatar.UpperBody.Body.UmbrellaB:setUVPixels(0, 27)
			Costume.setCostumeTextureOffset(16)
			Apron.disable()
		elseif costume == "HALLOWEEN" then
			models.models.main.Avatar.Head.CHalloweenH:setVisible(not Armor.ArmorVisible[1])
			models.models.main.Avatar.UpperBody.Body.CHalloweenB:setVisible(not Armor.ArmorVisible[3])
			models.models.main.Avatar.UpperBody.Body.CMiniSkirtB:setVisible(not Armor.ArmorVisible[3] and not (Kotatsu and Kotatsu.IsAnimationPlaying or false))
			Sleeve.disable()
			for _, modelPart in ipairs({models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightSleeveBase.RightSleeve.RightSleeveRibbon, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftSleeveBase.LeftSleeve.LeftSleeveRibbon}) do
				modelPart:setVisible(false)
			end
			Costume.setCostumeTextureOffset(17)
			models.models.main.Avatar.UpperBody.Body.CMiniSkirtB:setUVPixels(0, 28)
			models.models.main.Avatar.UpperBody.Body.CHalloweenB:setPos(0, 0, Armor.ArmorVisible[2] and 1 or 0)
			events.TICK:register(Costume.CostumeEvents.MiniskirtTick, "costume_miniskirt_tick")
			events.RENDER:register(Costume.CostumeEvents.HalloweenRender, "costume_halloween_render")
			Apron.disable()

		end
	end,

	---コスチュームをリセットし、デフォルトのコスチュームにする。
	resetCostume = function ()
		for _, modelPart in ipairs({models.models.main.Avatar.Head, models.models.main.Avatar.UpperBody.Body.Hairs.BackHair}) do
			modelPart:setVisible(true)
		end
		for _, modelPart in ipairs({models.models.main.Avatar.Head.CMaidBrimH, models.models.main.Avatar.UpperBody.Body.CMaidAB, models.models.main.Avatar.UpperBody.Body.CMaidBB, models.models.main.Avatar.UpperBody.Body.CMiniSkirtB, models.models.main.Avatar.Head.CSwimsuitH, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.CCheerleaderRAB,  models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.CCheerleaderLAB, models.models.main.Avatar.Head.CFoxMaskH, models.models.main.Avatar.Head.CKnitH, models.models.main.Avatar.Head.CFoxHoodH, models.models.main.Avatar.Head.CBeretH, models.models.main.Avatar.Head.CSantaH, models.models.main.Avatar.Head.CKimonoH, models.models.main.Avatar.Head.CHalloweenH, models.models.main.Avatar.UpperBody.Body.CHalloweenB}) do
			modelPart:setVisible(false)
		end
		models.models.main.Avatar.Head.Ears:setVisible(not Armor.ArmorVisible[1])
		models.models.main.Avatar.Head.Ears.LeftEarPivot:setVisible()
		for _, modelPart in ipairs({models.models.main.Avatar.LowerBody.Apron, models.models.main.Avatar.UpperBody.Body.UmbrellaB}) do
			modelPart:setUVPixels()
		end
		for _, tickEventName in ipairs({"costume_maid_a_tick", "costume_maid_b_tick", "costume_miniskirt_tick", "costume_ponpon_tick", "costume_yukata_tick"}) do
			events.TICK:remove(tickEventName)
		end
		for _, renderEventName in ipairs({"costume_maid_a_render", "costume_maid_b_render", "costume_halloween_render"}) do
			events.RENDER:remove(renderEventName)
		end
		Costume.setCostumeTextureOffset(0)
		Sleeve.enable()
		Apron.enable()
		Legs.ReducedLegSwing = false
		Ears.EnableJerkEar = true
		Costume.CurrentCostume = "DEFAULT"
	end,

	---防具が更新された時にArmorから呼び出される関数
	---@param armorIndex integer 防具のインデックス: 1. ヘルメット, 2. チェストプレート, 3. レギンス, 4. ブーツ
	onArmorChenge = function (armorIndex)
		if armorIndex == 1 then
			if Armor.ArmorVisible[1] then
				models.models.main.Avatar.Head.Ears:setVisible(player:getItem(6).id == "minecraft:chainmail_helmet")
				models.models.main.Avatar.Head.Ears.LeftEarPivot:setVisible()
				models.models.main.Avatar.UpperBody.Body.Hairs.BackHair:setVisible(true)
				for _, modelPart in ipairs({models.models.main.Avatar.Head.CMaidBrimH, models.models.main.Avatar.Head.CSwimsuitH, models.models.main.Avatar.Head.CFoxMaskH, models.models.main.Avatar.Head.CKnitH, models.models.main.Avatar.Head.CFoxHoodH, models.models.main.Avatar.Head.CBeretH, models.models.main.Avatar.Head.CSantaH, models.models.main.Avatar.Head.CHalloweenH}) do
					modelPart:setVisible(false)
				end
				events.RENDER:remove("costume_yukata_tick")
				Ears.EnableJerkEar = true
			else
				if Costume.CurrentCostume == "NIGHTWEAR" then
					models.models.main.Avatar.Head.Ears:setVisible(Sleep.HeadVisible)
				elseif Costume.CurrentCostume == "MAID_A" or Costume.CurrentCostume == "MAID_B" then
					for _, modelPart in ipairs({models.models.main.Avatar.Head.Ears, models.models.main.Avatar.Head.CMaidBrimH}) do
						modelPart:setVisible(true)
					end
				elseif Costume.CurrentCostume == "SWIMSUIT" then
					for _, modelPart in ipairs({models.models.main.Avatar.Head.Ears, models.models.main.Avatar.Head.CSwimsuitH}) do
						modelPart:setVisible(true)
					end
					models.models.main.Avatar.UpperBody.Body.Hairs.BackHair:setVisible(false)
				elseif Costume.CurrentCostume == "YUKATA" then
					models.models.main.Avatar.Head.Ears:setVisible(true)
					events.TICK:register(Costume.CostumeEvents.YukataTick, "costume_yukata_tick")
				elseif Costume.CurrentCostume == "KNIT" then
					models.models.main.Avatar.Head.Ears:setVisible(false)
					models.models.main.Avatar.Head.CKnitH:setVisible(true)
				elseif Costume.CurrentCostume == "DISGUISE" or Costume.CurrentCostume == "FOX_HOODIE_RED" or Costume.CurrentCostume == "FOX_HOODIE_WHITE" then
					for _, modelPart in ipairs({models.models.main.Avatar.Head.Ears, models.models.main.Avatar.UpperBody.Body.Hairs.BackHair}) do
						modelPart:setVisible(false)
					end
					models.models.main.Avatar.Head.CFoxHoodH:setVisible(true)
				elseif Costume.CurrentCostume == "CASUAL" then
					models.models.main.Avatar.Head.Ears:setVisible(false)
					models.models.main.Avatar.Head.CBeretH:setVisible(true)
					Ears.EnableJerkEar = false
				elseif Costume.CurrentCostume == "SANTA" then
					for _, modelPart in ipairs({models.models.main.Avatar.Head.Ears, models.models.main.Avatar.Head.CSantaH}) do
						modelPart:setVisible(true)
					end
					models.models.main.Avatar.Head.Ears.LeftEarPivot:setVisible(false)
				elseif Costume.CurrentCostume == "KIMONO" then
					models.models.main.Avatar.Head.Ears:setVisible(true)
				elseif Costume.CurrentCostume == "HALLOWEEN" then
					models.models.main.Avatar.Head.CHalloweenH:setVisible(true)
				else
					models.models.main.Avatar.Head.Ears:setVisible(true)
				end
			end
		elseif armorIndex == 2 then
			if Armor.ArmorVisible[2] then
				models.models.main.Avatar.UpperBody.Body.Tail.CDisguiseT:setVisible(false)
				models.models.main.Avatar.UpperBody.Body.Hairs.FrontHair:setPos(0, 0, Armor.ArmorVisible[2] and -1 or 0)
				models.models.main.Avatar.UpperBody.Body.Hairs.BackHair:setPos(0, 0, Armor.ArmorVisible[2] and 1 or 0)
				models.models.main.Avatar.UpperBody.Body.CHalloweenB:setPos(0, 0, 1)
			else
				if Costume.CurrentCostume == "DISGUISE" then
					models.models.main.Avatar.UpperBody.Body.Tail.CDisguiseT:setVisible(true)
				end
				models.models.main.Avatar.UpperBody.Body.CHalloweenB:setPos()
			end
		elseif armorIndex == 3 then
			if Armor.ArmorVisible[3] then
				for _, modelPart in ipairs({models.models.main.Avatar.UpperBody.Body.CMaidAB, models.models.main.Avatar.UpperBody.Body.CMaidBB, models.models.main.Avatar.UpperBody.Body.CMiniSkirtB}) do
					modelPart:setVisible(false)
				end
				for _, tickEventName in ipairs({"costume_maid_a_tick", "costume_maid_b_tick", "costume_miniskirt_tick"}) do
					events.TICK:remove(tickEventName)
				end
				for _, renderEventName in ipairs({"costume_maid_a_render", "costume_maid_b_render"}) do
					events.RENDER:remove(renderEventName)
				end
				Apron.disable()
				Legs.ReducedLegSwing = false
			else
				if Costume.CurrentCostume == "MAID_A" then
					models.models.main.Avatar.UpperBody.Body.CMaidAB:setVisible(true)
					events.TICK:register(Costume.CostumeEvents.MaidATick, "costume_maid_a_tick")
					events.RENDER:register(Costume.CostumeEvents.MaidARender, "costume_maid_a_render")
				elseif Costume.CurrentCostume == "MAID_B" then
					models.models.main.Avatar.UpperBody.Body.CMaidBB:setVisible(true)
					events.TICK:register(Costume.CostumeEvents.MaidATick, "costume_maid_b_tick")
					events.RENDER:register(Costume.CostumeEvents.MaidARender, "costume_maid_b_render")
				elseif Costume.CurrentCostume == "CHEERLEADER" or Costume.CurrentCostume == "SAILOR" or Costume.CurrentCostume == "HALLOWEEN" then
					models.models.main.Avatar.UpperBody.Body.CMiniSkirtB:setVisible(true)
					events.TICK:register(Costume.CostumeEvents.MiniskirtTick, "costume_miniskirt_tick")
				elseif Costume.CurrentCostume == "DEFAULT" or Costume.CurrentCostume == "DISGUISE" or Costume.CurrentCostume == "KAPPOGI" or Costume.CurrentCostume == "KNIT" or Costume.CurrentCostume == "SANTA" then
					Apron.enable()
				end
				Legs.ReducedLegSwing = Costume.CurrentCostume == "MAID_A" or Costume.CurrentCostume == "MAID_B"
			end
		end
	end
}

local loadedData = Config.loadConfig("costume", 1)
if loadedData <= #Costume.CostumeList then
	Costume.CurrentCostume = string.upper(Costume.CostumeList[loadedData])
	if Costume.CurrentCostume ~= "DEFAULT" then
		Costume.setCostume(Costume.CurrentCostume)
	else
		Costume.resetCostume()
	end
else
	Costume.resetCostume()
	Config.saveConfig("costume", 1)
end

models.models.main.Avatar.Head.CHalloweenH:newBlock("halloween_pumpkin"):block("minecraft:carved_pumpkin"):pos(-5.5, 0.6, 7.5):rot(20, 90, 0):scale(0.15)

return Costume