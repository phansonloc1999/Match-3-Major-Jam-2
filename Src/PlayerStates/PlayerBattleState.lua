---@class PlayerBattleState
PlayerBattleState = Class {__includes = BaseState}

local PLAYER_ATTACK_INTERVAL = 1
local DAMAGE_DEAL = 50

function PlayerBattleState:init(player)
    self.player = player ---@type Player
end

function PlayerBattleState:draw()
end

function PlayerBattleState:update(dt)
    self.player.currentAnimation:update(dt)
end

function PlayerBattleState:enter(params)
    self.player.currentAnimation = self.player.animations.attack
    self.player.currentAnimation.onLoop = function()
        dmgPopupMan:add(DAMAGE_DEAL, self.player.x + 50, self.player.y)

        self.player.currentAnimation:pauseAtStart()
        Timer.after(
            PLAYER_ATTACK_INTERVAL,
            function()
                self.player.currentAnimation:resume()
            end
        )
    end
end
