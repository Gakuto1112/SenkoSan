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
		action_wheel__main__action_1__title = "Broom cleaning",
		action_wheel__main__action_1__unavailable = "You cannot clean now.",
		action_wheel__main__action_2__title = "Body shake",
		action_wheel__main__action_3__unavailable = "You cannot sit down now.",
		action_wheel__main__action_3__title = "Sit down",
		action_wheel__main__action_4__title = "Earpick",
		action_wheel__main__action_4__unavailable = "Please sit down before running earpick action!",
		action_wheel__main__action_5__title = "Change costume (scroll): ",
		action_wheel__main__action_5__name_change_done_first = "Changed your costume to §b",
		action_wheel__main__action_5__name_change_done_last = "§r.",
		action_wheel__main__action_6__title = "Change display name (scroll): ",
		action_wheel__main__action_6__name_change_done_first = "Changed your name to §b",
		action_wheel__main__action_6__name_change_done_last = "§r."
	},
	jp = {
		key_name__wag_tail = "尻尾フリフリ",
		key_name__jerk_ears = "お耳ピクピク",
		key_name__jump = "ジャンプ",
		key_name__attack = "攻撃",
		costume__default = "いつもの服",
		costume__disguise = "変装服",
		action_wheel__main__action_1__title = "お掃除",
		action_wheel__main__action_1__unavailable = "今はきれいにできないのじゃ。",
		action_wheel__main__action_2__title = "ブルブル",
		action_wheel__main__action_3__unavailable = "今は座れないのじゃ。",
		action_wheel__main__action_3__title = "おすわり",
		action_wheel__main__action_4__title = "耳かき",
		action_wheel__main__action_4__unavailable = "座ってから耳かきをするかのう。",
		action_wheel__main__action_5__title = "わらわは何を着ればよいのじゃ？ (スクロール): ",
		action_wheel__main__action_5__name_change_done_first = "§b",
		action_wheel__main__action_5__name_change_done_last = "§rに着替えたのじゃ。",
		action_wheel__main__action_6__title = "われらは何と呼ばれればよいのじゃ？（スクロール）: ",
		action_wheel__main__action_6__name_change_done_first = "われらの呼び名を§b",
		action_wheel__main__action_6__name_change_done_last = "§rに変更したのじゃ。"
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