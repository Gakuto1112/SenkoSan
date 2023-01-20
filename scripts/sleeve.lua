---@class Sleeve 袖を操作する関数を提供するクラッシュ

---@alias Sleeve.SleeveSide
---| "BOTH"
---| "RIGHT"
---| "LEFT"

---@alias Sleeve.SleeveDirection
---| "LOWER"
---| "UPPER"

Sleeve = {
	---袖の基点を変更する。
	---@param side Sleeve.SleeveSide 設定する袖の側
	---@param direction Sleeve.SleeveDirection 設定する袖の基点
	movePivot = function (side, direction)
		if side == "RIGHT" or side == "BOTH" then
			models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase:setPivot(5.5, direction == "LOWER" and 19 or 14, 2)
			models.models.main.Avatar.Body.Arms.RightArm.RightArmBottom.RightSleeveBase.RightSleeve:setPivot(5.5, direction == "LOWER" and 19 or 14, 4)
		end
		if side == "LEFT" or side == "BOTH" then
			models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase:setPivot(-5.5, direction == "LOWER" and 19 or 14, 2)
			models.models.main.Avatar.Body.Arms.LeftArm.LeftArmBottom.LeftSleeveBase.LeftSleeve:setPivot(-5.5, direction == "LOWER" and 19 or 14, 4)
		end
	end
}

return Sleeve