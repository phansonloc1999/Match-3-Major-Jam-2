---@class EnemyBattleState
EnemyBattleState = Class {__includes = BaseState}

function EnemyBattleState:init(enemy)
    self.enemy = enemy ---@type Enemy
    self.attackTimer = Timer.new()
    self.attackTimer:every(
        1,
        function()
            dmgPopupMan:add(50, self.enemy.x, self.enemy.y)
        end
    )
end

function EnemyBattleState:draw()
end

function EnemyBattleState:update(dt)
    self.attackTimer:update(dt)
end

function EnemyBattleState:enter(params)
end
