events.ENTITY_INIT:register(function ()
	--クラスのインスタンス化
	General = require("scripts/general")
	LanguageClass = require("scripts/language")
	NameplateClass = require("scripts/nameplate")
	FacePartsClass = require("scripts/face_parts")
	TailClass = require("scripts/tail")
	EarsClass = require("scripts/ears")
	HurtClass = require("scripts/hurt")
	ActionWheelClass = require("scripts/action_wheel")
	SitDownClass = require("scripts/sit_down")
	EarpickClass = require("scripts/earpick")

	--初期化処理
	for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ARMOR}) do
		vanillaModel:setVisible(false)
	end
	for _, modelPart in ipairs({models.models.main.Avatar.RightLeg.RightLegBottom, models.models.main.Avatar.LeftLeg.LeftLegBottom}) do
		modelPart:setParentType("None")
	end
end)