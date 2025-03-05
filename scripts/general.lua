---プレイヤーの体力・満腹度の度合いを示す列挙型
---@alias General.ConditionLevel
---| "LOW" ハート2個以下、又は満腹度が0、又は凍えているとき
---| "MEDIUM" ハートが2個より多いかつ50%以下、又は満腹度が30%以下
---| "HIGH" ハートが50%より多いかつ満腹度が30%より多い、又はクリエイティブモードかスペクテイターモード

---@class General 他の複数のクラスが参照するフィールドや関数を定義するクラス
General = {
	---このチックにステータスエフェクトを取得したかどうか
	---@type boolean
	EffectChecked = false,

	---プレイヤーの体力・満腹度の度合い
	---@type General.ConditionLevel
	PlayerCondition = "HIGH",

	---メッセージを表示するかどうか
	---@type boolean
	ShowMessage = true,

	---クラスのインスタンス化
	---@param class table<any> 継承先のクラス
	---@param super table|nil 継承元のクラス
	---@param ... any クラスの引数
	---@return table<any> instancedClass インスタンス化されたクラス
	instance = function (class, super, ...)
		local instance = super and super.new(...) or {}
		setmetatable(instance, {__index = class})
		setmetatable(class, {__index = super})
		return instance
	end,

	---該当するキーのインデックスを返す。キーがテーブルに存在しない場合は-1を返す。
	---@param targetTable table<any> 調べるテーブル
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
		if host:isHost() then
			for _, effect in ipairs(host:getStatusEffects()) do
				local effectName = effect.name:match("minecraft[%.:](.+)$")
				if effectName == name then
					return effect
				end
			end
		end
	end,

	---指定したモデルのワールド位置を返す。
    ---@param model ModelPart ワールド位置を取得するモデルパーツ
    ---@return Vector3 worldPos モデルのワールド位置
    getModelWorldPos = function(model)
        local modelMatrix = model:partToWorldMatrix()
        return vectors.vec3(modelMatrix[4][1], modelMatrix[4][2], modelMatrix[4][3])
    end,

	---モデルパーツをディープコピーする。非表示のモデルパーツはコピーしない。
    ---@param modelPart ModelPart コピーするモデルパーツ
	---@param copyInvisibleParts boolean 非表示のモデルパーツをコピーするかどうか
    ---@return ModelPart? copiedModelPart コピーされたモデルパーツ。入力されたモデルパーツが非表示の場合はnilが返る。
    copyModel = function (self, modelPart, copyInvisibleParts)
        if modelPart:getVisible() or copyInvisibleParts then
            local copy = modelPart:copy(modelPart:getName())
            copy:setParentType("None")
			copy:setVisible(true)
            for _, child in ipairs(copy:getChildren()) do
                copy:removeChild(child)
                local childModel = self:copyModel(child, copyInvisibleParts)
                if childModel ~= nil then
                    copy:addChild(childModel)
                end
            end
            return copy
        end
    end,

	---初期化関数
	init = function ()
		events.TICK:register(function ()
			local gamemode = player:getGamemode()
			local healthPercent = player:getHealth() / player:getMaxHealth()
			local satisfactionPercent = player:getFood() / 20
			General.PlayerCondition = player:getFrozenTicks() == 140 and "LOW" or (((healthPercent > 0.5 and satisfactionPercent > 0.3) or (gamemode == "CREATIVE" or gamemode == "SPECTATOR")) and "HIGH" or ((healthPercent > 0.2 and satisfactionPercent > 0) and "MEDIUM" or "LOW"))
			if not client:isPaused() then
				General.EffectChecked = false
			end
		end)
	end
}

General:init()

return General