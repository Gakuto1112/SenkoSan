---@class LanguageClass アバターの表示言語を管理するクラス
---@field LanguageData table 言語データ
---@field ActiveLanguage string 設定言語

LanguageClass = {}

LanguageData = {
	en = {
		key_name__wag_tail = "Wag tail",
		action_wheel__main__action_1__title = "Body shake",
		action_wheel__main__action_2__unavailable = "You cannot sit down now.",
		action_wheel__main__action_2__title = "Sit down",
		action_wheel__main__action_3__title = "Earpick",
		action_wheel__main__action_3__unavailable = "Please sit down before running earpick action!",
		action_wheel__main__action_4__title = "Change display name (scroll): ",
		action_wheel__main__action_4__name_change_done_first = "Changed your name to §b",
		action_wheel__main__action_4__name_change_done_last = "§r."
	},
	jp = {
		key_name__wag_tail = "尻尾を振る",
		action_wheel__main__action_1__title = "ブルブル",
		action_wheel__main__action_2__unavailable = "今は座れないよ！",
		action_wheel__main__action_2__title = "おすわり",
		action_wheel__main__action_3__title = "耳かき",
		action_wheel__main__action_3__unavailable = "耳かきをする前に座ってね！",
		action_wheel__main__action_4__title = "表示名変更（スクロール）: ",
		action_wheel__main__action_4__name_change_done_first = "表示名を§b",
		action_wheel__main__action_4__name_change_done_last = "§rに変更しました。"
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