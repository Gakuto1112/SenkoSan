events.ENTITY_INIT:register(function ()
	--クラスのインスタンス化
	General = require("scripts.general")
	Config = require("scripts.config")
	Language = require("scripts.language")

	--抽象クラス
	AnimationAction = require("scripts.actions.animation_action")
	PermanentAnimationAction = require("scripts.actions.permanent_animation_action")

	--パーツ別クラス
	Arms = require("scripts.arms")
	Legs = require("scripts.legs")
	Sleeve = require("scripts.sleeve")
	Apron = require("scripts.apron")
	FaceParts = require("scripts.face_parts")
	Physics = require("scripts.physics")
	Tail = require("scripts.tail")
	Ears = require("scripts.ears")
	HairAccessory = require("scripts.hair_accessory")
	Umbrella = require("scripts.umbrella")
	Armor = require("scripts.armor")
	Skull = require("scripts.skull")
	Nameplate = require("scripts.nameplate")

	--機能別クラス
	Costume = require("scripts.costume")
	Hurt = require("scripts.hurt")
	ActionWheel = require("scripts.action_wheel")
	Camera = require("scripts.camera")
	RefuseEmote = require("scripts.actions.refuse_emote")
	Smile = require("scripts.actions.smile")
	ShakeBody = require("scripts.actions.shake_body")
	BroomCleaning = require("scripts.actions.broom_cleaning")
	VacuumCleaning = require("scripts.actions.vacuum_cleaning")
	ClothCleaning = require("scripts.actions.cloth_cleaning")
	HairCut = require("scripts.actions.hair_cut")
	FoxJump = require("scripts.actions.fox_jump")
	TailBrush = require("scripts.actions.tail_brush")
	Kotatsu = require("scripts.actions.kotatsu")
	SitDown = require("scripts.actions.sit_down")
	TailCuddling = require("scripts.actions.tail_cuddling")
	EarCuddling = require("scripts.actions.ear_cuddling")
	Earpick = require("scripts.actions.earpick")
	TeaTime = require("scripts.actions.tea_time")
	Massage = require("scripts.actions.massage")
	PhotoPose = require("scripts.photo_pose")
	Wet = require("scripts.wet")
	FoxFire = require("scripts.fox_fire")
	Sleep = require("scripts.sleep")
	Warden = require("scripts.warden")
	Afk = require("scripts.afk")
	Christmas = require("scripts.christmas")

	--その他初期化処理
	events.TICK:register(function ()
		--エリトラ
		if player:getItem(5).id == "minecraft:elytra" then
			local playerPose = player:getPose()
			vanilla_model.ELYTRA:setVisible((not ActionWheel.IsAnimationPlaying or playerPose == "FALL_FLYING") and not SitDown.IsAnimationPlaying and not Kotatsu.IsAnimationPlaying and PhotoPose.CurrentPose == 0 and playerPose ~= "SLEEPING")
		end

		--ヤギの角笛
		if player:getActiveItem().id == "minecraft:goat_horn" then
			FaceParts.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 1, true)
		end
	end)

	--バニラモデルの非表示
	for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ARMOR}) do
		vanillaModel:setVisible(false)
	end
	for _, modelPart in ipairs({models.models.main.Avatar.Body.BodyBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom}) do
		modelPart:setParentType("None")
	end

	--ダミープレイヤーのスキン設定
	models.models.dummy_player:setPrimaryTexture("SKIN")
	for _, modelPart in ipairs(player:getModelType() == "DEFAULT" and {models.models.dummy_player.DummyPlayer.Body.RightArm.RightArmSlim, models.models.dummy_player.DummyPlayer.Body.LeftArm.LeftArmSlim} or {models.models.dummy_player.DummyPlayer.Body.RightArm.RightArmClassic, models.models.dummy_player.DummyPlayer.Body.LeftArm.LeftArmClassic}) do
		modelPart:setVisible(false)
	end
end)