---@class LanguageClass アバターの表示言語を管理するクラス
---@field LanguageData table 言語データ

LanguageClass = {}

LanguageData = {
	en_us = {
		language__en_us = "English",
		language__ja_jp = "Japanese",
		key_name__wag_tail = "Wag tail",
		key_name__jerk_ears = "Jerk ears",
		key_name__jump = "Jump",
		costume__default = "Default costume",
		costume__nightwear = "Nightwear costume",
		costume__disguise = "Disguise costume",
		costume__maid_a = "Maid costume A",
		costume__maid_b = "Maid costume B",
		costume__swimsuit = "Swimsuit",
		costume__cheerleader = "Cheerleader costume",
		costume__purification = "Purification clothes",
		costume__kappogi = "Kappogi (cook's apron)",
		costume__yukata = "Yukata",
		costume__knit = "Knitted hat",
		costume__fox_hoodie_red = "Fox hoodie (red)",
		costume__fox_hoodie_white = "Fox hoodie (white)",
		costume__santa = "Santa costume",
		action_wheel__toggle_off = "§coff",
		action_wheel__toggle_on = "§aon",
		action_wheel__refuse_action = "(It is not the time... I have a strong feeling bad sign...)",
		action_wheel__close_to_confirm = "(Close action wheel to confirm.)",
		action_wheel__main__action_8__title = "Change pages §7(scroll)§r: §b",
		action_wheel__main_1__action_1__title = "Uyan♪",
		action_wheel__main_1__action_2__title = "Body shake",
		action_wheel__main_1__action_2__unavailable = "I cannot do body shake now.",
		action_wheel__main_1__action_3__title = "Broom cleaning",
		action_wheel__main_1__action_3__unavailable = "I cannot clean now.",
		action_wheel__main_1__action_4__title = "Hair cut",
		action_wheel__main_1__action_4__unavailable = "I cannot give you a haircut now.",
		action_wheel__main_1__action_5__title = "Fox jump",
		action_wheel__main_1__action_5__unavailable = "I cannot jump here.",
		action_wheel__main_1__action_6__title = "Tail brushing",
		action_wheel__main_1__action_6__unavailable = "I cannot brush my tail now.",
		action_wheel__main_1__action_7__title = "Kotatsu",
		action_wheel__main_1__action_7__unavailable = "I cannot feel at home now.",
		action_wheel__main_1__action_7__start = "Loosely",
		action_wheel__main_2__action_1__title = "Sit down",
		action_wheel__main_2__action_1__unavailable = "I cannot sit down now.",
		action_wheel__main_2__action_2__title = "Cuddle tail",
		action_wheel__main_2__action_2__unavailable = "I cannot let you cuddle now.",
		action_wheel__main_2__action_3__title = "Earpick",
		action_wheel__main_2__action_3__unavailable = "I will clean your ears after I sit down!",
		action_wheel__main_2__action_4__title = "Tea time",
		action_wheel__main_2__action_4__unavailable = "I will sip tea after I sit down!",
		action_wheel__main_2__action_5__title = "Massage",
		action_wheel__main_2__action_5__unavailable = "I will massage you after I sit down!",
		action_wheel__main_3__action_1__title = "Senko san line collection",
		action_wheel__main_3__action_2__title = "Senko san config",
		action_wheel__word__action_1__title = "Let you pamper me as much as you like!",
		action_wheel__word__action_2__title = "Let you cuddle my tail as much as you like!",
		action_wheel__word__action_3__title = "Welcome back!",
		action_wheel__word__action_4__title = "You must be tired!",
		action_wheel__word__action_5__title = "It must have been a tough day for you. Good work today.",
		action_wheel__word__action_6__title = "Uyan♪",
		action_wheel__word__action_7__title = "I'm just a moving ball of fur...",
		action_wheel__word__action_8__title = "I will try other languages §7(scroll)§r: §b",
		action_wheel__word__action_8__bracket_begin = "(",
		action_wheel__word__action_8__bracket_end = ")",
		action_wheel__config__action_1__title = "What costume should I wear? §7(scroll)§r: ",
		action_wheel__config__action_1__done_first = "I changed my clothers to §b",
		action_wheel__config__action_1__done_last = "§r!",
		action_wheel__config__action_2__title = "What should I be called? §7(scroll)§r: ",
		action_wheel__config__action_2__done_first = "I changed my name to §b",
		action_wheel__config__action_2__done_last = "§r!",
		action_wheel__config__action_3__title = "Auto shake: ",
		action_wheel__config__action_4__title = "Show armor: ",
		action_wheel__config__action_5__title = "Show fox fire in first person: ",
		action_wheel__config__action_6__title = "Umbrella sound：",
		message__merry_christmas = "Merry Christmas!"
	},
	ja_jp = {
		language__en_us = "英語",
		language__ja_jp = "日本語",
		key_name__wag_tail = "尻尾ふりふり",
		key_name__jerk_ears = "お耳ぴくぴく",
		key_name__jump = "じゃんぷ",
		costume__default = "いつもの服",
		costume__nightwear = "寝巻き",
		costume__disguise = "変装服",
		costume__maid_a = "めいど服A",
		costume__maid_b = "めいど服B",
		costume__swimsuit = "水着",
		costume__cheerleader = "ちありーだーの服",
		costume__purification = "清めの服",
		costume__kappogi = "割烹着",
		costume__yukata = "浴衣",
		costume__knit = "にっと帽",
		costume__fox_hoodie_red = "きつねぱーかー（赤）",
		costume__fox_hoodie_white = "きつねぱーかー（白）",
		costume__santa = "さんたさんの服",
		action_wheel__toggle_off = "§cおふ",
		action_wheel__toggle_on = "§aおん",
		action_wheel__refuse_action = "（今はそれどころじゃないのじゃ...何かよからぬ気配を強く感じるのじゃ...）",
		action_wheel__close_to_confirm = "（あくしょんほいーるを閉じて確定なのじゃ。）",
		action_wheel__main__action_8__title = "ぺーじ切り替え§7（すくろーる）§r：§b",
		action_wheel__main_1__action_1__title = "うやん♪",
		action_wheel__main_1__action_2__title = "ぶるぶる",
		action_wheel__main_1__action_2__unavailable = "今はぶるぶるできないのじゃ。",
		action_wheel__main_1__action_3__title = "お掃除",
		action_wheel__main_1__action_3__unavailable = "今は掃除できないのじゃ。",
		action_wheel__main_1__action_4__title = "散髪",
		action_wheel__main_1__action_4__unavailable = "今は髪を切ってあげられないのじゃ。",
		action_wheel__main_1__action_5__title = "きつねじゃんぷ",
		action_wheel__main_1__action_5__unavailable = "ここでは跳べないのじゃ。",
		action_wheel__main_1__action_6__title = "尻尾の手入れ",
		action_wheel__main_1__action_6__unavailable = "今は手入れできないのじゃ。",
		action_wheel__main_1__action_7__title = "こたつ",
		action_wheel__main_1__action_7__unavailable = "今はだらーんできないのじゃ。",
		action_wheel__main_1__action_7__start = "だら～ん",
		action_wheel__main_2__action_1__title = "おすわり",
		action_wheel__main_2__action_1__unavailable = "今は座れないのじゃ。",
		action_wheel__main_2__action_2__title = "尻尾もふもふ",
		action_wheel__main_2__action_2__unavailable = "今はもふもふしてあげられないのじゃ。",
		action_wheel__main_2__action_3__title = "耳かき",
		action_wheel__main_2__action_3__unavailable = "座ってから耳かきをするかのう。",
		action_wheel__main_2__action_4__title = "お茶",
		action_wheel__main_2__action_4__unavailable = "座ってからお茶をすすろうかのう。",
		action_wheel__main_2__action_5__title = "まっさーじ",
		action_wheel__main_2__action_5__unavailable = "座ってからお主をほぐそうかのう。",
		action_wheel__main_3__action_1__title = "仙狐さんせりふ集",
		action_wheel__main_3__action_2__title = "仙狐さん設定",
		action_wheel__word__action_1__title = "存分に甘やかしてくれよう！",
		action_wheel__word__action_2__title = "存分にもふるがよい！",
		action_wheel__word__action_3__title = "おかえりなのじゃ～",
		action_wheel__word__action_4__title = "お疲れ様じゃ。",
		action_wheel__word__action_5__title = "今日も大変だったのう～",
		action_wheel__word__action_6__title = "うやん♪",
		action_wheel__word__action_7__title = "わらわはただの動く毛玉じゃ...",
		action_wheel__word__action_8__title = "わらわもよその国の言葉に挑戦しようかのう§7（すくろーる）§r: §b",
		action_wheel__word__action_8__bracket_begin = "（",
		action_wheel__word__action_8__bracket_end = "）",
		action_wheel__config__action_1__title = "わらわは何を着ればよいのじゃ？§7（すくろーる）§r：",
		action_wheel__config__action_1__done_first = "§b",
		action_wheel__config__action_1__done_last = "§rに着替えたのじゃ。",
		action_wheel__config__action_2__title = "わらわは何と呼ばれればよいのじゃ？§7（すくろーる）§r: ",
		action_wheel__config__action_2__done_first = "わらわの呼び名を§b",
		action_wheel__config__action_2__done_last = "§rに変更したのじゃ。",
		action_wheel__config__action_3__title = "自動ぶるぶる：",
		action_wheel__config__action_4__title = "防具の表示：",
		action_wheel__config__action_5__title = "一人称視点での狐火の表示：",
		action_wheel__config__action_6__title = "傘の開閉音：",
		message__merry_christmas = "めりーくりすますなのじゃ！"
	}
}

---翻訳キーに対する訳文を返す。設定言語が存在しない場合は英語の文が返される。また、指定したキーの訳が無い場合は英語->キーそのままが返される。
---@param keyName string 翻訳キー
---@param languageName string|nil 言語名。nilの場合は現在の言語になる。
---@return string translatedString 翻訳キーに対する翻訳データ。設定言語での翻訳が存在しない場合は英文が返される。英文すら存在しない場合は翻訳キーがそのまま返される。
function LanguageClass.getTranslate(keyName, languageName)
	if languageName then
		return (LanguageData[languageName] and LanguageData[languageName][keyName]) and LanguageData[languageName][keyName] or (LanguageData["en_us"][keyName] and LanguageData["en_us"][keyName] or keyName)
	else
		local activeLanguage = client:getActiveLang()
		return (LanguageData[activeLanguage] and LanguageData[activeLanguage][keyName]) and LanguageData[activeLanguage][keyName] or (LanguageData["en_us"][keyName] and LanguageData["en_us"][keyName] or keyName)
	end
end

---利用可能な言語リストを返す。
---@return table
function LanguageClass.getLanguages()
	local result = {}
	for languageName, _ in pairs(LanguageData) do
		table.insert(result, languageName)
	end
	return result
end

return LanguageClass