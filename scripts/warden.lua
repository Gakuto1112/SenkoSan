---@class WardenClass ウォーデンに怯える機能を制御するクラス
---@field AttackKey Keybind 攻撃ボタン（怯えている時に素手の攻撃を表示させる用）
---@field WardenNearbyData table 前チックにウォーデンが近くにいたかどうかを調べる為にウォーデン情報を格納するテーブル
---@field RightHandItemTypeData table アイテムの持ち替え検出の為に右手のアイテムの情報を格納するテーブル
---@field LeftHandItemTypeData table アイテムの持ち替え検出の為に左手のアイテムの情報を格納するテーブル
---@field FirstPersonData table 視点切り替え検出の為に視点情報を格納するテーブル
---@field WardenClass.WardenNearby boolean ウォーデンが近くにいるかどうか（=暗闇デバフを受けているかどうか）

WardenClass = {}

AttackKey = keybind:create(LanguageClass.getTranslate("key_name__attack"), keybind:getVanillaKey("key.attack"))
WardenNearbyData = {}
RightHandItemTypeData = {}
LeftHandItemTypeData = {}
FirstPersonData = {}
WardenClass.WardenNearby = false


events.TICK:register(function()
	WardenClass.WardenNearby = General.getStatusEffect("darkness")
	local leftHanded = player:isLeftHanded()
	local rightHandItemType = General.hasItem(player:getHeldItem(leftHanded))
	local leftHandItemType = General.hasItem(player:getHeldItem(not leftHanded))
	local firstPerson = renderer:isFirstPerson()
	if WardenClass.WardenNearby then
		if not WardenNearbyData[1] then
			General.setAnimations("PLAY", "afraid")
		end
		FacePartsClass.setEmotion("SURPLISED", "SURPLISED", "CLOSED", 0, false)
	else
		General.setAnimations("STOP", "afraid")
		General.setAnimations("STOP", "right_hide_bell")
		General.setAnimations("STOP", "left_hide_bell")
	end
	table.insert(WardenNearbyData, WardenClass.WardenNearby)
	table.insert(RightHandItemTypeData, rightHandItemType)
	table.insert(LeftHandItemTypeData, leftHandItemType)
	table.insert(FirstPersonData, firstPerson)
	for _, dataTable in ipairs({WardenNearbyData, RightHandItemTypeData, LeftHandItemTypeData, FirstPersonData}) do
		if #dataTable == 3 then
			table.remove(dataTable, 1)
		end
	end
end)

return WardenClass