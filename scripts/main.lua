events.ENTITY_INIT:register(function ()
	--クラスのインスタンス化
	FacePartsClass = require("scripts/face_parts")

	--初期化処理
	vanilla_model.PLAYER:setVisible(false)
end)