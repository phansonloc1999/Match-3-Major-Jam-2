---@class Element
Element = Class {}

function Element:init(x, y, type, genRow)
    self.x, self.y = x, y
    self.type = type
    self.genRow = genRow
end

function Element:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        Sprites.elements[self.type],
        self.x,
        self.y,
        0,
        1,
        1,
        Sprites.elements[self.type]:getWidth() / 2,
        Sprites.elements[self.type]:getHeight() / 2
    )
end
