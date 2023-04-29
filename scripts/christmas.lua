---@class クリスマスメッセージを制御するクラス
---@field MelodyCount integer メロディー再生のタイミングを計るカウンター
Christmas = {
	MelodyCount = -1
}

events.TICK:register(function ()
	if Christmas.MelodyCount >= 0 then
		if Christmas.MelodyCount == 0 or Christmas.MelodyCount == 8 or Christmas.MelodyCount == 16 or Christmas.MelodyCount == 28 or Christmas.MelodyCount == 32 or Christmas.MelodyCount == 80 then
			--シ♭
			sounds:playSound("block.note_block.chime", player:getPos(), 1, 1.259921)
		elseif Christmas.MelodyCount == 40 or Christmas.MelodyCount == 48 or Christmas.MelodyCount == 56 then
			--ラ
			sounds:playSound("block.note_block.chime", player:getPos(), 1, 1.189207)
		elseif Christmas.MelodyCount == 64 or Christmas.MelodyCount == 72 then
			--ド
			sounds:playSound("block.note_block.chime", player:getPos(), 1, 1.414214)
		elseif Christmas.MelodyCount == 88 then
			--ソ
			sounds:playSound("block.note_block.chime", player:getPos(), 1, 1.059463)
		elseif Christmas.MelodyCount == 96 then
			--ファ
			sounds:playSound("block.note_block.chime", player:getPos(), 1, 0.943874)
			Christmas.MelodyCount = -1
			return
		end
		Christmas.MelodyCount = Christmas.MelodyCount + 1
	end
end)

if host:isHost() and Costume.CurrentCostume == "SANTA" then
	local date = client:getDate()
	if date.month == 12 and date.day >= 24 and date.day <= 26 then
		print(Language.getTranslate("message__merry_christmas"))
		Christmas.MelodyCount = 0
	end
end

return Christmas