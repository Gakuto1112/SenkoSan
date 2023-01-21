---@class Afk 放置時のアクションを管理するクラス
---@field Afk.AfkCount integer 放置時間
---@field Afk.AfkAnimationCount integer 放置アニメーションを再生するタイミングを計るカウンター

Afk = {
	AfkCount = 0,
	AfkAnimationCount = 0,

	---AFKが停止された時に呼ばれる関数
	onStopAfk = function ()
		if Afk.AfkCount >= 216000 and host:isHost() then
			print(Language.getTranslate("message__afk_too_long"))
		end
		if Afk.AfkAnimationCount >= 6000 then
			Kotatsu:stop()
		end
		Afk.AfkCount = 0
		Afk.AfkAnimationCount = 0
	end
}

events.TICK:register(function ()
	if not client:isPaused() then
		if Afk.AfkCount >= 1 then
			if Afk.AfkAnimationCount == 6000 and Kotatsu:checkAction() then
				Kotatsu:play()
			elseif Afk.AfkAnimationCount > 0 and Afk.AfkAnimationCount % 1200 == 0 and not Umbrella.Umbrella and not Kotatsu.IsAnimationPlaying then
				TailBrush:play()
			end
			Afk.AfkAnimationCount = (Hurt.Damaged == "NONE" and not General.IsSneaking and Wet.WetCount == 0 and not Umbrella.Umbrella and not Warden.WardenNearby) and Afk.AfkAnimationCount + 1 or 0
		end
		Afk.AfkCount = Afk.AfkCount + 1
	end
end)

events.KEY_PRESS:register(function ()
	Afk.onStopAfk()
end)

events.MOUSE_MOVE:register(function ()
	Afk.onStopAfk()
end)

events.MOUSE_PRESS:register(function ()
	Afk.onStopAfk()
end)

events.MOUSE_SCROLL:register(function ()
	Afk.onStopAfk()
end)

return Afk