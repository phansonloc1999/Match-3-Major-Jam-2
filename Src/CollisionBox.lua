---@class CollisionBox
CollisionBox = Class {}

function CollisionBox:init(x, y, width, height)
    self.x, self.y = x, y
    self.width, self.height = width, height
end

function CollisionBox:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

function CollisionBox:collidesWithMouse()
    return CheckCollision(love.mouse.getX(), love.mouse.getY(), 1, 1, self.x, self.y, self.width, self.height)
end

function CollisionBox:updatePos(x, y)
    self.x, self.y = x, y
end

---@param other CollisionBox
function CollisionBox:collidesWithOther(other)
    return CheckCollision(self.x, self.y, self.width, self.height, other.x, other.y, other.width, other.height)
end
