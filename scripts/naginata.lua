---@class Naginata 薙刀のモデルを制御するクラス
---@class EnableAnimation boolean 薙刀の構えが有効かどうか

Naginata = {
    EnableAnimation = true
}

events.TICK:register(function ()
    local leftHanded = player:isLeftHanded()
    local firstPerson = renderer:isFirstPerson()
    local rightSword = not (player:getHeldItem(leftHanded).id:find("^minecraft:.+_sword$") == nil or firstPerson or Arms.ItemHeldContradicts)
    local leftSword = not (player:getHeldItem(not leftHanded).id:find("^minecraft:.+_sword$") == nil or firstPerson or Arms.ItemHeldContradicts)
    vanilla_model.RIGHT_ITEM:setVisible(not (rightSword or Arms.ItemHeldContradicts))
    vanilla_model.LEFT_ITEM:setVisible(not (leftSword or Arms.ItemHeldContradicts))
    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightNaginata:setVisible(rightSword)
    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftNaginata:setVisible(leftSword)
    local active = player:getActiveItem().id ~= "minecraft:air"
    for _, animation in ipairs({animations["models.main"]["naginata_right"], animations["models.naginata"]["naginata_right"]}) do
        animation:setPlaying(rightSword and not leftHanded and not active)
    end
    for _, animation in ipairs({animations["models.main"]["naginata_left"], animations["models.naginata"]["naginata_left"]}) do
        animation:setPlaying(leftSword and leftHanded and not active)
    end
    Naginata.EnableAnimation = ((rightSword and not leftHanded) or (leftSword and leftHanded)) and not active
end)

return Naginata