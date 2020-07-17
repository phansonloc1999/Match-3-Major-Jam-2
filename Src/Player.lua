---@class Player
Player = Class {}

local PLAYER_GRID = Anim8.newGrid(16, 16, SPRITESHEET:getWidth(), SPRITESHEET:getHeight(), 0, 81)
local PLAYER_RUN_ANIMATION = Anim8.newAnimation(PLAYER_GRID("4-5", 1), 0.2)

function Player:init(x, y)
    self.x, self.y = x, y
    self.animations = {run = PLAYER_RUN_ANIMATION}
    self.currentAnimation = self.animations.run
end

function Player:draw()
    self.currentAnimation:draw(SPRITESHEET, self.x, self.y, 0, 6, 6)
end

function Player:update(dt)
    self.x = self.x + 100 * dt
    if (self.x > WINDOW_WIDTH) then
        self.x = -100
    end

    self.currentAnimation:update(dt)
end
