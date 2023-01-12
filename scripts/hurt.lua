---@class Hurt プレイヤーのダメージを管理するクラス
---@field Hurt.HealthPrev integer 前チックのHP
---@field Hurt.Damaged Hurt.DamageType プレイヤーのダメージの検証結果

---@alias Hurt.DamageType
---| "NONE"
---| "DAMAGED"
---| "DIED"

Hurt = {
	HealthPrev = 0,
	Damaged = "NONE"
}

events.TICK:register(function ()
	local health = player:getHealth()
	if health < Hurt.HealthPrev then
		if health == 0 then
			FaceParts.setEmotion("SURPLISED", "SURPLISED", "CLOSED", 20, true)
			Hurt.Damaged = "DIED"
		else
			FaceParts.setEmotion("SURPLISED", "SURPLISED", "CLOSED", 8, true)
			Hurt.Damaged = "DAMAGED"
		end
	else
		Hurt.Damaged = "NONE"
	end
	Hurt.HealthPrev = health
end)

return Hurt