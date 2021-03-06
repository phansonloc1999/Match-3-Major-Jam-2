love.mouse.buttonsPressed = {}

function love.mousepressed(x, y, button, istouch, presses)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function table.deepcopy(source)
    local result = {}
    for i = 1, #source do
        result[i] = {}
        for j = 1, #source[i] do
            result[i][j] = source[i][j]
        end
    end
    return result
end
