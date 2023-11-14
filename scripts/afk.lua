---@class Afk 放置時のアクションを管理するクラス

---放置時間
---@type integer
local afkCount = 0

---AFKが停止された時に呼ばれる関数
local function onStopAfk ()
	if afkCount >= 72000 and host:isHost() then
		print(Language.getTranslate("message__afk_too_long"))
	end
	afkCount = 0
end

events.TICK:register(function ()
	if host:isHost() then
		afkCount = afkCount + 1
	end
end)

events.KEY_PRESS:register(function ()
	onStopAfk()
end)

events.MOUSE_MOVE:register(function ()
	onStopAfk()
end)

events.MOUSE_PRESS:register(function ()
	onStopAfk()
end)

events.MOUSE_SCROLL:register(function ()
	onStopAfk()
end)