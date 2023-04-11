---@class Naginata 薙刀のモデルを制御するクラス
---@class EnableAnimation boolean 薙刀の構えが有効かどうか

Naginata = {
    EnableAnimation = true
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
    for _, animation in ipairs({animations["models.main"]["naginata_right"], animations["models.naginata"]["naginata_right"]}) do
        animation:setPlaying(naginataModel[1] and not leftHanded and not active)
    end
    for _, animation in ipairs({animations["models.main"]["naginata_left"], animations["models.naginata"]["naginata_left"]}) do
        animation:setPlaying(naginataModel[2] and leftHanded and not active)
    end
    Naginata.EnableAnimation = ((naginataModel[1] and not leftHanded) or (naginataModel[2] and leftHanded)) and not active
end)

return Naginata