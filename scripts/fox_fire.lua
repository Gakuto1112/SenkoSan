---@class FoxFire 狐火を制御するクラス
---@field NightVision boolean 暗視を受けていたかどうか
---@field FoxFireInFirstPerson boolean 一人称視点で狐火を表示するかどうか
FoxFire = {
	NightVision = false,
	FoxFireInFirstPerson = Config.loadConfig("foxFireInFirstPerson", true)
}

---前チックに暗視を受けていたかどうか
---@type boolean
local nightVisionPrev = false

---狐火が有効かどうか
---@type boolean
local enabled = false

---前チックに狐火が有効かどうか
---@type boolean
local enabledPrev = false

---狐火が見える状態かどうか
---@type boolean
local visible = false

---前チックに狐火が見えた状態かどうか
---@type boolean
local visiblePrev = false


---狐火のアニメーションを制御する各種カウンター
--[[
	flicker: ちらつきアニメーションのカウンター
	nextFlicker: 次のちらつきアニメーションまでのカウンター
	float: 浮遊アニメーションのカウンター
]]
---@type table<string, integer>
local animationCounters = {}

---このレンダーで処理を行ったかどうか
---@type boolean
local renderProcessed = false

---入力された1つのnumberをvec3のx, y, zそれぞれに入れて、それを返す。
---@param numberToFill number 入力する数字
---@return Vector3 filledVector 入力された数字で埋められた3次元ベクトル
local function fillVec3(numberToFill)
	return vectors.vec3(numberToFill, numberToFill, numberToFill)
end

--ping関数
function pings.setNightVision(newValue)
	FoxFire.NightVision = newValue
end

events.TICK:register(function ()
	if host:isHost() then
		FoxFire.NightVision = General.getTargetEffect("minecraft.night_vision") and true or false
		if FoxFire.NightVision and not nightVisionPrev then
			pings.setNightVision(true)
		elseif not FoxFire.NightVision and nightVisionPrev then
			pings.setNightVision(false)
		end
	end
	enabled = FoxFire.NightVision and player:isAlive()
	visible = models.models.main.FoxFireAnchors.FoxFireAnchor1.FoxFire1:getScale().x > 0 and (FoxFire.FoxFireInFirstPerson or not renderer:isFirstPerson())
	models.models.main.FoxFireAnchors:setVisible(visible)
	if enabled and not enabledPrev then
		sounds:playSound("minecraft:item.firecharge.use", player:getPos(), 1, 2)
	elseif not enabled and enabledPrev then
		sounds:playSound("minecraft:block.fire.extinguish", player:getPos(), 1, 2)
		if FoxFire.FoxFireInFirstPerson or not renderer:isFirstPerson() then
			for index, foxFireAnchor in ipairs(models.models.main.FoxFireAnchors:getChildren()) do
				local foxFireMatrix = foxFireAnchor["FoxFire"..index]:partToWorldMatrix()
				for _ = 1, 5 do
					particles:newParticle("smoke", foxFireMatrix[4][1] + math.random() * 0.25 - 0.125, foxFireMatrix[4][2] + math.random() * 0.25 - 0.125, foxFireMatrix[4][3] + math.random() * 0.25 - 0.125)
				end
			end
		end
	end
	if visible then
		for _, counters in ipairs(animationCounters) do
			if counters.nextFlicker == 0 then
				counters.flicker = 0
			end
			counters.nextFlicker = counters.nextFlicker - 1
		end
	elseif visiblePrev then
		for _, counters in ipairs(animationCounters) do
			counters.flicker = -1
			counters.nextFlicker = math.random(0, 4)
			if counters.nextFlicker == 0 then
				counters.flicker = 0
			end
			counters.nextFlicker = counters.nextFlicker - 1
		end
	end
	nightVisionPrev = FoxFire.NightVision
	enabledPrev = enabled
	visiblePrev = visible
end)

events.RENDER:register(function (delta)
	if not renderProcessed then
		local currentFoxFireScale = models.models.main.FoxFireAnchors.FoxFireAnchor1["FoxFire1"]:getScale().x
		if visible then
			models.models.main.FoxFireAnchors:setPos(player:getPos(delta) * 16)
			models.models.main.FoxFireAnchors:setRot(0, -player:getBodyYaw(delta) + 180)
			for index, foxFireAnchor in ipairs(models.models.main.FoxFireAnchors:getChildren()) do
				foxFireAnchor["FoxFire"..index]:setColor(fillVec3(models.models.main.FoxFireAnchors.FoxFireAnchor1.FoxFire1:getScale().x))
				local fps = client:getFPS()
				local foxFireScale = enabled and math.min(foxFireAnchor["FoxFire"..index]:getScale().x + 8 / fps, 1) or math.max(foxFireAnchor["FoxFire"..index]:getScale().x - 8 / fps, 0)
				local newFloatCount = animationCounters[index].float + 0.25 / fps
				animationCounters[index].float = newFloatCount > 1 and newFloatCount - 1 or newFloatCount;
				foxFireAnchor["FoxFire"..index]:setPos(foxFireAnchor:getPivot() + vectors.vec3(0, math.sin(animationCounters[index].float * 2 * math.pi)) * 2)
				if animationCounters[index].flicker >= 0 then
					local newFlickerCount = math.min(animationCounters[index].flicker + 5 / fps, 1)
					if newFlickerCount < 1 then
						animationCounters[index].flicker = newFlickerCount
					else
						animationCounters[index].flicker = -1
						animationCounters[index].nextFlicker = math.random(0, 4)
					end
				end
				foxFireAnchor["FoxFire"..index]:setScale(fillVec3(foxFireScale + (animationCounters[index].flicker > 0 and math.abs(animationCounters[index].flicker * 0.2 - 0.1) * -1 or 0)));
			end
		elseif enabled then
			local foxFireScale = math.min(currentFoxFireScale + 8 / client:getFPS(), 1)
			for index, foxFireAnchor in ipairs(models.models.main.FoxFireAnchors:getChildren()) do
				foxFireAnchor["FoxFire"..index]:setScale(fillVec3(foxFireScale));
			end
		end
		renderProcessed = true
	end
end)

events.WORLD_RENDER:register(function ()
    if not client:isPaused() then
        renderProcessed = false
    end
end)

models.models.fox_fire:setSecondaryTexture("CUSTOM", textures["textures.fox_fire"])
models.models.fox_fire:setScale(0, 0, 0)
models.models.fox_fire:setColor(0.5, 0.5, 0.5)
for index, foxFireAnchor in ipairs(models.models.main.FoxFireAnchors:getChildren()) do
	local floatCount = math.random()
	table.insert(animationCounters, {
		flicker = -1,
		nextFlicker = math.random(0, 4),
		float = floatCount
	})
	foxFireAnchor:addChild(models.models.fox_fire:copy("FoxFire"..index))
	foxFireAnchor["FoxFire"..index]:setPos(foxFireAnchor:getPivot() + vectors.vec3(0, math.sin(floatCount * 2 * math.pi)))
	foxFireAnchor["FoxFire"..index]:setRot(0, math.random(0, 3) * 90)
end
models.models.fox_fire:setVisible(false)

return FoxFire