---@class ConfigClass アバター設定を管理するクラス A class for managing avatar config.
---@field ConfigClass.HideArmor boolean 防具を隠すかどうか Whether or not hide armors.

ConfigClass = {}

--[[
	*** NOTE ***
	2022/7/16現在、Rewrite版には、データを保存して後で読み出せるようにする機能が搭載されていません。
	つまり、Prewrite版のような設定ページが現在は作成できません！
	代わりに、下の設定値を直接変更して下さい。
	何が何を表しているのか、有効か値は何かは、上の"@field"を参照して下さい。

	As of 7/16/2022, Figura does not have a function to save data to be able to load later.
	It means that it is impossible to create config system like when pre-write.
	Insted of that, please change configs by editing config file (/sripts/config.lua) directly.
]]

ConfigClass.HideArmor = true

--- *** 設定フィールド終了 Config field end ***

return ConfigClass