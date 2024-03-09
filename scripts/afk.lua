---@class Afk 放置時のアクションを管理するクラス
---@field AfkCount integer 放置時間
---@field AfkAnimationCount integer 放置アニメーションを再生するタイミングを計るカウンター
---@field LookDirPrev Vector3 前チックの視点方向
---@field TailBrushByAfk boolean 尻尾手入れのアニメーションがAFKによって再生されているかどうか
Afk = {
	AfkCount = 0,
	AfkAnimationCount = 0,
	LookDIrPrev = 0,
	TailBrushByAfk = false,

	---AFKが停止された時に呼ばれる関数
	onStopAfk = function ()
		if Afk.AfkCount >= 72000 and host:isHost() then
			print(Language.getTranslate("message__afk_too_long"))
		end
		if Afk.AfkAnimationCount >= 6000 then
			---@diagnostic disable-next-line: undefined-field
			TailBrush:stop()
		end
		if Afk.TailBrushByAfk then
			pings.afkTailBrushStop()
			Afk.TailBrushByAfk = false
		end
		Afk.AfkCount = 0
		Afk.AfkAnimationCount = 0
	end
}

--ping関数
function pings.afkTailBrush()
	---@diagnostic disable-next-line: undefined-field
	TailBrush:play()
end

function pings.afkTailBrushStop()
	---@diagnostic disable-next-line: undefined-field
	TailBrush:stop()
end

function pings.afkKotatsu()
	---@diagnostic disable-next-line: undefined-field
	Kotatsu:play()
end

events.TICK:register(function ()
	if host:isHost() then
		if not client:isPaused() then
			if Afk.AfkCount >= 1 then
				local lookDir = player:getLookDir()
				---@diagnostic disable-next-line: undefined-field
				if Afk.AfkAnimationCount == 6000 and Kotatsu:checkAction() then
					pings.afkKotatsu()
					---@diagnostic disable-next-line: undefined-field
				elseif Afk.AfkAnimationCount > 0 and Afk.AfkAnimationCount % 1200 == 0 and not Umbrella.IsUsing and not Kotatsu.IsAnimationPlaying then
					pings.afkTailBrush()
					Afk.TailBrushByAfk = true
				end
				Afk.AfkAnimationCount = (player:getVelocity():length() == 0 and lookDir == Afk.LookDIrPrev and Hurt.Damaged == "NONE" and player:getPose() == "STANDING" and Wet.WetCount == 0 and not Umbrella.IsUsing and not Warden.WardenNearby and type(player:getVehicle()) == "nil" and PhotoPose.CurrentPose == 0) and Afk.AfkAnimationCount + 1 or 0
				Afk.LookDIrPrev = lookDir
			end
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