---@class Afk 放置時のアクションを管理するクラス
---@field Afk.AfkCount integer 放置時間
---@field Afk.LookDirPrev Vector3 前チックの視点方向

Afk = {
	AfkCount = 0,
	LookDIrPrev = 0
}

events.TICK:register(function ()
	if not client:isPaused() then
		local lookDir = player:getLookDir()
		if player:getVelocity():length() == 0 and lookDir == Afk.LookDIrPrev and Hurt.Damaged == "NONE" and Wet.WetCount == 0 and not Warden.WardenNearby and not General.IsSneaking and not player:isUsingItem() and not action_wheel:isEnabled() and not Tail.WagTailKey:isPressed() and not Ears.JerkEarsKey:isPressed() then
			Afk.AfkCount = Afk.AfkCount + 1
		else
			if Afk.AfkCount >= 216000 and host:isHost() then
				print(Language.getTranslate("message__afk_too_long"))
			end
			if Afk.AfkCount >= 6000 then
				Kotatsu:stop()
			end
			Afk.AfkCount = 0
		end
		if not Kotatsu.IsAnimationPlaying then
			if Afk.AfkCount == 6000 then
				Kotatsu:play()
			elseif Afk.AfkCount < 6000 and Afk.AfkCount > 0 and Afk.AfkCount % 1200 == 0 then
				TailBrush:play()
			end
		end
		Afk.LookDIrPrev = lookDir
	end
end)

return Afk