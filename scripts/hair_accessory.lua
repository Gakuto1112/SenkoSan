---@class HairAccessoryClass 髪飾りを制御するクラス

HairAccessoryClass = {}

---髪飾りを表示するかどうか
---@param visible boolean 髪飾りを表示するかどうか
function HairAccessoryClass.visible(visible)
	local hairAccessory = models.models.main.Avatar.Head.HairAccessory
	hairAccessory:setVisible(visible)
	PhysicsClass.EnablePyhsics[2] = visible
end

return HairAccessoryClass