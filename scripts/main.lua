events.ENTITY_INIT:register(function ()
	--クラスのインスタンス化
	General = require("scripts/general")
	NameplateClass = require("scripts/nameplate")
	FacePartsClass = require("scripts/face_parts")
	TailPhysicsClass = require("scripts/tail_physics")
	EarsClass = require("scripts/ears")
	HurtClass = require("scripts/hurt")
	LanguageClass = require("scripts/language")
	ActionWheelClass = require("scripts/action_wheel")
	SitDownClass = require("scripts/sit_down")
	EarpickClass = require("scripts/earpick")

	--初期化処理
	vanilla_model.PLAYER:setVisible(false)
	for _, modelPart in ipairs({models.models.main.Avatar.RightLeg.RightLegBottom, models.models.main.Avatar.LeftLeg.LeftLegBottom}) do
		modelPart:setParentType("None")
	end
end)