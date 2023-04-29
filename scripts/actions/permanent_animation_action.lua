---@class AnimationAction 時間制限のないアニメーションアクションの抽象クラス
PermanentAnimationAction = {
	---コンストラクタ
	---@param canPlayAnimation function アニメーションが再生可能かどうかを判断し、booleanで返す関数
	---@param partToShow ModelPart|table|nil アニメーションの再生時に表示させるモデルパーツ
	---@param partToHide ModelPart|table|nil アニメーション停止時に非表示にするモデルパーツ
	---@param primaryAnimation Animation 再生するメインのアニメーション。アニメーションの長さ取得にも使われる。
	---@param secondaryAnimation Animation|table|nil メインのアニメーションと同時に再生するアニメーション
	---@return table<any> instance インスタンス化されたクラス
	new = function (canPlayAnimation, partToShow, partToHide, primaryAnimation, secondaryAnimation)
		local instance = General.instance(PermanentAnimationAction, AnimationAction, canPlayAnimation, partToShow, partToHide, primaryAnimation, secondaryAnimation, 0)
		instance.AnimationCount = nil
		instance.AnimationLength = nil
		return instance
	end,

	---アクションを再生する。
	play = function (self)
		for _, modelPart in ipairs(self.PartToShow) do
			modelPart:setVisible(true)
		end
		for _, animationElement in ipairs(self.Animations) do
			animationElement:play()
		end
		Umbrella.Enabled = false
		self.IsAnimationPlaying = true
	end,

	---アクションを停止する。
	stop = function (self)
		for _, modelPart in ipairs(self.PartToHide) do
			modelPart:setVisible(false)
		end
		for _, animationElement in ipairs(self.Animations) do
			animationElement:stop()
		end
		Arms.hideHeldItem(false)
		FaceParts.resetEmotion()
		Umbrella.Enabled = true
		self.IsAnimationPlaying = false
	end,

	---アニメーション再生中に毎チック実行される関数
	onAnimationTick = function (self)
		if not self:checkAction() then
			self:stop()
		end
	end
}

return PermanentAnimationAction