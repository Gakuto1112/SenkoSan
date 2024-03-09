---@class Elytra エリトラの表示を管理するクラス

events.TICK:register(function ()
    if player:getItem(5).id == "minecraft:elytra" then
        local playerPose = player:getPose()
        ---@diagnostic disable-next-line: undefined-field
        vanilla_model.ELYTRA:setVisible((not ActionWheel.IsAnimationPlaying or playerPose == "FALL_FLYING") and not SitDown.IsAnimationPlaying and not Kotatsu.IsAnimationPlaying and PhotoPose.CurrentPose == 0 and playerPose ~= "SLEEPING")
    end
end)