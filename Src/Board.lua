---@class Board
Board = Class {}

BOARD_ROW_NUMBER, BOARD_COLUMN_NUMBER = 5, 5
CELL_WIDTH, CELL_HEIGHT = 100, 100
ELEMENT_RADIUS = 30

function Board:init()
    self.elements = {}
    for i = 1, BOARD_COLUMN_NUMBER do
        self.elements[i] = {}
        for j = 1, BOARD_ROW_NUMBER do
            if (i == 1 and j == 1) then
                self.elements[i][j] = 2
            else
                table.insert(self.elements[i], math.random(5))
            end
        end
    end

    self.elements[BOARD_ROW_NUMBER + 1] = {}
    for i = 1, BOARD_COLUMN_NUMBER do
        table.insert(self.elements[BOARD_ROW_NUMBER + 1], 0)
    end

    self.cellCollisionBoxes = {} ---@type CollisionBox[][]
    for i = 1, BOARD_COLUMN_NUMBER do
        self.cellCollisionBoxes[i] = {}
        for j = 1, BOARD_ROW_NUMBER do
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
    for i = 1, BOARD_COLUMN_NUMBER do
        for j = 1, BOARD_ROW_NUMBER do
            love.graphics.rectangle("line", (j - 1) * CELL_WIDTH, (i - 1) * CELL_HEIGHT, CELL_WIDTH, CELL_HEIGHT)
        end
    end

    -- Render elements
    for i = 1, BOARD_COLUMN_NUMBER do
        for j = 1, BOARD_ROW_NUMBER do
            -- Set different colors for elements
            if (self.elements[i][j] == 1) then
                love.graphics.setColor(0, 1, 0)
            end
            if (self.elements[i][j] == 2) then
                love.graphics.setColor(1, 0, 0)
            end
            if (self.elements[i][j] == 3) then
                love.graphics.setColor(0, 0, 1)
            end
            if (self.elements[i][j] == 4) then
                love.graphics.setColor(1, 1, 0)
            end
            if (self.elements[i][j] == 5) then
                love.graphics.setColor(0, 1, 1)
            end

            -- Draw a circle element
            if (self.elements[i][j] ~= 0) then
                love.graphics.circle(
                    "fill",
                    (j - 1) * CELL_WIDTH + CELL_WIDTH / 2,
                    (i - 1) * CELL_HEIGHT + CELL_HEIGHT / 2,
                    ELEMENT_RADIUS
                )
            end
        end
    end
    love.graphics.setColor(1, 1, 1)
end

function Board:update(dt)
    for i = 1, BOARD_COLUMN_NUMBER do
        for j = 1, BOARD_ROW_NUMBER do
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

    rowMatches = {}
    columnMatches = {}
    for row = 1, BOARD_ROW_NUMBER do
        table.insert(rowMatches, self:checkRowForMatches(row))
    end
    for column = 1, BOARD_COLUMN_NUMBER do
        table.insert(columnMatches, self:checkColumnForMatches(column))
    end
    for i = 1, #rowMatches do
        for j = 1, #rowMatches[i] do
            for k = rowMatches[i][j].first, rowMatches[i][j].last do
                self.elements[i][k] = 0
            end
        end
    end
    for i = 1, #columnMatches do
        for j = 1, #columnMatches[i] do
            for k = columnMatches[i][j].first, columnMatches[i][j].last do
                self.elements[k][i] = 0
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

---@return table
function Board:checkRowForMatches(row)
    local matches = {}
    local first, last
    for column = 1, BOARD_COLUMN_NUMBER do
        if (self.elements[row][column] == self.elements[row][column + 1]) then
            if (first == nil) then
                first = column
            end
        else
            last = column
            if (first and last and last - first >= 2) then
                table.insert(matches, {first = first, last = last})
            end
            first, last = nil, nil
        end
    end
    return matches
end

---@return table
function Board:checkColumnForMatches(column)
    local matches = {}
    local first, last
    for row = 1, BOARD_ROW_NUMBER do
        if (self.elements[row][column] == self.elements[row + 1][column]) then
            if (first == nil) then
                first = row
            end
        else
            last = row
            if (first and last and last - first >= 2) then
                table.insert(matches, {first = first, last = last})
            end
            first, last = nil, nil
        end
    end
    return matches
end
