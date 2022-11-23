---@class クリスマスメッセージを制御するクラス
---@field MelodyCount integer メロディー再生のタイミングを計るカウンター

ChristmasClass = {}

MelodyCount = -1

events.TICK:register(function ()
	if MelodyCount >= 0 then
		if MelodyCount == 0 or MelodyCount == 8 or MelodyCount == 16 or MelodyCount == 28 or MelodyCount == 32 or MelodyCount == 80 then
			--シ♭
			sounds:playSound("block.note_block.chime", player:getPos(), 1, 1.259921)
		elseif MelodyCount == 40 or MelodyCount == 48 or MelodyCount == 56 then
			--ラ
			sounds:playSound("block.note_block.chime", player:getPos(), 1, 1.189207)
		elseif MelodyCount == 64 or MelodyCount == 72 then
			--ド
			sounds:playSound("block.note_block.chime", player:getPos(), 1, 1.414214)
		elseif MelodyCount == 88 then
			--ソ
			sounds:playSound("block.note_block.chime", player:getPos(), 1, 1.059463)
		elseif MelodyCount == 96 then
			--ファ
			sounds:playSound("block.note_block.chime", player:getPos(), 1, 0.943874)
			MelodyCount = -1
			return
		end
		MelodyCount = MelodyCount + 1
	end
end)

if host:isHost() and CostumeClass.CurrentCostume == "SANTA" then
	---西暦1年1月1日からの経過日数を返す。
	---@param year integer
	---@param month integer
	---@param day integer
	---@return integer daysElapsed 西暦1年1月1日からの経過日数
	function getDaysElapsed(year, month, day)
		return 365 * (year - 1) + math.floor(year / 4) - math.floor(year / 100) + math.floor(year / 400) + 59 + math.floor(306 * ((month <= 2 and month + 12 or month) + 1) / 10) - 122 + day
	end

	local now = client:getSystemTime() / 1000
	local day = math.floor(now / 86400)
	local year = 1970 + math.floor(day / 365.2425)
	local daysElapsedFromNewYear = day - getDaysElapsed(year, 1, 1) + getDaysElapsed(1970, 1, 1)
	if daysElapsedFromNewYear >= 357 and daysElapsedFromNewYear <= 359 then
		print(LanguageClass.getTranslate("message__merry_christmas"))
		MelodyCount = 0
	end
end

return ChristmasClass