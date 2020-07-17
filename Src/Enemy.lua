---@class Enemy
Enemy = Class {}

local ENEMY_GRID = Anim8.newGrid(16, 16, SPRITESHEET:getWidth(), SPRITESHEET:getHeight(), 80, 82)
local ENEMY_RUN_ANIMATION = Anim8.newAnimation(ENEMY_GRID("1-2", 1), 0.2)

function Enemy:init(x, y)
    self.x, self.y = x, y
    self.animations = {run = ENEMY_RUN_ANIMATION}
    self.currentAnimation = self.animations.run
end

function Enemy:draw()
    self.currentAnimation:draw(SPRITESHEET, self.x, self.y, 0, 4, 4)
end

function Enemy:update(dt)
    self.x = self.x - 100 * dt
    if (self.x < -32) then
        self.x = WINDOW_WIDTH
    end

    self.currentAnimation:update(dt)
end
