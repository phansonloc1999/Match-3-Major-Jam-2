require("Src/Dependencies")

function love.load()
    board = Board()
end

function love.draw()
    board:render()
end

function love.update(dt)
    board:update(dt)
end
