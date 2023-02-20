---@class PhotoPose 撮影用ポージングのクラス
---@field PhotoPose.CanPosing boolean ポーズ可能かどうか
---@field PhotoPose.PosingChecked boolean このチックでポーズ可能かどうかを確認したかどうか
---@field PhotoPose.CurrentPose integer 現在のポーズ（0 = ポーズ中ではない）
---@field PhotoPose.FacePartList table ポーズ中の表情のリスト

PhotoPose = {
    CanPosing = false,
    PosingChecked = false,
    CurrentPose = 0,
    FacePartList = {},

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
                animations["models.main"]["photo_"..PhotoPose.CurrentPose]:stop()
            end
            animations["models.main"]["photo_"..poseID]:play()
        end
    end
}

events.TICK:register(function ()
    if PhotoPose.CurrentPose ~= 0 then
        if PhotoPose.FacePartList[PhotoPose.CurrentPose] then
            FaceParts.setEmotion(PhotoPose.FacePartList[PhotoPose.CurrentPose][1], PhotoPose.FacePartList[PhotoPose.CurrentPose][2], PhotoPose.FacePartList[PhotoPose.CurrentPose][3], 1, true)
        end
        if not PhotoPose.check() then
            animations["models.main"]["photo_"..PhotoPose.CurrentPose]:stop()
            PhotoPose.CurrentPose = 0
        end
    end
    PhotoPose.PosingChecked = false
end)

return PhotoPose