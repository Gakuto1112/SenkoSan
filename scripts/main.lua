events.ENTITY_INIT:register(function ()
	--クラスのインスタンス化
	FacePartsClass = require("scripts/face_parts")
	TailPhysicsClass = require("scripts/tail_physics")

	--初期化処理
	vanilla_model.PLAYER:setVisible(false)
end)