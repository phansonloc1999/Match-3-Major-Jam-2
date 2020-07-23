---@class DamagePopupManager
DamagePopupManager = Class {}

local DISAPPEAR_Y_OFFSET = 50
local POPUP_SPEED = 60

function DamagePopupManager:init()
    self.damages = {}
end

function DamagePopupManager:draw()
    love.graphics.setColor(1, 0, 0)
    for i = 1, #self.damages do
        love.graphics.print(self.damages[i].ammount, self.damages[i].x, self.damages[i].y)
    end
    love.graphics.setColor(1, 1, 1)
end

function DamagePopupManager:update(dt)
    for i = 1, #self.damages do
        if (self.damages[i]) then
            self.damages[i].y = self.damages[i].y - POPUP_SPEED * dt

            if (self.damages[i].y < self.damages[i].disappearY) then
                table.remove(self.damages, i)
                i = i - 1
            end
        end
    end
end

function DamagePopupManager:add(ammount, x, y)
    table.insert(self.damages, {ammount = ammount, x = x, y = y})
    self.damages[#self.damages].disappearY = self.damages[#self.damages].y - DISAPPEAR_Y_OFFSET
end
