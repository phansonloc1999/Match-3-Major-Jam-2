---@class Enemy
Enemy = Class {}

ENEMY_GRID = Anim8.newGrid(16, 16, SPRITESHEET:getWidth(), SPRITESHEET:getHeight(), 80, 82)
ENEMY_RUN_ANIMATION = Anim8.newAnimation(ENEMY_GRID("1-2", 1), 0.2)

function Enemy:init(x, y)
    self.x, self.y = x, y
    self.animations = {run = ENEMY_RUN_ANIMATION}
    self.currentAnimation = self.animations.run
    self.collisionBox = CollisionBox(x, y, 60, 60)

    self.stateStack =
        StateStack(
        {
            EnemyRunState(self)
        }
    )
end

function Enemy:draw()
    -- self.collisionBox:draw()

    self.currentAnimation:draw(SPRITESHEET, self.x, self.y, 0, 4, 4)

    self.stateStack:getActiveState():draw()
end

function Enemy:update(dt, topScreen)
    self.currentAnimation:update(dt)

    self.stateStack:getActiveState():update(dt, topScreen)
end
