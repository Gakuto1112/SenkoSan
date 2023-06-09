---@class PhotoPose 撮影用ポージングのクラス
---@field CanPosing boolean ポーズ可能かどうか
---@field PosingChecked boolean このチックでポーズ可能かどうかを確認したかどうか
---@field CurrentPose integer 現在のポーズ（0 = ポーズ中ではない）
PhotoPose = {
    CanPosing = false,
    PosingChecked = false,
    CurrentPose = 0,

    ---撮影用ポーズが可能か確認する。
    check = function ()
        if not PhotoPose.PosingChecked then
            PhotoPose.CanPosing = player:getPose() == "STANDING" and not player:isInWater() and not player:isInLava() and player:getFrozenTicks() == 0 and not player:getVehicle() and player:getVelocity():length() < 0.001 and Hurt.Damaged == "NONE" and not Warden.WardenNearby and not SitDown.IsAnimationPlaying and not player:isUsingItem() and not Kotatsu.IsAnimationPlaying and not ActionWheel.IsAnimationPlaying
            PhotoPose.PosingChecked = true
        end
        return PhotoPose.CanPosing
    end,

    ---撮影用にポーズをとる。
    ---@param poseID integer とるポーズのID
    setPose = function (poseID)
        if PhotoPose.check() then
            PhotoPose.stopPose()
            if poseID == 7 then
                models.models.main.Avatar:setRot(0, 15)
                models.models.main.Avatar.Head:setRot(0, -15)
                Arms.RightArmRotOffset = vectors.vec3(39.13, 57.07, 7.78)
                models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom:setRot(50)
                Sleeve.RightSleeveRotOffset = vectors.vec3(7.5)
                Arms.LeftArmRotOffset = vectors.vec3(12.5, -47.5)
                models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom:setRot(50)
                Sleeve.LeftSleeveRotOffset = vectors.vec3(28)
                Apron.RotOffset = vectors.vec3(7.5)
                Legs.RightLegRotOffset = vectors.vec3(0, 15)
                Legs.LeftLegRotOffset = vectors.vec3(-5)
                models.models.main.Avatar.Body.UmbrellaB:setPos(1.25, -2, -0.25)
                models.models.main.Avatar.Body.UmbrellaB:setRot(35.58, 12.7, -38.26)
            else
                if poseID == 1 then
                    models.models.main.Avatar:setRot(0, -10)
                    models.models.main.Avatar.Head:setRot(0, 10)
                    Arms.RightArmPosOffset = vectors.vec3(-1, -1)
                    Arms.RightArmRotOffset = vectors.vec3(45, -70)
                    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom:setRot(60)
                    Arms.LeftArmPosOffset = vectors.vec3(1, -1)
                    Arms.LeftArmRotOffset = vectors.vec3(45, 70)
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom:setRot(60)
                    Apron.RotOffset = vectors.vec3(10)
                    Legs.RightLegRotOffset = vectors.vec3(-5)
                    Legs.LeftLegRotOffset = vectors.vec3(2.58, -9.96, -0.88)
                elseif poseID == 2 then
                    models.models.main.Avatar:setPos(0, 0, 3)
                    models.models.main.Avatar:setRot(-15)
                    models.models.main.Avatar.Head:setRot(15)
                    Arms.RightArmRotOffset = vectors.vec3(45, 25)
                    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom:setRot(50)
                    Sleeve.RightSleeveRotOffset = vectors.vec3(5.08, 10, 0.88)
                    Arms.LeftArmRotOffset = vectors.vec3(45, -25)
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom:setRot(50)
                    Sleeve.LeftSleeveRotOffset = vectors.vec3(5.08, -10, -0.88)
                    models.models.main.Avatar.Body.BodyBottom.Legs:setRot(15)
                elseif poseID == 3 then
                    Arms.RightArmPosOffset = vectors.vec3(0, -1)
                    Arms.RightArmRotOffset = vectors.vec3(80, -10)
                    Sleeve.RightSleeveRotOffset = vectors.vec3(5.51, 59.9, 2.33)
                    Arms.LeftArmPosOffset = vectors.vec3(0, -1)
                    Arms.LeftArmRotOffset = vectors.vec3(80, 10)
                    Sleeve.LeftSleeveRotOffset = vectors.vec3(5.51, -59.9, 2.33)
                    Apron.RotOffset = vectors.vec3(5)
                    Legs.RightLegRotOffset = vectors.vec3(-5)
                    Legs.LeftLegRotOffset = vectors.vec3(5)
                elseif poseID == 4 then
                    Arms.RightArmRotOffset = vectors.vec3(71.95, -29.25, 50.25)
                    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom:setRot(50)
                    Sleeve.RightSleeveRotOffset = vectors.vec3(-62.94, -33.94, 20.26)
                    Arms.LeftArmRotOffset = vectors.vec3(60, 0, -37.5)
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom:setRot(50)
                    Sleeve.LeftSleeveRotOffset = vectors.vec3(-61.17, 18.75, -7.1)
                    Legs.LeftLegRotOffset = vectors.vec3(-10, -15)
                    models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom:setRot(-35)
                    models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom:setPivot(-2, 6, -2)
                elseif poseID == 5 then
                    models.models.main.Avatar.Head:setRot(0, 0, -5)
                    Arms.RightArmRotOffset = vectors.vec3(28.76, -24.65, 17.83)
                    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom:setRot(57.5)
                    Sleeve.RightSleeveRotOffset = vectors.vec3(-32.5, 10)
                    Arms.LeftArmRotOffset = vectors.vec3(69.35, 14.08, -5.24)
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom:setRot(65)
                    Sleeve.LeftSleeveRotOffset = vectors.vec3(-60, -50)
                    Physics.EnablePyhsics[1] = false
                    models.models.main.Avatar.Body.BodyBottom.Tail:setPos(5)
                    Physics.TailRotOffset = vectors.vec3(155.7, -0.73, -171.31)
                    Apron.RotOffset = vectors.vec3(10)
                    Legs.RightLegRotOffset = vectors.vec3(-19.72, 3.4, 9.41)
                    models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom:setRot(-20)
                    models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom:setPivot(2, 6, -2)
                    Legs.LeftLegRotOffset = vectors.vec3(5.04, -7.47, 0.67)
                    models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom:setRot(-10)
                    models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom:setPivot(-2, 6, -2)
                elseif poseID == 6 then
                    models.models.main.Avatar:setRot(0, -30)
                    models.models.main.Avatar.Head:setRot(0, 30)
                    Arms.RightArmRotOffset = vectors.vec3(151.92, -11.03, -19.73)
                    Sleeve.RightSleeveRotOffset = vectors.vec3(-40, 30)
                    Arms.LeftArmRotOffset = vectors.vec3(-37.5, -60)
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom:setRot(55)
                    Sleeve.LeftSleeveRotOffset = vectors.vec3(40)
                    Apron.RotOffset = vectors.vec3(22.5)
                    Legs.LeftLegRotOffset = vectors.vec3(25)
                    models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom:setRot(-95)
                end
                Umbrella.Enabled = false
            end
            Arms.hideHeldItem(true)
            Sleeve.Moving = false
            PhotoPose.CurrentPose = poseID
        end
    end,

    ---撮影用ポーズを終了する。
    stopPose = function ()
        for _, modelPart in ipairs({models.models.main.Avatar, models.models.main.Avatar.Body.BodyBottom.Tail}) do
            modelPart:setPos()
        end
        for _, modelPart in ipairs({models.models.main.Avatar, models.models.main.Avatar.Head, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom, models.models.main.Avatar.Body.BodyBottom.Legs, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom}) do
            modelPart:setRot()
        end
        Arms.RightArmPosOffset = vectors.vec3()
        Arms.RightArmRotOffset = vectors.vec3()
        Sleeve.RightSleeveRotOffset = vectors.vec3()
        Arms.LeftArmPosOffset = vectors.vec3()
        Arms.LeftArmRotOffset = vectors.vec3()
        Sleeve.LeftSleeveRotOffset = vectors.vec3()
        Physics.EnablePyhsics[1] = true
        Physics.TailRotOffset = vectors.vec3()
        Legs.RightLegRotOffset = vectors.vec3()
        models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom:setPivot(2, 6)
        Legs.LeftLegRotOffset = vectors.vec3()
        models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom:setPivot(-2, 6)
        Apron.RotOffset = vectors.vec3()
        models.models.main.Avatar.Body.UmbrellaB:setRot(20)
        Arms.hideHeldItem(false)
        Umbrella.Enabled = true
        Sleeve.Moving = true
        if PhotoPose.CurrentPose > 0 then
            ActionWheel.untogglePose(PhotoPose.CurrentPose)
        end
        PhotoPose.CurrentPose = 0
    end
}

events.TICK:register(function ()
    if PhotoPose.CurrentPose > 0 then
        if PhotoPose.CurrentPose == 1 or PhotoPose.CurrentPose == 3 or PhotoPose.CurrentPose == 5 then
            if General.PlayerCondition == "LOW" then
                FaceParts.setEmotion("TIRED", "TIRED", "OPENED", 1, true)
            else
                FaceParts.setEmotion("NORMAL", "NORMAL", "OPENED", 1, true)
            end
        elseif PhotoPose.CurrentPose == 2 then
            FaceParts.setEmotion("CLOSED", "CLOSED", "CLOSED", 1, true)
        elseif PhotoPose.CurrentPose == 4 or PhotoPose.CurrentPose == 6 then
            if General.PlayerCondition == "LOW" then
                FaceParts.setEmotion("CLOSED", "TIRED", "OPENED", 1, true)
            else
                FaceParts.setEmotion("CLOSED", "NORMAL", "OPENED", 1, true)
            end
        elseif PhotoPose.CurrentPose == 7 then
            if General.PlayerCondition == "LOW" then
                FaceParts.setEmotion("TIRED", "TIRED", "CLOSED", 1, true)
            else
                FaceParts.setEmotion("NORMAL", "NORMAL", "CLOSED", 1, true)
            end
        end
        if not PhotoPose.check() then
            PhotoPose.stopPose()
        end
    end
    PhotoPose.PosingChecked = false
    PhotoPose.IsPosingPrev = PhotoPose.CurrentPose > 0
end)

return PhotoPose