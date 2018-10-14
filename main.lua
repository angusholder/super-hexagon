setmetatable(_G, {
	__index = function(t, k)
		error(string.format("Tried to access non-existent global variable %s", k));
	end
})

local sqrt, sin, cos, pi = math.sqrt, math.sin, math.cos, math.pi

function love.load()
end

function love.update(dt)

end

function getHexagonEdge(i, radius, angularOffset)
	local p0Angle = i * pi/3 + angularOffset
	local p1Angle = (i + 1) * pi/3 + angularOffset
	return radius * cos(p0Angle), radius * sin(p0Angle), 
		radius * cos(p1Angle), radius * sin(p1Angle)
end

function getHexagonSegment(i, radius, angularOffset)
	local x0, y0, x1, y1 = getHexagonEdge(i, radius, angularOffset)
	local x3, y3, x2, y2 = getHexagonEdge(i, radius + 0.1, angularOffset)
	return x0, y0, x1, y1, x2, y2, x3, y3
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
		love.graphics.polygon('fill', getHexagonSegment(segment, hexagon.scale, 0))
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