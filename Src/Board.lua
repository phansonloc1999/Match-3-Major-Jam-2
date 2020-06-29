---@class Board
Board = Class {}

BOARD_WIDTH, BOARD_HEIGHT = 5, 5
CELL_WIDTH, CELL_HEIGHT = 100, 100
ELEMENT_RADIUS = 30

function Board:init()
    self.elements = {}
    for i = 1, BOARD_HEIGHT do
        self.elements[i] = {}
        for j = 1, BOARD_WIDTH do
            if (i == 1 and j == 1) then
                self.elements[i][j] = 2
            else
                table.insert(self.elements[i], 1)
            end
        end
    end

    self.cellCollisionBoxes = {} ---@type CollisionBox[][]
    for i = 1, BOARD_HEIGHT do
        self.cellCollisionBoxes[i] = {}
        for j = 1, BOARD_WIDTH do
            table.insert(
                self.cellCollisionBoxes[i],
                CollisionBox((j - 1) * CELL_WIDTH, (i - 1) * CELL_HEIGHT, CELL_WIDTH, CELL_HEIGHT)
            )
        end
    end

    self.prevSelectedElementPos = nil
end

function Board:draw()
    -- Render cells
    for i = 1, BOARD_HEIGHT do
        for j = 1, BOARD_WIDTH do
            love.graphics.rectangle("line", (j - 1) * CELL_WIDTH, (i - 1) * CELL_HEIGHT, CELL_WIDTH, CELL_HEIGHT)
        end
    end

    -- Render elements
    for i = 1, BOARD_HEIGHT do
        for j = 1, BOARD_WIDTH do
            -- Set different colors for elements
            if (self.elements[i][j] == 1) then
                love.graphics.setColor(0, 1, 0)
            elseif (self.elements[i][j] == 2) then
                love.graphics.setColor(1, 0, 0)
            end

            love.graphics.circle(
                "fill",
                (j - 1) * CELL_WIDTH + CELL_WIDTH / 2,
                (i - 1) * CELL_HEIGHT + CELL_HEIGHT / 2,
                ELEMENT_RADIUS
            )
        end
    end
    love.graphics.setColor(1, 1, 1)
end

function Board:update(dt)
    for i = 1, BOARD_HEIGHT do
        for j = 1, BOARD_WIDTH do
            if (self.cellCollisionBoxes[i][j]:collidesWithMouse() and love.mouse.wasPressed(1)) then
                if (self.prevSelectedElementPos == nil) then
                    self.prevSelectedElementPos = {row = i, column = j}
                else
                    if
                        (self:isNeighborElements(
                            self.prevSelectedElementPos.row,
                            self.prevSelectedElementPos.column,
                            i,
                            j
                        ))
                     then
                        self:swapElements(self.prevSelectedElementPos.row, self.prevSelectedElementPos.column, i, j)
                    end
                    self.prevSelectedElementPos = nil
                end
            end
        end
    end
end

function Board:swapElements(row1, column1, row2, column2)
    assert(self.elements[row1][column1], "Board doesn't contain element at row" .. row1 .. " column" .. column1)
    assert(self.elements[row2][column2], "Board doesn't contain element at row" .. row2 .. " column" .. column2)
    local temp = self.elements[row1][column1]
    self.elements[row1][column1] = self.elements[row2][column2]
    self.elements[row2][column2] = temp
end

function Board:isNeighborElements(row1, column1, row2, column2)
    return (math.abs(row1 - row2) == 1 and column1 == column2) or (row1 == row2 and math.abs(column1 - column2) == 1)
end
