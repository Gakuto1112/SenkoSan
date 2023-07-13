---@class Camera カメラ（のオフセット移動）を制御するクラス
---@field CameraOffset number カメラのオフセット
Camera = {
	CameraOffset = 0
}

---このレンダーで処理を行ったかどうか
---@type boolean
local renderProcessed = false

events.RENDER:register(function ()
	if not renderProcessed then
		local currentCameraOffset = renderer:getCameraOffsetPivot()
		if currentCameraOffset == nil then
			currentCameraOffset = 0
		else
			currentCameraOffset = currentCameraOffset.y
		end
		if currentCameraOffset ~= Camera.CameraOffset then
			local cameraHeight = vectors.vec3(0, currentCameraOffset > Camera.CameraOffset and math.max(currentCameraOffset - 3 / client:getFPS(), Camera.CameraOffset) or math.min(currentCameraOffset + 3 / client:getFPS(), Camera.CameraOffset))
			renderer:offsetCameraPivot(cameraHeight)
			renderer:eyeOffset(cameraHeight)
		end
		renderProcessed = true
	end
end)

events.WORLD_RENDER:register(function ()
	if not client:isPaused() then
        renderProcessed = false
    end
end)

return Camera