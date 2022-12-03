---@class Warden ウォーデンに怯える機能を制御するクラス
---@field Warden.WardenNearbyData table 前チックにウォーデンが近くにいたかどうかを調べる為にウォーデン情報を格納するテーブル
---@field Warden.WardenNearby boolean ウォーデンが近くにいるかどうか（=暗闇デバフを受けているかどうか）

Warden = {}

Warden.WardenNearbyData = {}
Warden.WardenNearby = false

events.TICK:register(function()
	Warden.WardenNearby = General.getStatusEffect("darkness") and true or false
	if Warden.WardenNearby then
		if not Warden.WardenNearbyData[1] and player:getPose() ~= "SLEEPING" then
			General.setAnimations("PLAY", "afraid")
		end
		Ears.setEarsRot("DROOPING", 1, true)
		FaceParts.setEmotion("SURPLISED", "SURPLISED", "CLOSED", 0, false)
	else
		General.setAnimations("STOP", "afraid")
		General.setAnimations("STOP", "right_hide_bell")
		General.setAnimations("STOP", "left_hide_bell")
	end
	table.insert(Warden.WardenNearbyData, Warden.WardenNearby)
	if #Warden.WardenNearbyData == 2 then
		table.remove(Warden.WardenNearbyData, 1)
	end
end)

return Warden