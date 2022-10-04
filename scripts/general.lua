---@class General 他の複数のクラスが参照するフィールドや関数を定義するクラス
---@field General.isTired boolean キャラクターが疲弊しているかどうか（サバイバルかアドベンチャーで、HP4以下または満腹度0）

---@alias AnimationState
---| "PLAY"
---| "STOP"

General = {}

General.isTired = false

---渡されたItemStackのアイテムタイプを返す。nilや"minecraft:air"の場合は"none"と返す。
---@param item ItemStack アイテムタイプを調べるItemStack
---@return string
function General.hasItem(item)
	if item == nil then
		return "none"
	else
		return item.id == "minecraft:air" and "none" or item.id
	end
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
	General.isTired = (player:getHealth() / player:getMaxHealth() <= 0.2 or player:getFood() == 0 or player:getFrozenTicks() == 140) and (gamemode == "SURVIVAL" or gamemode == "ADVENTURE")
end)

return General