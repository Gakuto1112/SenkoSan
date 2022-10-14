events.ENTITY_INIT:register(function ()
	--クラスのインスタンス化
	General = require("scripts/general")
	ConfigClass = require("scripts/config")
	LanguageClass = require("scripts/language")
	NameplateClass = require("scripts/nameplate")

	--パーツ別クラス
	ArmsClass = require("scripts/arms")
	LegsClass = require("scripts/legs")
	FacePartsClass = require("scripts/face_parts")
	GlassesClass = require("scripts/glasses")
	TailClass = require("scripts/tail")
	EarsClass = require("scripts/ears")
	ArmorClass = require("scripts/armor")

	--機能別クラス
	CostumeClass = require("scripts/costume")
	HurtClass = require("scripts/hurt")
	ActionWheelClass = require("scripts/action_wheel")
	BroomCleaningClass = require("scripts/broom_cleaning")
	VacuumCleaningClass = require("scripts/vacuum_cleaning")
	ClothCleaningClass = require("scripts/cloth_cleaning")
	SitDownClass = require("scripts/sit_down")
	EarpickClass = require("scripts/earpick")
	TeaTimeClass = require("scripts/tea_time")
	MassaseClass = require("scripts/massage")
	WetClass = require("scripts/wet")
	FoxFireClass = require("scripts/fox_fire")
	SleepClass = require("scripts/sleep")
	WardenClass = require("scripts/warden")

	--初期化処理
	for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ARMOR}) do
		vanillaModel:setVisible(false)
	end
	for _, modelPart in ipairs({models.models.main.Avatar.Body.BodyBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom}) do
		modelPart:setParentType("None")
	end
end)