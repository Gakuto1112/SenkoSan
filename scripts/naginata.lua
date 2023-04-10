---@class Naginata 薙刀のモデルを制御するクラス
---@class EnableAnimation

Naginata = {
    EnableAnimation = true
}

events.TICK:register(function ()
    local leftHanded = player:isLeftHanded()
    local firstPerson = renderer:isFirstPerson()
    local rightSword = player:getHeldItem(leftHanded).id:find("^minecraft:.+_sword$") ~= nil and not firstPerson
    local leftSword = player:getHeldItem(not leftHanded).id:find("^minecraft:.+_sword$") ~= nil and not firstPerson
    vanilla_model.RIGHT_ITEM:setVisible(not (rightSword or Arms.ItemHeldContradicts))
    vanilla_model.LEFT_ITEM:setVisible(not (leftSword or Arms.ItemHeldContradicts))
    models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightNaginata:setVisible(rightSword and not Arms.ItemHeldContradicts)
    models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftNaginata:setVisible(leftSword and not Arms.ItemHeldContradicts)
end)

return Naginata