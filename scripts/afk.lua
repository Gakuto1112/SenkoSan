---@class Afk 放置時のアクションを管理するクラス
---@field Afk.AfkCount integer 放置時間
---@field Afk.KotatsuPlayedByAfk boolean こたつアニメーションがAFK判定によって再生されたかどうか
---@field Afk.LookDirPrev Vector3 前チックの視点方向

Afk = {
	AfkCount = 0,
	KotatsuPlayedByAfk = false,
	LookDIrPrev = 0
}

events.TICK:register(function ()
	if not client:isPaused() then
		local lookDir = player:getLookDir()
		if player:getVelocity():length() == 0 and lookDir == Afk.LookDIrPrev and Hurt.Damaged == "NONE" and Wet.WetCount == 0 and not Warden.WardenNearby and not General.IsSneaking and not player:isUsingItem() and not action_wheel:isEnabled() and not Tail.WagTailKey:isPressed() and not Ears.JerkEarsKey:isPressed() then
			Afk.AfkCount = Afk.AfkCount + 1
		else
			if Afk.AfkCount >= 6000 and Afk.KotatsuPlayedByAfk then
				Kotatsu:stop()
				Afk.KotatsuPlayedByAfk = false
			end
			Afk.AfkCount = 0
		end
		print(Afk.AfkCount) --デバッグ用出力
		if not Kotatsu.IsAnimationPlaying then
			if Afk.AfkCount == 6000 then
				Kotatsu:play()
				Afk.KotatsuPlayedByAfk = true
			elseif Afk.AfkCount < 6000 and Afk.AfkCount > 0 and Afk.AfkCount % 1200 == 0 then
				TailBrush:play()
			end
		end
		Afk.LookDIrPrev = lookDir
	end
end)

return Afk