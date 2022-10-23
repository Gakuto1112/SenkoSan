---@class WardenClass ウォーデンに怯える機能を制御するクラス
---@field WardenNearbyData table 前チックにウォーデンが近くにいたかどうかを調べる為にウォーデン情報を格納するテーブル
---@field WardenClass.WardenNearby boolean ウォーデンが近くにいるかどうか（=暗闇デバフを受けているかどうか）

WardenClass = {}

WardenNearbyData = {}
WardenClass.WardenNearby = false

events.TICK:register(function()
	WardenClass.WardenNearby = General.getStatusEffect("darkness") and true or false
	if WardenClass.WardenNearby then
		if not WardenNearbyData[1] and player:getPose() ~= "SLEEPING" then
			General.setAnimations("PLAY", "afraid")
		end
		EarsClass.setEarsRot("DROOPING", 1, true)
		FacePartsClass.setEmotion("SURPLISED", "SURPLISED", "CLOSED", 0, false)
	else
		General.setAnimations("STOP", "afraid")
		General.setAnimations("STOP", "right_hide_bell")
		General.setAnimations("STOP", "left_hide_bell")
	end
	table.insert(WardenNearbyData, WardenClass.WardenNearby)
	if #WardenNearbyData == 2 then
		table.remove(WardenNearbyData, 1)
	end
end)

return WardenClass