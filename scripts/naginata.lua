---@class Naginata 薙刀のモデルを制御するクラス
---@field Naginata.EnableAnimation boolean 薙刀の構えが有効かどうか
---@field Naginata.SwingSpeedPrev integer 前チックの腕を振る速度

Naginata = {
    EnableAnimation = true,
    SwingSpeedPrev = 6,

    ---座る間に毎チック呼び出される関数
    onSitDownTick = function ()
        if (Naginata.EnableAnimation or ActionWheel.IsAnimationPlaying) and not (TailCuddling.IsAnimationPlaying or EarCuddling.IsAnimationPlaying) then
            Arms.RightArmRotOffset = vectors.vec3(-20, -10, 15)
            Arms.LeftArmRotOffset = vectors.vec3(-20, 10, -15)
            if player:isLeftHanded() then
                Sleeve.RightSleeveRotOffset = vectors.vec3(60)
                Sleeve.LeftSleeveRotOffset = vectors.vec3(-40)
            else
                Sleeve.RightSleeveRotOffset = vectors.vec3(-40)
                Sleeve.LeftSleeveRotOffset = vectors.vec3(60)
            end
        else
            Arms.RightArmRotOffset = vectors.vec3()
            Arms.LeftArmRotOffset = vectors.vec3()
            Sleeve.RightSleeveRotOffset = vectors.vec3()
            Sleeve.LeftSleeveRotOffset = vectors.vec3()
        end
    end
}

events.TICK:register(function ()
    local leftHanded = player:isLeftHanded()
    local firstPerson = renderer:isFirstPerson()
    local heldItems = {player:getHeldItem(leftHanded), player:getHeldItem(not leftHanded)}
    local naginataModel = {not (heldItems[1].id:find("^minecraft:.+_sword$") == nil or firstPerson or Arms.ItemHeldContradicts), not (heldItems[2].id:find("^minecraft:.+_sword$") == nil or firstPerson or Arms.ItemHeldContradicts)} --薙刀のモデルを表示するかどうか
    for index, handItem in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
        handItem:setVisible(not (naginataModel[index] or Arms.ItemHeldContradicts))
    end
    for index, modelPart in ipairs({models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightNaginata, models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftNaginata}) do
        modelPart:setVisible(naginataModel[index])
        local material = heldItems[index].id:match("^minecraft:(%a+)_sword$")
        local meterialValue = material == "wooden" and 0 or (material == "stone" and 1 or (material == "iron" and 2 or (material == "golden" and 3 or (material == "diamond" and 4 or 5))))
        modelPart.Rod:setUVPixels(meterialValue)
        modelPart.Handguard:setUVPixels(0, meterialValue)
        local blade = index == 1 and modelPart.RightNaginataBlade or modelPart.LeftNaginataBlade
        blade:setUVPixels(0, meterialValue * 2)
        modelPart:setSecondaryRenderType(heldItems[index]:hasGlint() and "GLINT" or "NONE")
    end
    local active = player:getActiveItem().id ~= "minecraft:air"
    local sleeping = player:getPose() == "SLEEPING"
    local rightNaginataAnimation = naginataModel[1] and not leftHanded and not active and not sleeping and not (TailCuddling.IsAnimationPlaying or EarCuddling.IsAnimationPlaying)
    for _, animation in ipairs({animations["models.main"]["naginata_right"], animations["models.naginata"]["naginata_right"]}) do
        animation:setPlaying(rightNaginataAnimation)
    end
    local leftNaginataAnimation = naginataModel[2] and leftHanded and not active and not sleeping and not (TailCuddling.IsAnimationPlaying or EarCuddling.IsAnimationPlaying)
    for _, animation in ipairs({animations["models.main"]["naginata_left"], animations["models.naginata"]["naginata_left"]}) do
        animation:setPlaying(leftNaginataAnimation)
    end
    if player:getSwingTime() == 1 and not firstPerson then
        if rightNaginataAnimation then
            for _, modelName in ipairs({"models.main", "models.naginata"}) do
                animations[modelName]["naginata_attack_right"]:restart()
            end
        elseif leftNaginataAnimation then
            for _, modelName in ipairs({"models.main", "models.naginata"}) do
                animations[modelName]["naginata_attack_left"]:restart()
            end
        end
    end
    local swingSpeed = player:getSwingDuration()
    if swingSpeed ~= Naginata.SwingSpeedPrev then
        local animationSpeed = 6 / swingSpeed
        for _, modelName in ipairs({"models.main", "models.naginata"}) do
            for _, animationName in ipairs({"naginata_attack_right", "naginata_attack_left"}) do
                animations[modelName][animationName]:setSpeed(animationSpeed)
            end
        end
    end
    Naginata.EnableAnimation = (rightNaginataAnimation and not leftHanded) or (leftNaginataAnimation and leftHanded)
    Naginata.SwingSpeedPrev = swingSpeed
end)

return Naginata