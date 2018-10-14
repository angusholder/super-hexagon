setmetatable(_G, {
	__index = function(t, k)
		error(string.format("Tried to access non-existent global variable %s", k));
	end
})

function love.load()
end

function love.update(dt)

end

local R32 = math.sqrt(3) / 2
local HEXAGON_EDGES = {
	-1, 0,
	-0.5, R32,
	0.5, R32,
	1, 0,
	0.5, -R32,
	-0.5, -R32
}

function getHexagonEdge(i)
	local x0, y0 = HEXAGON_EDGES[2*i-1], HEXAGON_EDGES[2*i]
	local x1, y1
	if i == 6 then
		x1, y1 = HEXAGON_EDGES[1], HEXAGON_EDGES[2]
	else
		x1, y1 = HEXAGON_EDGES[2*i+1], HEXAGON_EDGES[2*i+2]
	end
	return x0, y0, x1, y1
end

function getHexagonSegment(i, scale)
	local x0, y0, x1, y1 = getHexagonEdge(i)
	local a = 1.0 * scale
	local b = 0.8 * scale
	return a*x0, a*y0, a*x1, a*y1, b*x1, b*y1, b*x0, b*y0
end

function makeHexagon(criteria)
	local result = {}
	for i=1,6 do
		if criteria(i) then
			table.insert(result, i)
		end
	end
	return result
end

function drawHexagon(hexagon)
	love.graphics.push()
	
	love.graphics.setColor(0.3, 0.2, 0.8, 1.0)
	for _, segment in ipairs(hexagon) do
		love.graphics.polygon('fill', getHexagonSegment(segment, hexagon.scale))
	end

	love.graphics.pop()
end

function love.draw()
	local windowWidth, windowHeight = love.graphics.getDimensions()
	love.graphics.push()

	local scale = math.min(windowWidth / 2, windowHeight / 2)
	love.graphics.scale(scale, scale)
	if windowWidth > windowHeight then
		love.graphics.translate(windowWidth / windowHeight, 1)
	elseif windowHeight > windowWidth then
		love.graphics.translate(1, windowHeight / windowWidth)
	end
	love.graphics.scale(1, -1)
	
	love.graphics.setColor(0.2, 0.8, 0.0, 1.0)
	love.graphics.rectangle('fill', -1, -1, 0.25, 0.25)

	drawHexagon {    2, 3, 4, 5, 6, scale = 0.1 }
	drawHexagon { 1,    3, 4, 5, 6, scale = 0.4 }
	drawHexagon { 1, 2,    4, 5, 6, scale = 0.7 }
	drawHexagon { 1, 2, 3,    5, 6, scale = 1.0 }
	drawHexagon { 1, 2, 3, 4,    6, scale = 1.3 }
	drawHexagon { 1, 2, 3, 4, 5   , scale = 1.6 }

	love.graphics.pop()
end