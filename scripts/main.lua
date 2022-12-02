events.ENTITY_INIT:register(function ()
	--クラスのインスタンス化
	General = require("scripts/general")
	ConfigClass = require("scripts/config")
	LanguageClass = require("scripts/language")
	NameplateClass = require("scripts/nameplate")

	--抽象クラスの作成
	AnimationAction = require("scripts/animation_action")
	PermanentAnimationAction = require("scripts/permanent_animation_action")

	--パーツ別クラス
	ArmsClass = require("scripts/arms")
	LegsClass = require("scripts/legs")
	ApronClass = require("scripts/apron")
	FacePartsClass = require("scripts/face_parts")
	GlassesClass = require("scripts/glasses")
	PhysicsClass = require("scripts/physics")
	TailClass = require("scripts/tail")
	EarsClass = require("scripts/ears")
	HairAccessoryClass = require("scripts/hair_accessory")
	UmbrellaClass = require("scripts/umbrella")
	ArmorClass = require("scripts/armor")

	--機能別クラス
	CostumeClass = require("scripts/costume")
	HurtClass = require("scripts/hurt")
	ActionWheelClass = require("scripts/action_wheel")
	CameraClass = require("scripts/camera")
	BroomCleaning = require("scripts/broom_cleaning")
	VacuumCleaning = require("scripts/vacuum_cleaning")
	ClothCleaning = require("scripts/cloth_cleaning")
	HairCut = require("scripts/hair_cut")
	FoxJump = require("scripts/fox_jump")
	TailBrushClass = require("scripts/tail_brush")
	Kotatsu = require("scripts/kotatsu")
	SitDownClass = require("scripts/sit_down")
	TailCuddlingClass = require("scripts/tail_cuddling")
	EarpickClass = require("scripts/earpick")
	TeaTimeClass = require("scripts/tea_time")
	MassaseClass = require("scripts/massage")
	WetClass = require("scripts/wet")
	FoxFireClass = require("scripts/fox_fire")
	SleepClass = require("scripts/sleep")
	WardenClass = require("scripts/warden")
	ChristmasClass = require("scripts/christmas")

	--初期化処理
	for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ARMOR}) do
		vanillaModel:setVisible(false)
	end
	for _, modelPart in ipairs({models.models.main.Avatar.Body.BodyBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom}) do
		modelPart:setParentType("None")
	end
end)