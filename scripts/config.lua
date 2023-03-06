---@class Config アバター設定を管理するクラス
---@field Config.DefaultValues table 読み込んだ値のデフォルト値を保持するテーブル
---@field Config.IsSynced boolean アバターの設定がホストと同期されたかどうか
---@field Config.NextSyncCount integer 次の同期pingまでのカウンター

Config = {
	DefaultValues = {},
	IsSynced = host:isHost(),
	NextSyncCount = 0,

	---設定を読み出す
	---@param keyName string 読み出す設定の名前
	---@param defaultValue any 該当の設定が無い場合や、ホスト外での実行の場合はこの値が返される。
	---@return any data 読み出した値
	loadConfig = function (keyName, defaultValue)
		if host:isHost() then
			local data = config:load(keyName)
			Config.DefaultValues[keyName] = defaultValue
			if data ~= nil then
				return data
			else
				return defaultValue
			end
		else
			return defaultValue
		end
	end,

	---設定を保存する
	---@param keyName string 保存する設定の名前
	---@param value any 保存する値
	saveConfig = function (keyName, value)
		if host:isHost() then
			if Config.DefaultValues[keyName] == value then
				config:save(keyName, nil)
			else
				config:save(keyName, value)
			end
		end
	end
}

--ping関数
---アバター設定を他Figuraクライアントと同期する。
---@param poseID integer 現在のポーズID
---@param nameID integer 名前ID
---@param costumeID integer 衣装ID
---@param skullID integer 頭モデルID
---@param autoShake boolean 自動ブルブル
---@param showArmor boolean 防具を表示するかどうか
---@param umbrellaSound boolean 傘の開閉音を再生するかどうか
---@param alwaysUmbrella boolean 傘をずっとさしているかどうか
---@param nightVisiton boolean 暗視が付与されているかどうか
---@param wardenNearby boolean ウォーデンが付近にいるかどうか
---@param drowned boolean 溺れているかどうか
function pings.syncAvatarConfig(poseID, nameID, costumeID, skullID, autoShake, showArmor, umbrellaSound, alwaysUmbrella, nightVisiton, wardenNearby, drowned)
	if not Config.IsSynced then
		if poseID >= 1 then
			PhotoPose.setPose(poseID)
		end
		ActionWheel.CurrentPlayerNameState = nameID
		ActionWheel.CurrentCostumeState = costumeID
		ActionWheel.CurrentSkullState = skullID
		nameplate.ALL:setText(Nameplate.NameList[nameID])
		if ActionWheel.CurrentCostumeState == 0 then
			Costume.resetCostume()
		else
			Costume.setCostume(Costume.CostumeList[ActionWheel.CurrentCostumeState]:upper())
		end
		Skull.CurrentSkull = skullID
		Wet.AutoShake = autoShake
		Armor.ShowArmor = showArmor
		Umbrella.Sound = umbrellaSound
		Umbrella.AlwaysUse = alwaysUmbrella
		FoxFire.NightVision = nightVisiton
		Warden.WardenNearby = wardenNearby
		FaceParts.Drowned = drowned
		Config.IsSynced = true
	end
end

events.TICK:register(function ()
	if Config.NextSyncCount == 0 then
		pings.syncAvatarConfig(PhotoPose.CurrentPose, ActionWheel.CurrentPlayerNameState, ActionWheel.CurrentCostumeState, ActionWheel.CurrentSkullState, Wet.AutoShake, Armor.ShowArmor, Umbrella.Sound, Umbrella.AlwaysUse, FoxFire.NightVision, Warden.WardenNearby, FaceParts.Drowned)
		Config.NextSyncCount = 300
	else
		Config.NextSyncCount = Config.NextSyncCount - 1
	end
end)

if host:isHost() then
	config:name("Suzu")
end

return Config