---@class FoxFire 狐火を制御するクラス
---@field NightVision boolean 暗視を受けていたかどうか
FoxFire = {
	NightVision = false
}

---前チックに暗視を受けていたかどうか
---@type boolean
local nightVisionPrev = false

---狐火が有効かどうか
---@type boolean
local visible = true

---前チックに狐火が有効かどうか
---@type boolean
local visiblePrev = true

---狐火のアニメーションを制御する各種カウンター
--[[
	flicker: ちらつきアニメーションのカウンター
	nextFlicker: 次のちらつきアニメーションまでのカウンター
	float: 浮遊アニメーションのカウンター
]]
---@type table<string, integer>
local animationCounters = {}

---一人称視点で狐火を表示するかどうか
---@type boolean
local foxFireInFirstPerson = Config.loadConfig("foxFireInFirstPerson", true)

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
	if visible then
		for _, counters in ipairs(animationCounters) do
			if counters.nextFlicker == 0 then
				counters.flicker = 0
			end
			counters.nextFlicker = counters.nextFlicker - 1
		end
	end
end)

events.RENDER:register(function (delta)
	if not renderProcessed then
		if visible then
			for index, foxFireAnchor in ipairs(models.models.main.FoxFireAnchors:getChildren()) do
				local fps = client:getFPS()
				local foxFireScale = math.min(foxFireAnchor["FoxFire"..index]:getScale().x + 8 / fps, 1)
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
		else

		end
		renderProcessed = true
	end
	if models.models.main.FoxFireAnchors.FoxFireAnchor1.FoxFire1:getScale().x > 0 then
		models.models.main.FoxFireAnchors:setPos(player:getPos(delta) * 16)
		models.models.main.FoxFireAnchors:setRot(0, -player:getBodyYaw(delta))
		for index, foxFireAnchor in ipairs(models.models.main.FoxFireAnchors:getChildren()) do
			foxFireAnchor["FoxFire"..index]:setColor(fillVec3(models.models.main.FoxFireAnchors.FoxFireAnchor1.FoxFire1:getScale().x))
		end
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