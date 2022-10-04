---@class HurtClass プレイヤーのダメージを管理するクラス
---@field HealthData table ダメージを受けたかどうか判定する為にHP情報を格納するテーブル
---@field HurtClass.Damaged HurtClass プレイヤーのダメージの検証結果

---@alias DamageType
---| "NONE"
---| "DAMAGED"
---| "DIED"

HurtClass = {}

HealthData = {}
HurtClass.Damaged = "NONE"

events.TICK:register(function ()
	local health = player:getHealth()
	table.insert(HealthData, health)
	if #HealthData == 3 then
		table.remove(HealthData, 1)
	end
	if health < HealthData[1] then
		if health == 0 then
			setEmotion("SURPLISED", "SURPLISED", "CLOSED", 20, true)
			HurtClass.Damaged = "DIED"
		else
			setEmotion("SURPLISED", "SURPLISED", "CLOSED", 8, true)
			HurtClass.Damaged = "DAMAGED"
		end
	else
		HurtClass.Damaged = "NONE"
	end
end)

return HurtClass