---@class HairAccessory 髪飾りを制御するクラス

HairAccessory = {
	---髪飾りを表示するかどうか
	---@param visible boolean 髪飾りを表示するかどうか
	visible = function(visible)
		models.models.main.Avatar.Head.HairAccessory:setVisible(visible)
		Physics.EnablePyhsics[2] = visible
	end
}

return HairAccessory