events.ENTITY_INIT:register(function ()
	--クラスのインスタンス化
	Config = require("scripts.config")
	Language = require("scripts.language")
	KeyManager = require("scripts.key_manager")
	StringUtils = require("scripts.string_utils")
	CompatibilityUtils = require("scripts.compatibility_utils")

	--抽象クラス
	AnimationAction = require("scripts.actions.animation_action")
	PermanentAnimationAction = require("scripts.actions.permanent_animation_action")
	EmotionAction = require("scripts.actions.emotion_action")

	--パーツ別クラス
	require("scripts.vanilla_model")
	Arms = require("scripts.arms")
	Sleeve = require("scripts.sleeve")
	Hem = require("scripts.hem")
	FaceParts = require("scripts.face_parts")
	Physics = require("scripts.physics")
	Tail = require("scripts.tail")
	Ears = require("scripts.ears")
	Naginata = require("scripts.naginata")
	Umbrella = require("scripts.umbrella")
	Armor = require("scripts.armor")
	Nameplate = require("scripts.nameplate")
	Portrait = require("scripts.portrait")

	--機能別クラス
	UpdateChecker = require("scripts.update_checker")
	ActionWheel = require("scripts.action_wheel")
	Camera = require("scripts.camera")
	SitDown = require("scripts.actions.sit_down")
	require("scripts.emote_keys")
	KeyEmoteUp = require("scripts.actions.key_emote_up")
	KeyEmoteRight = require("scripts.actions.key_emote_right")
	KeyEmoteDown = require("scripts.actions.key_emote_down")
	KeyEmoteLeft = require("scripts.actions.key_emote_left")
	FoxFireManager = require("scripts.fox_fire.fox_fire_manager")
	Sleep = require("scripts.sleep")
	require("scripts.afk")
end)

--ENTITY_INITを待たず読み込むクラス
General = require("scripts.general")
Skull = require("scripts.skull")