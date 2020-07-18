---@class EnemyRunState
EnemyRunState = Class {__includes = BaseState}

function EnemyRunState:init(enemy)
    self.enemy = enemy ---@type Enemy
end

function EnemyRunState:draw()
end

---@param topScreen TopScreen
function EnemyRunState:update(dt, topScreen)
    self.enemy.x = self.enemy.x - 100 * dt
    if (self.enemy.x < -32) then
        self.enemy.x = WINDOW_WIDTH
    end

    self.enemy.collisionBox:updatePos(self.enemy.x, self.enemy.y)

    if (self.enemy.collisionBox:collidesWithOther(topScreen.player.collisionBox)) then
        self.enemy.stateStack:pop()
        self.enemy.stateStack:push(EnemyBattleState(self.enemy))
    end
end
