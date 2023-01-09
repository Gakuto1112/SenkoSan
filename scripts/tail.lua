---@class Tail 尻尾を制御するクラス
---@field Tail.WagTailKey Keybind 尻尾振りをするキー
---@field Tail.WagTailCount integer 尻尾振りの時間を計るカウンター

Tail = {}

Tail.WagTailKey = keybinds:newKeybind(Language.getTranslate("key_name__wag_tail"), Config.loadConfig("keybind.wagTail", "key.keyboard.z"))
Tail.WagTailCount = -1

--ping関数
---尻尾を振る
function pings.wag_tail()
	animations["models.main"]["wag_tail"]:play()
	Tail.WagTailCount = 25
end

events.TICK:register(function ()
	if Wet.WetCount == 0 then
		if Tail.WagTailCount == 18 then
			sounds:playSound("block.grass.step", player:getPos(), 1, 1)
		elseif Tail.WagTailCount == 25 or Tail.WagTailCount == 13 then
			sounds:playSound("block.grass.step", player:getPos(), 0.5, 1)
		end
	end
	if not Tail.WagTailKey:isDefault() then
		local newKey = Tail.WagTailKey:getKey()
		Config.saveConfig("keybind.wagTail", newKey)
		Tail.WagTailKey:setKey(newKey)
	end
	Tail.WagTailCount = Tail.WagTailCount > 0 and Tail.WagTailCount - 1 or 0
end)

Tail.WagTailKey:onPress(function ()
	if Tail.WagTailCount == 0 and not Kotatsu.IsAnimationPlaying then
		pings.wag_tail()
	end
end)

return Tail