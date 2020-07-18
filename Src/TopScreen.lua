---@class TopScreen
TopScreen = Class {}

function TopScreen:init()
    self.player = Player(-100, 100)
    self.enemy = Enemy(WINDOW_WIDTH, 115)
end

function TopScreen:draw()
    self.enemy:draw()
    self.player:draw()
end

function TopScreen:update(dt)
    self.player:update(dt, self)
    self.enemy:update(dt, self)
end
