---@class EarsClass けも耳を制御するクラス
---@field JerkEarsKey Keybind 耳を動かすキー
---@field JerkEarsCount integer 耳を動かす時間を計るカウンター

EarsClass = {}

JerkEarsKey = keybind:create(LanguageClass.getTranslate("key_name__jerk_ears"), "key.keyboard.x")
JerkEarsCount = -1

--ping関数
function pings.jerk_ears()
	General.setAnimations("PLAY", "jerk_ears")
	WagTailCount = 5
end

events.TICK:register(function ()
	models.models.main.Avatar.Head.Ears:setRot((General.PlayerCondition == "LOW" or WetClass.WetCount > 0 or WardenClass.WardenNearby or player:getPose() == "SLEEPING") and -40 or (General.PlayerCondition == "MEDIUM" and -20 or 0), 0, 0)
	JerkEarsCount = JerkEarsCount > 0 and JerkEarsCount - 1 or 0
end)

JerkEarsKey.onPress = function ()
	if JerkEarsCount == 0 then
		pings.jerk_ears()
	end
end

return EarsClass