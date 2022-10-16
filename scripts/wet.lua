---@class WetClass 濡れ機能を制御するクラス
---@field JumpKey Keybind ジャンプボタン（ジャンプ時に鈴を鳴らす用）
---@field WalkDistance number 鈴を鳴らす用の歩いた距離
---@field VelocityYData table ジャンプしたかどうかを判定する為にy方向の速度を格納するテーブル
---@field OnGroundData table 前チックに着地していたかを判定する為に着地情報を格納するテーブル
---@field WetClass.WetCount integer 濡れの度合いを計るカウンター
---@field AutoShakeCount integer 自動ブルブルまでの時間を計るカウンター

WetClass = {}

JumpKey = keybind:create(LanguageClass.getTranslate("key_name__jump"), keybind:getVanillaKey("key.jump"))
WalkDistance = 0
VelocityYData = {}
OnGroundData = {}
WetClass.WetCount = 0
WetClass.AutoShake = ConfigClass.AutoShake
AutoShakeCount = 0

events.TICK:register(function()
	local velocity = player:getVelocity()
	local onGround = player:isOnGround()
	local paused = client:isPaused()
	local playerPos = player:getPos()
	if not paused then
		WalkDistance = WalkDistance + math.sqrt(math.abs(velocity.x ^ 2 + velocity.z ^ 2))
		if WalkDistance >= 1.8 then
			if not player:getVehicle() and onGround then
				sounds:playSound("minecraft:entity.cod.flop", playerPos, WetClass.WetCount / 1200, 1)
			end
			WalkDistance = 0
		end
	end
	table.insert(VelocityYData, velocity.y)
	table.insert(OnGroundData, onGround)
	for _, dataTable in ipairs({VelocityYData, OnGroundData}) do
		if #dataTable == 3 then
			table.remove(dataTable, 1)
		end
	end
	local tail = models.models.main.Avatar.Body.BodyBottom.Tail
	if player:isWet() then
		WetClass.WetCount = player:isInWater() and 1200 or WetClass.WetCount + 4
		EarsClass.setEarsRot("DROOPING", 1, true)
		tail:setScale(0.5, 0.5, 1)
		AutoShakeCount = 0
	elseif WetClass.WetCount > 0 then
		if WetClass.WetCount % 5 == 0 then
			for _ = 1, math.min(avatar:getMaxParticles() / 4 , 4) * math.ceil(WetClass.WetCount / 300) / 4 do
				particles:addParticle("minecraft:falling_water", playerPos.x + math.random() - 0.5, playerPos.y + math.random() + 0.5, playerPos.z + math.random() - 0.5)
			end
		end
		tail:setScale(0.5, 0.5, 1)
		EarsClass.setEarsRot("DROOPING", 1, true)
		if JumpKey:isPressed() and OnGroundData[1] and velocity.y > 0 and VelocityYData[1] <= 0 then
			sounds:playSound("minecraft:entity.cod.flop", playerPos, WetClass.WetCount / 1200, 1)
		end
		if WetClass.AutoShake and animations["models.main"]["shake"]:getPlayState() ~= "PLAYING" then
			if AutoShakeCount == 20 then
				ActionWheelClass.bodyShake(false)
				AutoShakeCount = 0
			elseif not paused then
				AutoShakeCount = AutoShakeCount + 1
			end
		end
		if not paused then
			WetClass.WetCount = WetClass.WetCount - 1
		end
	else
		tail:setScale(1, 1, 1)
	end
end)

return WetClass