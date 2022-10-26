---@class UmbrellaClass 傘を制御するクラス
---@field UmbrellaClass.EnableUmbrella boolean 傘をさしているかどうか
---@field EnableUmbrellaPrev boolean 前チックに傘をさしていたかどうか
---@field UmbrellaClass.UmbrellaSound boolean 傘の開閉音を再生するかどうか

UmbrellaClass = {}
UmbrellaClass.EnableUmbrella = false
EnableUmbrellaPrev = false
UmbrellaClass.UmbrellaSound = ConfigClass.UmbrellaSound

events.TICK:register(function ()
	local playerPose = player:getPose()
	local activeItem = player:getActiveItem()
	local mainHeldItem = player:getHeldItem()
	UmbrellaClass.EnableUmbrella = player:isInRain() and not player:isUnderwater() and activeItem.id ~= "minecraft:bow" and activeItem.id ~= "minecraft:crossbow" and (mainHeldItem.id ~= "minecraft:crossbow" or mainHeldItem.tag["Charged"] == 0) and not player:getVehicle() and playerPose ~= "FALL_FLYING" and playerPose ~= "SWIMMING" and player:getHeldItem(true).id == "minecraft:air" and not General.isAnimationPlaying("models.main", "broom_cleaning") and not General.isAnimationPlaying("models.main", "vacuum_cleaning") and not General.isAnimationPlaying("models.main", "cloth_cleaning") and not General.isAnimationPlaying("models.main", "hair_cut") and not General.isAnimationPlaying("models.main", "fox_jump") and not General.isAnimationPlaying("models.main", "tail_cuddling") and not General.isAnimationPlaying("models.main", "earpick") and not General.isAnimationPlaying("models.main", "tea_time") and not General.isAnimationPlaying("models.main", "massage")
	local umbrella = models.models.umbrella
	local rightArm = models.models.main.Avatar.Body.Arms.RightArm
	local leftArm = models.models.main.Avatar.Body.Arms.LeftArm
	local rightArmorArm = models.models.armor.Avatar.Body.Arms.RightArm
	local leftArmorArm = models.models.armor.Avatar.Body.Arms.LeftArm
	if UmbrellaClass.EnableUmbrella then
		if not EnableUmbrellaPrev and UmbrellaClass.UmbrellaSound then
			sounds:playSound("minecraft:entity.bat.takeoff", player:getPos(), 0.5, 1.5)
		end
		if player:isLeftHanded() then
			rightArm:setParentType("Body")
			leftArm:setParentType("LeftArm")
			if ArmorClass.ArmorVisible[2] then
				rightArmorArm:setParentType("Body")
				leftArmorArm:setParentType("LeftArm")
			end
			umbrella:setPos(5.5, 0, 0)
			General.setAnimations(General.isAnimationPlaying("models.main", "sit_down") and "PLAY" or "STOP", "sit_down_right_umbrella")
		else
			leftArm:setParentType("Body")
			rightArm:setParentType("RightArm")
			if ArmorClass.ArmorVisible[2] then
				leftArmorArm:setParentType("Body")
				rightArmorArm:setParentType("RightArm")
			end
			umbrella:setPos(-5.5, 0, 0)
			General.setAnimations(General.isAnimationPlaying("models.main", "sit_down") and "PLAY" or "STOP", "sit_down_left_umbrella")
		end
		umbrella:setVisible(true)
	else
		if EnableUmbrellaPrev and UmbrellaClass.UmbrellaSound then
			sounds:playSound("minecraft:entity.bat.takeoff", player:getPos(), 0.5, 1.5)
		end
		rightArm:setParentType("RightArm")
		leftArm:setParentType("LeftArm")
		if ArmorClass.ArmorVisible[2] then
			rightArmorArm:setParentType("RightArm")
			leftArmorArm:setParentType("LeftArm")
		end
		for _, animationName in ipairs({"sit_down_right_umbrella", "sit_down_left_umbrella"}) do
			General.setAnimations("STOP", animationName)
		end
		umbrella:setVisible(false)
	end
	EnableUmbrellaPrev = UmbrellaClass.EnableUmbrella
end)


return UmbrellaClass