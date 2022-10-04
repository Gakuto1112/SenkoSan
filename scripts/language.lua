---@class LanguageClass アバターの表示言語を管理するクラス
---@field LanguageData table 言語データ
---@field ActiveLanguage string 設定言語

LanguageClass = {}

LanguageData = {
	en = {
		action_wheel__main__action_1__title = "Sit down",
		action_wheel__main__action_2__title = "Earpick"
	},
	jp = {
		action_wheel__main__action_1__title = "おすわり",
		action_wheel__main__action_2__title = "耳かき"
	}
}
ActiveLanguage = "en"

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