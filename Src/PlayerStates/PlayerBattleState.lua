---@class PlayerBattleState
PlayerBattleState = Class {__includes = BaseState}

function PlayerBattleState:init(player)
    self.player = player ---@type Player
end

function PlayerBattleState:draw()
end

function PlayerBattleState:update(dt)
    self.player.currentAnimation:update(dt)
end

function PlayerBattleState:enter(params)
    self.player.currentAnimation = self.player.animations.battle
end
