setmetatable(_G, {
	__index = function(t, k)
		error(string.format("Tried to access non-existent global variable %s", k));
	end
})

local sqrt, sin, cos, pi = math.sqrt, math.sin, math.cos, math.pi

local hexagons = {}
function love.load()
	for i = 1, 60 do
		local foo = i % 6
		hexagons[i] = makeHexagon(function(n) return n ~= foo end, i * 0.5 - 0.4)
	end
end

function love.update(dt)
	for i, hex in ipairs(hexagons) do 
		hex.radius = hex.radius - dt * 0.7
	end
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

function makeHexagon(criteria, radius)
	local result = { radius = radius }
	for i=0,5 do
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
		if hexagon.radius > 0.1 then
			love.graphics.polygon('fill', getHexagonSegment(segment, hexagon.radius, 0))
		end
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

	for i, hex in ipairs(hexagons) do
		drawHexagon(hex)
	end

	love.graphics.pop()
end