---@class PhotoPose 撮影用ポージングのクラス
---@field PhotoPose.CanPosing boolean ポーズ可能かどうか
---@field PhotoPose.PosingChecked boolean このチックでポーズ可能かどうかを確認したかどうか
---@field PhotoPose.CurrentPose integer 現在のポーズ（0 = ポーズ中ではない）

PhotoPose = {
    CanPosing = false,
    PosingChecked = false,
    CurrentPose = 0,

    ---撮影用ポーズが可能か確認する。
    check = function ()
        if not PhotoPose.PosingChecked then
            PhotoPose.CanPosing = BroomCleaning:checkAction() and not ActionWheel.IsAnimationPlaying
            PhotoPose.PosingChecked = true
        end
        return PhotoPose.CanPosing
    end,

    ---撮影用にポーズをとる。
    ---@param poseID integer とるポーズのID
    setPose = function (poseID)
        if PhotoPose.check() then
            if PhotoPose.CurrentPose ~= 0 then
                PhotoPose.stopPose()
            end
            animations["models.main"]["photo_"..poseID]:play()
            Arms.hideHeldItem(true)
            Sleeve.Moving = false
            PhotoPose.CurrentPose = poseID
        end
    end,

    ---撮影用ポーズを終了する。
    stopPose = function ()
        animations["models.main"]["photo_"..PhotoPose.CurrentPose]:stop()
        Arms.hideHeldItem(false)
        Sleeve.Moving = true
        ActionWheel.untogglePose(PhotoPose.CurrentPose)
        PhotoPose.CurrentPose = 0
    end
}

events.TICK:register(function ()
    if PhotoPose.CurrentPose ~= 0 then
        if PhotoPose.CurrentPose == 1 then
            if General.PlayerCondition == "LOW" then
                FaceParts.setEmotion("TIRED", "TIRED", "OPENED", 1, true)
            else
                FaceParts.setEmotion("NORMAL", "NORMAL", "OPENED", 1, true)
            end
        elseif PhotoPose.CurrentPose == 2 then
            FaceParts.setEmotion("CLOSED", "CLOSED", "CLOSED", 1, true)
        end
        if not PhotoPose.check() then
            PhotoPose.stopPose()
        end
    end
    PhotoPose.PosingChecked = false
    PhotoPose.IsPosingPrev = PhotoPose.CurrentPose ~= 0
end)

return PhotoPose