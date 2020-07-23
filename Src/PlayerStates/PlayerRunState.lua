---@class PlayerRunState
PlayerRunState = Class {__includes = BaseState}

---@param topScreen TopScreen
function PlayerRunState:init(player)
    self.player = player ---@type Player
    self.player.currentAnimation = self.player.animations.run
end

function PlayerRunState:draw()
end

---@param topScreen TopScreen
function PlayerRunState:update(dt, topScreen)
    self.player.x = self.player.x + 100 * dt
    if (self.player.x > WINDOW_WIDTH) then
        self.player.x = -100
    end

    self.player.collisionBox:updatePos(self.player.x + 20, self.player.y)
    self.player.currentAnimation:update(dt)

    if (self.player.collisionBox:collidesWithOther(topScreen.enemy.collisionBox)) then
        self.player.stateStack:pop()
        self.player.stateStack:push(PlayerBattleState(self.player))
    end
end
