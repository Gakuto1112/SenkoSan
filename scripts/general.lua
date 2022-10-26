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

---指定されたステータス効果の情報を返す。指定されたステータス効果が付与されていない場合はnilが返される。
---@param name string ステータス効果
---@return table|nil
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
---@return boolean
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
			local targetAnimation = animations["models."..modelPart:getName()][animationName]
			if targetAnimation ~= nil then
				targetAnimation:play()
			end
		end
	else
		for _, modelPart in ipairs(modelFiles) do
			local targetAnimation = animations["models."..modelPart:getName()][animationName]
			if targetAnimation ~= nil then
				targetAnimation:stop()
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