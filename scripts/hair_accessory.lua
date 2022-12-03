---@class HairAccessory 髪飾りを制御するクラス

HairAccessory = {}

---髪飾りを表示するかどうか
---@param visible boolean 髪飾りを表示するかどうか
function HairAccessory.visible(visible)
	local hairAccessory = models.models.main.Avatar.Head.HairAccessory
	hairAccessory:setVisible(visible)
	Physics.EnablePyhsics[2] = visible and not General.isAnimationPlaying("models.main", "kotatsu")
end

return HairAccessory