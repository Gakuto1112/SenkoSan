---@class AnimationAction アニメーションアクションの抽象クラス

AnimationAction = {
	---コンストラクタ
	---@param canPlayAnimation function アニメーションが再生可能かどうかを判断し、booleanで返す関数
	---@param partToShow ModelPart|table|nil アニメーションの再生時に表示させるモデルパーツ
	---@param partToHide ModelPart|table|nil アニメーション停止時に非表示にするモデルパーツ
	---@param primaryAnimation Animation 再生するメインのアニメーション。アニメーションの長さ取得にも使われる。
	---@param secondaryAnimation Animation|table|nil メインのアニメーションと同時に再生するアニメーション
	---@param additionalAnimationCount integer 追加のアニメーションカウント
	---@return table インスタンス化されたクラス
	new = function(canPlayAnimation, partToShow, partToHide, primaryAnimation, secondaryAnimation, additionalAnimationCount)
		local instace = General.instance(AnimationAction)
		instace.CheckFunction = canPlayAnimation --アニメーションが再生可能か確認する関数
		instace.CanPlayAnimation = false --アニメーションが再生可能かどうか
		instace.AnimationChecked = false --このチックでアニメーションが再生可能かどうかを確認したかどうか
		instace.AnimationCount = 0 --アニメーションのタイミングを計るカウンター
		instace.AnimationLength = math.ceil(primaryAnimation:getLength() * 20) + additionalAnimationCount --メインのアニメーションの長さ
		instace.Animations = {primaryAnimation} --再生・停止するアニメーションのリスト
		if secondaryAnimation then
			if type(secondaryAnimation) == "Animation" then
				table.insert(instace.Animations, secondaryAnimation)
			else
				for _, animationElement in ipairs(secondaryAnimation) do
					table.insert(instace.Animations, animationElement)
				end
			end
		end
		instace.PartToShow = {} --アニメーション再生時に表示させるモデルパーツ
		if partToShow then
			if type(partToShow) == "ModelPart" then
				table.insert(instace.PartToShow, partToShow)
			else
				for _, modelPart in ipairs(partToShow) do
					table.insert(instace.PartToShow, modelPart)
				end
			end
		end
		instace.PartToHide = {} --アニメーション停止時に非表示にするモデルパーツ
		if partToHide then
			if type(partToHide) == "ModelPart" then
				table.insert(instace.PartToHide, partToHide)
			else
				for _, modelPart in ipairs(partToHide) do
					table.insert(instace.PartToHide, modelPart)
				end
			end
		end
		instace.HideHeldItem = true --アニメーション再生中に手持ちアイテムを隠すかどうか
		events.TICK:register(function ()
			if instace.AnimationCount > 0 then
				if instace.HideHeldItem then
					for index, vanillaModelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
						if player:getHeldItem(player:isLeftHanded() == (index == 1)) ~= "minecraft:air" then
							vanillaModelPart:setVisible(false)
							ArmsClass.ItemHeldContradicts[index] = true
						else
							vanillaModelPart:setVisible(true)
							ArmsClass.ItemHeldContradicts[index] = false
						end
					end
				else
					for _, vanillaModelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
						vanillaModelPart:setVisible(true)
						ArmsClass.ItemHeldContradicts = {true, true}
					end
				end
				instace:onAnimationTick()
				instace.AnimationCount = (instace.AnimationCount > 0 and not client:isPaused()) and instace.AnimationCount - 1 or instace.AnimationCount
				instace.AnimationChecked = false
			end
		end)
		return instace
	end,

	---アクションが再生可能か確認する。
	actionCheck = function (self)
		if not self.AnimationChecked then
			self.CanPlayAnimation = self.CheckFunction()
			self.AnimationChecked = true
		end
	end,

	---アクションを再生する。
	play = function (self)
		for _, modelPart in ipairs(self.PartToShow) do
			modelPart:setVisible(true)
		end
		for _, animationElement in ipairs(self.Animations) do
			animationElement:play()
		end
		self.AnimationCount = self.AnimationLength
	end,

	---アクションを停止する。
	stop = function (self)
		for _, modelPart in ipairs(self.PartToHide) do
			modelPart:setVisible(false)
		end
		for _, animationElement in ipairs(self.Animations) do
			animationElement:stop()
		end
		self.AnimationCount = 0
	end,

	---アニメーション再生中に毎チック実行される関数
	onAnimationTick = function (self)
		if self.AnimationCount == 1 then
			self:stop()
		end
	end
}

return AnimationAction