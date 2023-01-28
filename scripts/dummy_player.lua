---@class DummyPlayer アニメーションで使用するダミーのプレイヤーを管理するクラス

models.models.dummy_player:setVisible(false)
models.models.dummy_player:setPrimaryTexture("SKIN")
for _, modelPart in ipairs(player:getModelType() == "DEFAULT" and {models.models.dummy_player.DummyPlayer.Body.RightArm.RightArmSlim, models.models.dummy_player.DummyPlayer.Body.LeftArm.LeftArmSlim} or {models.models.dummy_player.DummyPlayer.Body.RightArm.RightArmClassic, models.models.dummy_player.DummyPlayer.Body.LeftArm.LyingPlayerLeftArmClassic}) do
	modelPart:setVisible(false)
end