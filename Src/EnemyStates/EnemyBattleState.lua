---@class EnemyBattleState
EnemyBattleState = Class {__includes = BaseState}

function EnemyBattleState:init(enemy)
    self.enemy = enemy ---@type Enemy
end

function EnemyBattleState:draw()
end

function EnemyBattleState:update(dt)
end

function EnemyBattleState:enter(params)
end
