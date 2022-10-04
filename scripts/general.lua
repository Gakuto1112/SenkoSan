---@class General 他の複数のクラスが参照するフィールドや関数を定義するクラス

---@alias AnimationState
---| "PLAY"
---| "STOP"

General = {}

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

return General