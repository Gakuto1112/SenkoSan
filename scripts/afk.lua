---@class Afk 放置時のアクションを管理するクラス
---@field Afk.AfkCount integer 放置時間
---@field Afk.BodyYawPrev integer 前チックの体のヨー

Afk = {
	AfkCount = 0,
	BodyYawPrev = 0
}

events.TICK:register(function ()
	local bodyYaw = player:getBodyYaw()
	Afk.AfkCount = (player:getVelocity():length() == 0 and bodyYaw == Afk.BodyYawPrev and Hurt.Damaged == "NONE" and Wet.WetCount == 0 and not Warden.WardenNearby and not General.IsSneaking and not player:isUsingItem() and not action_wheel:isEnabled() and not Tail.WagTailKey:isPressed() and not Ears.JerkEarsKey:isPressed()) and Afk.AfkCount + 1 or 0
	Afk.BodyYawPrev = bodyYaw
end)

return Afk