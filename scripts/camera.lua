---@class CameraClass カメラ（のオフセット移動）を制御するクラス
---@field CameraClass.CameraOffset number カメラのオフセット

CameraClass = {}

CameraClass.CameraOffset = 0

events.WORLD_RENDER:register(function ()
	local currentCameraOffset = renderer:getCameraOffsetPivot()
	if currentCameraOffset == nil then
		currentCameraOffset = 0
	else
		currentCameraOffset = currentCameraOffset.y
	end
	if currentCameraOffset > CameraClass.CameraOffset then
		renderer:offsetCameraPivot(0, math.max(currentCameraOffset - 3 / client:getFPS(), CameraClass.CameraOffset), 0)
	elseif currentCameraOffset < CameraClass.CameraOffset then
		renderer:offsetCameraPivot(0, math.min(currentCameraOffset + 3 / client:getFPS(), CameraClass.CameraOffset), 0)
	end
end)

return CameraClass