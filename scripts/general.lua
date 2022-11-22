---@class General 他の複数のクラスが参照するフィールドや関数を定義するクラス
---@field General.PlayerCondition ConditionLevel プレイヤーの体力・満腹度の度合い

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

---@alias AnimationState
---| "PLAY"
---| "STOP"

General = {}

General.PlayerCondition = "HIGH"

---該当するキーのインデックスを返す。キーがテーブルに存在しない場合は-1を返す。
---@param targetTable table 調べるテーブル
---@param key any 見つけ出す要素
---@return integer index targetTable内のkeyがあるインデックス。存在しない場合は-1を返す。
function General.indexof(targetTable, key)
	for index, element in ipairs(targetTable) do
		if element == key then
			return index
		end
	end
	return -1
end

---指定されたステータス効果の情報を返す。指定されたステータス効果が付与されていない場合はnilが返される。
---@param name string ステータス効果
---@return table|nil status ステータス効果の情報（該当のステータスを受けていない場合はnilが返る。）
function General.getStatusEffect(name)
	for _, effect in ipairs(player:getStatusEffects()) do
		if effect.name == "effect.minecraft."..name then
			return effect
		end
	end
	return nil
end

---アニメーションが再生中かどうかを返す
---@param modelName string モデル名
---@param animationName string アニメーションが名
---@return boolean isAnimationPlaying アニメーションが再生中かどうか
function General.isAnimationPlaying(modelName, animationName)
	return animations[modelName][animationName]:getPlayState() == "PLAYING"
end

--複数のモデルファイルのアニメーションを同時に制御する。
---@param animationState AnimationState アニメーションの設定値
---@param animationName string アニメーションの名前
function General.setAnimations(animationState, animationName)
	local modelFiles = models.models:getChildren()
	if animationState == "PLAY" then
		for _, modelPart in ipairs(modelFiles) do
			local animationsInModel = animations["models."..modelPart:getName()]
			if animationsInModel then
				local targetAnimation = animations["models."..modelPart:getName()][animationName]
				if targetAnimation then
					targetAnimation:play()
				end
			end
		end
	else
		for _, modelPart in ipairs(modelFiles) do
			local animationsInModel = animations["models."..modelPart:getName()]
			if animationsInModel then
				local targetAnimation = animations["models."..modelPart:getName()][animationName]
				if targetAnimation then
					targetAnimation:stop()
				end
			end
		end
	end
end

events.TICK:register(function ()
	local gamemode = player:getGamemode()
	local healthPercent = player:getHealth() / player:getMaxHealth()
	local satisfactionPercent = player:getFood() / 20
	General.PlayerCondition = player:getFrozenTicks() == 140 and "LOW" or (((healthPercent > 0.5 and satisfactionPercent > 0.3) or (gamemode == "CREATIVE" or gamemode == "SPECTATOR")) and "HIGH" or ((healthPercent > 0.2 and satisfactionPercent > 0) and "MEDIUM" or "LOW"))
end)

return General