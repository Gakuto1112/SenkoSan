---@class Naginata 薙刀のモデルを制御するクラス
---@field State table<integer> 薙刀の状態: 1. 右手, 2. 左手, x-0. 薙刀のモデルは表示されない, x-1. 通常の薙刀持ち, x-2. 薙刀を構えて持つ, x-3. 薙刀を構えて持つ（おすわり）, x-4. 薙刀の防御, x-5. 薙刀の防御（おすわり）
---@field StatePrev table<integer> 前チックの薙刀の状態: 1. 右手, 2. 左手, x-0. 薙刀のモデルは表示されない, x-1. 通常の薙刀持ち, x-2. 薙刀を構えて持つ, x-3. 薙刀を構えて持つ（おすわり）, x-4. 薙刀の防御, x-5. 薙刀の防御（おすわり）
Naginata = {
    State = {0, 0},
    StatePrev = {0, 0}
}

events.RENDER:register(function (_, context)
    local leftHanded = player:isLeftHanded()
    local heldItems = {player:getHeldItem(leftHanded), player:getHeldItem(not leftHanded)}
    for i = 1, 2 do
        Naginata.State[i] = (not (heldItems[i].id:find("^minecraft:.+_sword$") == nil or context == "FIRST_PERSON" or Arms.ItemHeldContradicts)) and ((leftHanded ~= (i == 1) and not (player:getActiveItem().id ~= "minecraft:air" and not heldItems[3 - i].id == "minecraft:shield") and not player:getPose() ~= "SLEEPING") and (player:getActiveItem().id == "minecraft:shield" and (SitDown.IsAnimationPlaying and 5 or 4) or (SitDown.IsAnimationPlaying and 3 or 2)) or 1) or 0
        if Naginata.State[i] == 2 then
            if player:getPose() == "CROUCHING" then
                models.models.main.Avatar.LowerBody:setPos(i == 1 and 3 or -3)
            else
                models.models.main.Avatar.LowerBody:setPos()
            end
        end
    end
    for i = 1, 2 do
        local hasShield = heldItems[3 - i].id == "minecraft:shield"
        if Naginata.State[i] ~= Naginata.StatePrev[i] then
            if i == 1 then
                if Naginata.State[1] > 0 then
                    vanilla_model.RIGHT_ITEM:setVisible(false)
                    vanilla_model.LEFT_ITEM:setVisible(Naginata.State[2] == 0 and (not hasShield or Naginata.State[1] <= 1))
                    models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightNaginata:setVisible(true)
                else
                    if not ActionWheel.IsAnimationPlaying then
                        vanilla_model.RIGHT_ITEM:setVisible(true)
                        if hasShield then
                            vanilla_model.LEFT_ITEM:setVisible(true)
                        elseif Naginata.State[2] >= 2 then
                            vanilla_model.RIGHT_ITEM:setVisible(false)
                        end
                    else
                        for _, vanillaModel in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
                            vanillaModel:setVisible(false)
                        end
                    end
                    models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightNaginata:setVisible(false)
                end
                if Naginata.State[1] >= 2 and Naginata.State[1] <= 3 then
                    models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightNaginata:setPos(0, -1, 7)
                    models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightNaginata:setRot(-77.1307, -13.9775, 71.9524)
                    models.models.main.Avatar.UpperBody:setRot(0, 40)
                    models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom:setRot(30)
                    models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom:setRot(60)
                    if Naginata.State[1] == 2 then
                        Arms.RightArmRotOffset = vectors.vec3(45, 30)
                        Arms.LeftArmRotOffset = vectors.vec3(-40, -40)
                    else
                        Arms.RightArmRotOffset = vectors.vec3(25, 20, 15)
                        Arms.LeftArmRotOffset = vectors.vec3(-60, -30, -15)
                    end
                elseif Naginata.State[1] >= 4 then
                    vanilla_model.LEFT_ITEM:setVisible(false)
                    models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightNaginata:setPos(0, 0, 7)
                    models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightNaginata:setRot(105, 60, -90)
                    models.models.main.Avatar.LowerBody:setPos()
                    for _, modelPart in ipairs({models.models.main.Avatar.UpperBody, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom}) do
                        modelPart:setRot()
                    end
                    if Naginata.State[1] == 4 then
                        Arms.RightArmRotOffset = vectors.vec3(120, -15)
                        Arms.LeftArmRotOffset = vectors.vec3(120, 15)
                    else
                        Arms.RightArmRotOffset = vectors.vec3(100, -25, 15)
                        Arms.LeftArmRotOffset = vectors.vec3(100, 25, -15)
                    end
                elseif Naginata.State[2] <= 1 then
                    models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightNaginata:setPos()
                    for _, modelPart in ipairs({models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightNaginata, models.models.main.Avatar.UpperBody}) do
                        modelPart:setRot()
                    end
                    Arms.RightArmRotOffset = vectors.vec3()
                    Arms.LeftArmRotOffset = vectors.vec3()
                    models.models.main.Avatar.LowerBody:setPos()
                    for _, modelPart in ipairs({models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom}) do
                        modelPart:setRot()
                    end
                end
            else
                if Naginata.State[2] > 0 then
                    vanilla_model.RIGHT_ITEM:setVisible(Naginata.State[1] == 0 and (not hasShield or Naginata.State[2] <= 1))
                    vanilla_model.LEFT_ITEM:setVisible(false)
                    models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftNaginata:setVisible(true)
                else
                    if not ActionWheel.IsAnimationPlaying then
                        vanilla_model.LEFT_ITEM:setVisible(true)
                        if hasShield then
                            vanilla_model.RIGHT_ITEM:setVisible(true)
                        elseif Naginata.State[1] >= 2 then
                            vanilla_model.LEFT_ITEM:setVisible(false)
                        end
                    else
                        for _, vanillaModel in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
                            vanillaModel:setVisible(false)
                        end
                    end
                    models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftNaginata:setVisible(false)
                end
                if Naginata.State[2] >= 2 and Naginata.State[2] <= 3 then
                    models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftNaginata:setPos(0, -1, 7)
                    models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftNaginata:setRot(-77.1307, 13.9775, -71.9524)
                    models.models.main.Avatar.UpperBody:setRot(0, -40)
                    models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom:setRot(60)
                    models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom:setRot(30)
                    if Naginata.State[2] == 2 then
                        Arms.RightArmRotOffset = vectors.vec3(-40, 40)
                        Arms.LeftArmRotOffset = vectors.vec3(45, -30)
                    else
                        Arms.RightArmRotOffset = vectors.vec3(-60, 30, 15)
                        Arms.LeftArmRotOffset = vectors.vec3(25, -20, -15)
                    end
                elseif Naginata.State[2] >= 4 then
                    vanilla_model.RIGHT_ITEM:setVisible(false)
                    models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftNaginata:setPos(0, 0, 7)
                    models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftNaginata:setRot(105, -60, 90)
                    models.models.main.Avatar.LowerBody:setPos()
                    for _, modelPart in ipairs({models.models.main.Avatar.UpperBody, models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom}) do
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
                    models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftNaginata:setPos()
                    for _, modelPart in ipairs({models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftNaginata, models.models.main.Avatar.UpperBody}) do
                        modelPart:setRot()
                    end
                    Arms.RightArmRotOffset = vectors.vec3()
                    Arms.LeftArmRotOffset = vectors.vec3()
                    models.models.main.Avatar.LowerBody:setPos()
                    for _, modelPart in ipairs({models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom, models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom}) do
                        modelPart:setRot()
                    end
                end
            end
            Arms.updateArm()
        end
    end
    for i = 1, 2 do
        Naginata.StatePrev[i] = Naginata.State[i]
    end
end)

events.TICK:register(function ()
    for i = 1, 2 do
        if Naginata.State[i] > 0 then
            if Naginata.State[i] >= 4 then
                FaceParts.setEmotion("ANGRY", "ANGRY", "CLOSED", 1, false)
            end
            local naginataModel = i == 1 and models.models.main.Avatar.UpperBody.Arms.RightArm.RightArmBottom.RightNaginata or models.models.main.Avatar.UpperBody.Arms.LeftArm.LeftArmBottom.LeftNaginata
            local heldItem = player:getHeldItem(player:isLeftHanded() ~= (i == 2))
            local material = heldItem.id:match("^minecraft:(%a+)_sword$")
            local meterialValue = material == "wooden" and 0 or (material == "stone" and 1 or (material == "iron" and 2 or (material == "golden" and 3 or (material == "diamond" and 4 or 5))))
            naginataModel.Rod:setUVPixels(meterialValue)
            naginataModel.Handguard:setUVPixels(0, meterialValue)
            local blade = i == 1 and naginataModel.RightNaginataBlade or naginataModel.LeftNaginataBlade
            blade:setUVPixels(0, meterialValue * 2)
            naginataModel:setSecondaryRenderType(heldItem:hasGlint() and "GLINT" or "NONE")
            if Naginata.State[i] >= 2 and Naginata.State[i] <= 3 then
                if player:getSwingTime() == 1 then
                    FaceParts.setEmotion("ANGRY", "ANGRY", "CLOSED", 8, FaceParts.RightEyeStatus == "ANGRY")
                    local naginataAnimation = i == 1 and {animations["models.main"]["naginata_attack_right"], animations["models.naginata"]["naginata_attack_right"]} or {animations["models.main"]["naginata_attack_left"], animations["models.naginata"]["naginata_attack_left"]}
                    local speed = 6 / player:getSwingDuration()
                    for _, animaton in ipairs(naginataAnimation) do
                        animaton:speed(speed)
                        animaton:restart()
                    end
                end
            end
        end
    end
end)

Sleeve.enable()

return Naginata