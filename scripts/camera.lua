---@class Camera カメラ（のオフセット移動）を制御するクラス
---@field CameraOffset number カメラのオフセット
Camera = {
	CameraOffset = 0
}

events.WORLD_RENDER:register(function ()
	local currentCameraOffset = renderer:getCameraOffsetPivot()
	if currentCameraOffset == nil then
		currentCameraOffset = 0
	else
		currentCameraOffset = currentCameraOffset.y
	end
	if currentCameraOffset > Camera.CameraOffset then
		renderer:offsetCameraPivot(0, math.max(currentCameraOffset - 3 / client:getFPS(), Camera.CameraOffset), 0)
	elseif currentCameraOffset < Camera.CameraOffset then
		renderer:offsetCameraPivot(0, math.min(currentCameraOffset + 3 / client:getFPS(), Camera.CameraOffset), 0)
	end
end)

return Camera