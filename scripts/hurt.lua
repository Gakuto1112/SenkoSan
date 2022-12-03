---@class Hurt プレイヤーのダメージを管理するクラス
---@field HealthData table ダメージを受けたかどうか判定する為にHP情報を格納するテーブル
---@field Hurt.Damaged DamageType プレイヤーのダメージの検証結果

---@alias DamageType
---| "NONE"
---| "DAMAGED"
---| "DIED"

Hurt = {}

HealthData = {}
Hurt.Damaged = "NONE"

events.TICK:register(function ()
	local health = player:getHealth()
	table.insert(HealthData, health)
	if #HealthData == 3 then
		table.remove(HealthData, 1)
	end
	if health < HealthData[1] then
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
end)

return Hurt