---@class LanguageClass アバターの表示言語を管理するクラス
---@field LanguageData table 言語データ
---@field ActiveLanguage string 設定言語

LanguageClass = {}

LanguageData = {
	en = {
		key_name__wag_tail = "Wag tail",
		key_name__jerk_ears = "Jerk ears",
		key_name__jump = "Jump",
		key_name__attack = "Attack",
		costume__default = "Default costume",
		costume__disguise = "Disguise costume",
		costume__maid_a = "Maid costume A",
		costume__maid_b = "Maid costume B",
		costume__swimsuit = "Swimsuit and Straw hat",
		costume__purification = "Purification clothes",
		action_wheel__toggle_off = "off",
		action_wheel__toggle_on = "on",
		action_wheel__refuse_action = "(It is not the time... I have a strong feeling bad sign...)",
		action_wheel__main__action_8__title = "Change pages (scroll): §b",
		action_wheel__main_1__action_1__title = "Broom cleaning",
		action_wheel__main_1__action_1__unavailable = "I cannot clean now.",
		action_wheel__main_1__action_2__title = "Hair cut",
		action_wheel__main_1__action_2__unavailable = "I cannot give you a haircut now.",
		action_wheel__main_1__action_3__title = "Body shake",
		action_wheel__main_1__action_4__unavailable = "I cannot sit down now.",
		action_wheel__main_1__action_4__title = "Sit down",
		action_wheel__main_1__action_5__title = "Earpick",
		action_wheel__main_1__action_5__unavailable = "I will clean your ears after I sit down!",
		action_wheel__main_1__action_6__title = "Tea time",
		action_wheel__main_1__action_6__unavailable = "I will sip tea after I sit down!",
		action_wheel__main_1__action_7__title = "Massage",
		action_wheel__main_1__action_7__unavailable = "I will massage you after I sit down!",
		action_wheel__main_2__action_1__title = "What costume should I wear? (scroll): ",
		action_wheel__main_2__action_1__done_first = "I changed my clothers to §b",
		action_wheel__main_2__action_1__done_last = "§r!",
		action_wheel__main_2__action_2__title = "What should I be called? (scroll): ",
		action_wheel__main_2__action_2__done_first = "I changed my name to §b",
		action_wheel__main_2__action_2__done_last = "§r!",
		action_wheel__main_2__action_3__title = "Auto shake：§b",
		action_wheel__main_2__action_4__title = "Hide armor：§b"
	},
	jp = {
		key_name__wag_tail = "尻尾フリフリ",
		key_name__jerk_ears = "お耳ピクピク",
		key_name__jump = "ジャンプ",
		key_name__attack = "攻撃",
		costume__default = "いつもの服",
		costume__disguise = "変装服",
		costume__maid_a = "メイド服A",
		costume__maid_b = "メイド服B",
		costume__swimsuit = "水着と麦わら帽子",
		costume__purification = "清めの服",
		action_wheel__toggle_off = "オフ",
		action_wheel__toggle_on = "オン",
		action_wheel__refuse_action = "（今はそれどころじゃないのじゃ...何かよからぬ気配を強く感じるのじゃ...）",
		action_wheel__main__action_8__title = "ページ切り替え（スクロール）：§b",
		action_wheel__main_1__action_1__title = "お掃除",
		action_wheel__main_1__action_1__unavailable = "今は掃除できないのじゃ。",
		action_wheel__main_1__action_2__title = "散髪",
		action_wheel__main_1__action_2__unavailable = "今は髪を切ってあげられないのじゃ。",
		action_wheel__main_1__action_3__title = "ブルブル",
		action_wheel__main_1__action_4__unavailable = "今は座れないのじゃ。",
		action_wheel__main_1__action_4__title = "おすわり",
		action_wheel__main_1__action_5__title = "耳かき",
		action_wheel__main_1__action_5__unavailable = "座ってから耳かきをするかのう。",
		action_wheel__main_1__action_6__title = "お茶",
		action_wheel__main_1__action_6__unavailable = "座ってからお茶をすすろうかのう。",
		action_wheel__main_1__action_7__title = "マッサージ",
		action_wheel__main_1__action_7__unavailable = "座ってからお主をほぐそうかのう。",
		action_wheel__main_2__action_1__title = "わらわは何を着ればよいのじゃ？（スクロール）：",
		action_wheel__main_2__action_1__done_first = "§b",
		action_wheel__main_2__action_1__done_last = "§rに着替えたのじゃ。",
		action_wheel__main_2__action_2__title = "わらわは何と呼ばれればよいのじゃ？（スクロール）: ",
		action_wheel__main_2__action_2__done_first = "わらわの呼び名を§b",
		action_wheel__main_2__action_2__done_last = "§rに変更したのじゃ。",
		action_wheel__main_2__action_3__title = "自動ブルブル：§b",
		action_wheel__main_2__action_4__title = "防具を隠す：§b"
	}
}
ActiveLanguage = client:getActiveLang() == "ja_jp" and "jp" or "en"

---翻訳キーに対する訳文を返す。設定言語が存在しない場合は英語の文が返される。また、指定したキーの訳が無い場合は英語->キーそのままが返される。
---@param keyName string 翻訳キー
---@return string
function LanguageClass.getTranslate(keyName)
	return LanguageData[ActiveLanguage][keyName] and LanguageData[ActiveLanguage][keyName] or (LanguageData["en"][keyName] and LanguageData["en"][keyName] or keyName)
end

events.WORLD_TICK:register(function ()
	ActiveLanguage = client:getActiveLang() == "ja_jp" and "jp" or "en"
end)

return LanguageClass