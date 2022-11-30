---@class TailClass 尻尾を制御するクラス
---@field WagTailKey Keybind 尻尾振りをするキー
---@field WagTailCount integer 尻尾振りの時間を計るカウンター

TailClass = {}

WagTailKey = keybinds:newKeybind(LanguageClass.getTranslate("key_name__wag_tail"), ConfigClass.loadConfig("keybind.wagTail", "key.keyboard.z"))
WagTailCount = -1

--ping関数
---尻尾を振る
function pings.wag_tail()
	General.setAnimations("PLAY", "wag_tail")
	WagTailCount = 25
end

events.TICK:register(function ()
	if WetClass.WetCount == 0 then
		if WagTailCount == 18 then
			sounds:playSound("block.grass.step", player:getPos(), 1, 1)
		elseif WagTailCount == 25 or WagTailCount == 13 then
			sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
		end
	end
	if not WagTailKey:isDefault() then
		local newKey = WagTailKey:getKey()
		ConfigClass.saveConfig("keybind.wagTail", newKey)
		WagTailKey:setKey(newKey)
	end
	WagTailCount = WagTailCount > 0 and WagTailCount - 1 or 0
end)

WagTailKey.onPress = function ()
	if WagTailCount == 0 and not General.isAnimationPlaying("models.main", "kotatsu") then
		pings.wag_tail()
	end
end

return TailClass