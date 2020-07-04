-- package.cpath =
--     package.cpath .. ";c:/Users/COMPUTER/.vscode/extensions/tangzx.emmylua-0.3.49/debugger/emmy/windows/x64/?.dll"
-- local dbg = require("emmy_core")
-- dbg.tcpListen("localhost", 9966)

require("Src/Dependencies")
require("Src/Assets")

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")

    board = Board()

    -- love.system.openURL("http://localhost:8080")
end

function love.draw()
    board:draw()

    -- love.graphics.clear(1, 1, 1)

    love.graphics.setColor(0, 1, 0)
    love.graphics.print("FPS: " .. love.timer.getFPS())
    love.graphics.setColor(1, 1, 1)

    -- scanLineEffect:draw()
end

function love.update(dt)
    require("Libs.lovebird").update()

    Timer.update(dt)

    board:update(dt)
    -- scanLineEffect:update(dt)

    love.mouse.buttonsPressed = {}
end
