---@class Naginata 薙刀のモデルを制御するクラス
---@field State table<integer> 薙刀の状態: 1. 右手, 2. 左手, x-0. 薙刀のモデルは表示されない, x-1. 通常の薙刀持ち, x-2. 薙刀を構えて持つ, x-3. 薙刀を構えて持つ（おすわり）, x-4. 薙刀の防御, x-5. 薙刀の防御（おすわり）
---@field StatePrev table<integer> 前チックの薙刀の状態: 1. 右手, 2. 左手, x-0. 薙刀のモデルは表示されない, x-1. 通常の薙刀持ち, x-2. 薙刀を構えて持つ, x-3. 薙刀を構えて持つ（おすわり）, x-4. 薙刀の防御, x-5. 薙刀の防御（おすわり）
Naginata = {
    State = {0, 0},
    StatePrev = {0, 0}
}

events.TICK:register(function ()
    local leftHanded = player:isLeftHanded()
    local firstPerson = renderer:isFirstPerson()
    local heldItems = {player:getHeldItem(leftHanded), player:getHeldItem(not leftHanded)}
    local active = player:getActiveItem().id ~= "minecraft:air"
    local sleeping = player:getPose() == "SLEEPING"
    local defense = player:getActiveItem().id == "minecraft:shield"
    for i = 1, 2 do
        local hasShield = heldItems[3 - i].id == "minecraft:shield"
        Naginata.State[i] = (not (heldItems[i].id:find("^minecraft:.+_sword$") == nil or firstPerson or Arms.ItemHeldContradicts)) and ((leftHanded ~= (i == 1) and not (active and not hasShield) and not sleeping and not (TailCuddling.IsAnimationPlaying or EarCuddling.IsAnimationPlaying)) and (defense and (SitDown.IsAnimationPlaying and 5 or 4) or (SitDown.IsAnimationPlaying and 3 or 2)) or 1) or 0
    end
    for i = 1, 2 do
        local hasShield = heldItems[3 - i].id == "minecraft:shield"
        if Naginata.State[i] ~= Naginata.StatePrev[i] then
            if i == 1 then
                if Naginata.State[1] > 0 then
                    vanilla_model.RIGHT_ITEM:setVisible(false)
                    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightNaginata:setVisible(true)
                else
                    vanilla_model.RIGHT_ITEM:setVisible(not (ActionWheel.IsAnimationPlaying or PhotoPose.CurrentPose > 0))
                    if hasShield then
                        vanilla_model.LEFT_ITEM:setVisible(true)
                    end
                    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightNaginata:setVisible(false)
                end
                if Naginata.State[1] >= 2 and Naginata.State[1] <= 3 then
                    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightNaginata:setPos(0, -1, 7)
                    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightNaginata:setRot(-77.1307, -13.9775, 71.9524)
                    models.models.main.Avatar.Body:setRot(0, 40)
                    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom:setRot(30)
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom:setRot(60)
                    models.models.main.Avatar.Body.BodyBottom.Legs:setRot(0, -40)
                    if Naginata.State[1] == 2 then
                        Arms.RightArmRotOffset = vectors.vec3(45, 30)
                        Arms.LeftArmRotOffset = vectors.vec3(-40, -40)
                    else
                        Arms.RightArmRotOffset = vectors.vec3(25, 20, 15)
                        Arms.LeftArmRotOffset = vectors.vec3(-60, -30, -15)
                    end
                elseif Naginata.State[1] >= 4 then
                    vanilla_model.LEFT_ITEM:setVisible(false)
                    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightNaginata:setPos(0, 0, 7)
                    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightNaginata:setRot(105, 60, -90)
                    for _, modelPart in ipairs({models.models.main.Avatar.Body, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom, models.models.main.Avatar.Body.BodyBottom.Legs}) do
                        modelPart:setRot()
                    end
                    if Naginata.State[1] == 4 then
                        Arms.RightArmRotOffset = vectors.vec3(120, -15)
                        Arms.LeftArmRotOffset = vectors.vec3(120, 15)
                    else
                        Arms.RightArmRotOffset = vectors.vec3(100, -25, 15)
                        Arms.LeftArmRotOffset = vectors.vec3(100, 25, -15)
                    end
                else
                    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightNaginata:setPos()
                    for _, modelPart in ipairs({models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightNaginata, models.models.main.Avatar.Body}) do
                        modelPart:setRot()
                    end
                    if PhotoPose.CurrentPose == 0 then
                        if not Earpick.IsAnimationPlaying and not TeaTime.IsAnimationPlaying and not Massage.IsAnimationPlaying then
                            Arms.RightArmRotOffset = vectors.vec3()
                            Arms.LeftArmRotOffset = vectors.vec3()
                        end
                        for _, modelPart in ipairs({models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom, models.models.main.Avatar.Body.BodyBottom.Legs}) do
                            modelPart:setRot()
                        end
                    end
                end
            else
                if Naginata.State[2] > 0 then
                    vanilla_model.LEFT_ITEM:setVisible(false)
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftNaginata:setVisible(true)
                else
                    if not (ActionWheel.IsAnimationPlaying or PhotoPose.CurrentPose > 0) then
                        vanilla_model.LEFT_ITEM:setVisible(true)
                        if hasShield then
                            vanilla_model.RIGHT_ITEM:setVisible(true)
                        end
                    else
                        vanilla_model.LEFT_ITEM:setVisible(false)
                    end
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftNaginata:setVisible(false)
                end
                if Naginata.State[2] >= 2 and Naginata.State[2] <= 3 then
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftNaginata:setPos(0, -1, 7)
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftNaginata:setRot(-77.1307, 13.9775, -71.9524)
                    models.models.main.Avatar.Body:setRot(0, -40)
                    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom:setRot(60)
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom:setRot(30)
                    models.models.main.Avatar.Body.BodyBottom.Legs:setRot(0, 40)
                    if Naginata.State[2] == 2 then
                        Arms.RightArmRotOffset = vectors.vec3(-40, 40)
                        Arms.LeftArmRotOffset = vectors.vec3(45, -30)
                    else
                        Arms.RightArmRotOffset = vectors.vec3(-60, 30, 15)
                        Arms.LeftArmRotOffset = vectors.vec3(25, -20, -15)
                    end
                elseif Naginata.State[2] >= 4 then
                    vanilla_model.RIGHT_ITEM:setVisible(false)
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftNaginata:setPos(0, 0, 7)
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftNaginata:setRot(105, -60, 90)
                    for _, modelPart in ipairs({models.models.main.Avatar.Body, models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom, models.models.main.Avatar.Body.BodyBottom.Legs}) do
                        modelPart:setRot()
                    end
                    if Naginata.State[2] == 4 then
                        Arms.RightArmRotOffset = vectors.vec3(120, -15)
                        Arms.LeftArmRotOffset = vectors.vec3(120, 15)
                    else
                        Arms.RightArmRotOffset = vectors.vec3(100, -25, 15)
                        Arms.LeftArmRotOffset = vectors.vec3(100, 25, -15)
                    end
                elseif Naginata.State[1] <= 1 then
                    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftNaginata:setPos()
                    for _, modelPart in ipairs({models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftNaginata, models.models.main.Avatar.Body}) do
                        modelPart:setRot()
                    end
                    if PhotoPose.CurrentPose == 0 then
                        if not Earpick.IsAnimationPlaying and not TeaTime.IsAnimationPlaying and not Massage.IsAnimationPlaying then
                            Arms.RightArmRotOffset = vectors.vec3()
                            Arms.LeftArmRotOffset = vectors.vec3()
                        end
                        for _, modelPart in ipairs({models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom, models.models.main.Avatar.Body.BodyBottom.Legs}) do
                            modelPart:setRot()
                        end
                    end
                end
            end
        end
        if Naginata.State[i] > 0 then
            local naginataModel = i == 1 and models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightNaginata or models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftNaginata
            local material = heldItems[i].id:match("^minecraft:(%a+)_sword$")
            local meterialValue = material == "wooden" and 0 or (material == "stone" and 1 or (material == "iron" and 2 or (material == "golden" and 3 or (material == "diamond" and 4 or 5))))
            naginataModel.Rod:setUVPixels(meterialValue)
            naginataModel.Handguard:setUVPixels(0, meterialValue)
            local blade = i == 1 and naginataModel.RightNaginataBlade or naginataModel.LeftNaginataBlade
            blade:setUVPixels(0, meterialValue * 2)
            naginataModel:setSecondaryRenderType(heldItems[i]:hasGlint() and "GLINT" or "NONE")
            if Naginata.State[i] >= 2 and Naginata.State[i] <= 3 then
                if player:getSwingTime() == 1 then
                    local naginataAnimation = i == 1 and {animations["models.main"]["naginata_attack_right"], animations["models.naginata"]["naginata_attack_right"]} or {animations["models.main"]["naginata_attack_left"], animations["models.naginata"]["naginata_attack_left"]}
                    local speed = 6 / player:getSwingDuration()
                    for _, animaton in ipairs(naginataAnimation) do
                        animaton:speed(speed)
                        animaton:restart()
                    end
                end
                local heldItemModel = i == 1 and vanilla_model.LEFT_ITEM or vanilla_model.RIGHT_ITEM
                heldItemModel:setVisible(not hasShield and Naginata.State[3 - i] == 0)
            end
        end
    end
    if player:getSwingTime() == 1 and not firstPerson then
        if Naginata.State[1] == 2 then
            for _, modelName in ipairs({"models.main", "models.naginata"}) do
                animations[modelName]["naginata_attack_right"]:restart()
            end
        elseif Naginata.State[2] == 2 then
            for _, modelName in ipairs({"models.main", "models.naginata"}) do
                animations[modelName]["naginata_attack_left"]:restart()
            end
        end
    end
    for i = 1, 2 do
        Naginata.StatePrev[i] = Naginata.State[i]
    end
end)

return Naginata