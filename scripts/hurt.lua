---@alias DamageType
---| "NONE"
---| "DAMAGED"
---| "DIED"

---@class Hurt プレイヤーのダメージを管理するクラス
---@field HealthPrev integer 前チックのHP
---@field Damaged DamageType プレイヤーのダメージの検証結果
Hurt = {
	HealthPrev = -1,
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
		if host:isHost() and health > 0 and Hurt.HealthPrev == 0 and player:getGamemode() ~= "SPECTATOR" and General.ShowMessage then
			print(Language.getTranslate("message__respawn"))
		end
		Hurt.Damaged = "NONE"
	end
	Hurt.HealthPrev = health
end)

return Hurt