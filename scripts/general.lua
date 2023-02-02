---@class General 他の複数のクラスが参照するフィールドや関数を定義するクラス
---@field General.EffectChecked boolean このチックにステータスエフェクトを取得したかどうか
---@field General.EffectTable table ステータスエフェクトを保持する変数
---@field General.PlayerCondition ConditionLevel プレイヤーの体力・満腹度の度合い
---@field General.IsSneaking boolean プレイがスニーク状態かどうか（RENDERでスニーク補正を行う為、TICKでスニークチェックをしたい）

--[[
	## General.playerConditionの値
	- 凍えている時は常に"LOW"
	- クリエイティブモードとスペクテイターモードでは常に"HIGH"
	┌───────────┬───────────────────┬───────────────┐
	│ 値		│ 体力H				| 満腹度S		 |
	╞═══════════╪═══════════════════╪═══════════════╡
	│ "HIGH"	│ 50% < H			│ 30% < S		│
	├───────────┼───────────────────┼───────────────┤
	│ "MEDIUM"	│ 20% < H <= 50%	│ 0% < S <= 30%	│
	├───────────┼───────────────────┼───────────────┤
	│ "LOW"		│ H <= 50%			│ 0% = S		│
	└───────────┴───────────────────┴───────────────┘
]]

---@alias ConditionLevel
---| "LOW"
---| "MEDIUM"
---| "HIGH"


General = {
	EffectChecked = false,
	EffectTable = {},
	PlayerCondition = "HIGH",
	IsSneaking = false,

	---クラスのインスタンス化
	---@param class table 継承先のクラス
	---@param super table|nil 継承元のクラス
	---@param ... any クラスの引数
	---@return table instancedClass インスタンス化されたクラス
	instance = function (class, super, ...)
		local instance = super and super.new(...) or {}
		setmetatable(instance, {__index = class})
		setmetatable(class, {__index = super})
		return instance
	end,

	---該当するキーのインデックスを返す。キーがテーブルに存在しない場合は-1を返す。
	---@param targetTable table 調べるテーブル
	---@param key any 見つけ出す要素
	---@return integer index targetTable内のkeyがあるインデックス。存在しない場合は-1を返す。
	indexof = function (targetTable, key)
		for index, element in ipairs(targetTable) do
			if element == key then
				return index
			end
		end
		return -1
	end,

	---指定されたステータス効果の情報を返す。指定されたステータス効果が付与されていない場合はnilが返される。
	---@param name string ステータス効果
	---@return table|nil status ステータス効果の情報（該当のステータスを受けていない場合はnilが返る。）
	getTargetEffect = function (name)
		if not General.EffectChecked and host:isHost() then
			General.EffectTable = {}
			for _, effect in ipairs(host:getStatusEffects()) do
				General.EffectTable[effect.name:match("^effect%.minecraft%.(.+)$")] = {duration = effect.duration, amplifier = effect.amplifier, visible = effect.visible}
			end
			General.EffectChecked = true
		end
		return General.EffectTable[name]
	end
}

events.TICK:register(function ()
	local gamemode = player:getGamemode()
	local healthPercent = player:getHealth() / player:getMaxHealth()
	local satisfactionPercent = player:getFood() / 20
	General.PlayerCondition = player:getFrozenTicks() == 140 and "LOW" or (((healthPercent > 0.5 and satisfactionPercent > 0.3) or (gamemode == "CREATIVE" or gamemode == "SPECTATOR")) and "HIGH" or ((healthPercent > 0.2 and satisfactionPercent > 0) and "MEDIUM" or "LOW"))
	General.IsSneaking = player:getPose() == "CROUCHING"
	if not client:isPaused() then
		General.EffectChecked = false
	end
end)

return General