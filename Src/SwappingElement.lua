---@class SwappingElement
SwappingElement = Class {}

function SwappingElement:init(x, y, type)
    self.x, self.y = x, y
    self.type = type
end

function SwappingElement:draw()
	--[[
    -- Set different colors for elements
    if (self.type == 1) then
        love.graphics.setColor(0, 1, 0)
    end
    if (self.type == 2) then
        love.graphics.setColor(1, 0, 0)
    end
    if (self.type == 3) then
        love.graphics.setColor(0, 0, 1)
    end
    if (self.type == 4) then
        love.graphics.setColor(1, 1, 0)
    end
    if (self.type == 5) then
        love.graphics.setColor(0, 1, 1)
    end

    love.graphics.circle("fill", self.x, self.y, ELEMENT_RADIUS)

    love.graphics.setColor(1, 1, 1)
	]]--

	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(
		Sprites.elements[self.type],
		self.x, self.y,
		0, 1, 1,
		Sprites.elements[self.type]:getWidth()/2,
		Sprites.elements[self.type]:getHeight()/2
	)
end
