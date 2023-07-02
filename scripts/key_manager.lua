---@class KeyManager アバターのキー割り当てを管理するクラス。ここで管理する割り当ては設定で変更された場合はそれが保存される。
---@field KeyMappings table<string, Keybind> キーの割り当てのテーブル
KeyManager = {
    KeyMappings = {},

    ---キー割り当てを登録する。
    ---@param assignName string 割り当ての名前
    ---@param keyName Minecraft.keyCode 割当先のキー
    ---@param keyFunction function 割り当てのキーが押された時に呼ばれる関数
    register = function(assignName, keyName, keyFunction)
        KeyManager.KeyMappings[assignName] = keybinds:newKeybind(Language.getTranslate("key_name__"..assignName), Config.loadConfig("keybind."..assignName, keyName));
        KeyManager.KeyMappings[assignName]:onPress(keyFunction);
    end
}

events.TICK:register(function ()
    for key, value in pairs(KeyManager.KeyMappings) do
        if not value:isDefault() then
            local newKey = value:getKey()
            Config.saveConfig("keybind."..key, newKey)
            value:setKey(newKey)
        end
    end
end)

return KeyManager