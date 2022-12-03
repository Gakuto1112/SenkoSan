---@class ConfigClass アバター設定を管理するクラス
---@field DefaultValues table 読み込んだ値のデフォルト値を保持するテーブル
---@field IsSynced boolean アバターの設定がホストと同期されたかどうか
---@field NextSyncCount integer 次の同期pingまでのカウンター
---@field ConfigClass.DefaultCostume integer デフォルト（初期状態）のコスチューム
---@field ConfigClass.DefaultName integer デフォルトのプレイヤーの表示名
---@field ConfigClass.AutoShake boolean 水から上がった際に自動でブルブルアクションを実行するかどうか
---@field ConfigClass.ShowArmor boolean 防具を表示するどうか
---@field ConfigClass.FoxFireInFirstPerson boolean 一人称視点で狐火を表示するかどうか
---@field ConfigClass.UmbrellaSound boolean 傘の開閉音を再生するかどうか
---@field ConfigClass.KiyBinds table アバター固有アクションのキーバインドのテーブル

ConfigClass = {}
DefaultValues = {}
IsSynced = host:isHost()
NextSyncCount = 0

---設定を読み出す
---@param keyName string 読み出す設定の名前
---@param defaultValue any 該当の設定が無い場合や、ホスト外での実行の場合はこの値が返される。
---@return any data 読み出した値
function ConfigClass.loadConfig(keyName, defaultValue)
	if host:isHost() then
		local data = config:load(keyName)
		DefaultValues[keyName] = defaultValue
		if data ~= nil then
			return data
		else
			return defaultValue
		end
	else
		return defaultValue
	end
end

---設定を保存する
---@param keyName string 保存する設定の名前
---@param value any 保存する値
function ConfigClass.saveConfig(keyName, value)
	if host:isHost() then
		if DefaultValues[keyName] == value then
			config:save(keyName, nil)
		else
			config:save(keyName, value)
		end
	end
end

--ping関数
---アバター設定を他Figuraクライアントと同期する。
---@param nameID integer 名前ID
---@param costumeID integer 衣装ID
---@param autoShake boolean 自動ブルブル
---@param showArmor boolean 防具を表示するかどうか
---@param umbrellaSound boolean 傘の開閉音を再生するかどうか
function pings.syncAvatarConfig(nameID, costumeID, autoShake, showArmor, umbrellaSound)
	if not IsSynced then
		ActionWheel.CurrentPlayerNameState = nameID
		ActionWheel.CurrentCostumeState = costumeID
		NameplateClass.setName(nameID)
		if ActionWheel.CurrentCostumeState == 0 then
			CostumeClass.resetCostume()
		else
			CostumeClass.setCostume(string.upper(CostumeClass.CostumeList[ActionWheel.CurrentCostumeState]))
		end
		WetClass.AutoShake = autoShake
		ArmorClass.ShowArmor = showArmor
		UmbrellaClass.UmbrellaSound = umbrellaSound
		IsSynced = true
	end
end

events.TICK:register(function ()
	if NextSyncCount == 0 then
		pings.syncAvatarConfig(ActionWheel.CurrentPlayerNameState, ActionWheel.CurrentCostumeState, WetClass.AutoShake, ArmorClass.ShowArmor, UmbrellaClass.UmbrellaSound)
		NextSyncCount = 300
	else
		NextSyncCount = NextSyncCount - 1
	end
end)

if host:isHost() then
	config:name("Senko_san")
end

return ConfigClass