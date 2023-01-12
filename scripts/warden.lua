---@class Warden ウォーデンに怯える機能を制御するクラス
---@field Warden.WardenNearby boolean ウォーデンが近くにいるかどうか（=暗闇デバフを受けているかどうか）
---@field Warden.WardenNearbyPrev boolean 前チックにウォーデンが近くにいたかどうか

Warden = {
	WardenNearby = false,
	WardenNearbyPrev = false
}

--ping関数
function pings.setWardenNearby(newValue)
	Warden.WardenNearby = newValue
end

events.TICK:register(function()
	if host:isHost() then
		Warden.WardenNearby = General.getTargetEffect("darkness") and true or false
	end
	if Warden.WardenNearby then
		if not Warden.WardenNearbyPrev and player:getPose() ~= "SLEEPING" then
			pings.setWardenNearby(true)
			if player:getPose() ~= "SLEEPING" then
				animations["models.main"]["afraid"]:play()
			end
		end
		Ears.setEarsRot("DROOPING", 1, true)
		FaceParts.setEmotion("SURPLISED", "SURPLISED", "CLOSED", 0, false)
	else
		if Warden.WardenNearbyPrev then
			pings.setWardenNearby(false)
		end
		animations["models.main"]["afraid"]:stop()
	end
	Warden.WardenNearbyPrev = Warden.WardenNearby
end)

return Warden