---@class Player
Player = Class {}

PLAYER_GRID = Anim8.newGrid(16, 16, SPRITESHEET:getWidth(), SPRITESHEET:getHeight(), 0, 81)
PLAYER_RUN_ANIMATION = Anim8.newAnimation(PLAYER_GRID("4-5", 1), 0.2)
PLAYER_ATTACK_ANIMATION = Anim8.newAnimation(PLAYER_GRID("1-2", 1), 0.2)

function Player:init(x, y)
    self.x, self.y = x, y
    self.animations = {run = PLAYER_RUN_ANIMATION, attack = PLAYER_ATTACK_ANIMATION}
    self.collisionBox = CollisionBox(x, y, 60, 80)

    self.stateStack =
        StateStack(
        {
            PlayerRunState(self)
        }
    )
end

function Player:draw()
    -- self.collisionBox:draw()

    self.currentAnimation:draw(SPRITESHEET, self.x, self.y, 0, 6, 6)

    self.stateStack:getActiveState():draw()
end

function Player:update(dt, params)
    self.stateStack:getActiveState():update(dt, params)
end
