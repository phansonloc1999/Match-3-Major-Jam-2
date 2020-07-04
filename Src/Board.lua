---@class Board
Board = Class {}

BOARD_ROW_NUMBER, BOARD_COLUMN_NUMBER = 5, 5
CELL_WIDTH, CELL_HEIGHT = 100, 100
BOARD_X, BOARD_Y =
    WINDOW_WIDTH / 2 - BOARD_COLUMN_NUMBER * CELL_WIDTH / 2,
    WINDOW_HEIGHT / 2 - BOARD_ROW_NUMBER * CELL_HEIGHT / 2
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

    --- Add an extra row to avoid indexing nil value when check last column for matches
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
                CollisionBox(BOARD_X + (j - 1) * CELL_WIDTH, BOARD_Y + (i - 1) * CELL_HEIGHT, CELL_WIDTH, CELL_HEIGHT)
            )
        end
    end

    self.prevSelectedElementPos = nil
    self.ignoreUserInput = true
    self.swappingElement1, self.swappingElement2 = nil, nil ---@type Element

    self:processMatches()
end

function Board:draw()
    -- Render cells
    for i = 1, BOARD_COLUMN_NUMBER do
        for j = 1, BOARD_ROW_NUMBER do
            love.graphics.rectangle(
                "line",
                BOARD_X + (j - 1) * CELL_WIDTH,
                BOARD_Y + (i - 1) * CELL_HEIGHT,
                CELL_WIDTH,
                CELL_HEIGHT
            )
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
                    BOARD_X + (j - 1) * CELL_WIDTH + CELL_WIDTH / 2,
                    BOARD_Y + (i - 1) * CELL_HEIGHT + CELL_HEIGHT / 2,
                    ELEMENT_RADIUS
                )
            end
        end
    end

    if (self.swappingElement1) then
        self.swappingElement1:draw()
    end
    if (self.swappingElement2) then
        self.swappingElement2:draw()
    end

    love.graphics.setColor(1, 1, 1)
end

function Board:update(dt)
    if (not self.ignoreUserInput) then
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
                            ) and
                                self.elements[self.prevSelectedElementPos.row][self.prevSelectedElementPos.column] ~= 0 and
                                self.elements[i][j] ~= 0)
                         then
                            self.ignoreUserInput = true

                            self:swapElements(self.prevSelectedElementPos.row, self.prevSelectedElementPos.column, i, j)
                        end
                        self.prevSelectedElementPos = nil
                    end
                end
            end
        end
    end
end

function Board:swapElements(row1, column1, row2, column2)
    local temp1, temp2 = self.elements[row1][column1], self.elements[row2][column2]
    self.elements[row1][column1], self.elements[row2][column2] = 0, 0

    self.swappingElement1 =
        SwappingElement(
        BOARD_X + (column1 - 1) * CELL_WIDTH + CELL_WIDTH / 2,
        BOARD_Y + (row1 - 1) * CELL_HEIGHT + CELL_HEIGHT / 2,
        temp1
    )
    self.swappingElement2 =
        SwappingElement(
        BOARD_X + (column2 - 1) * CELL_WIDTH + CELL_WIDTH / 2,
        BOARD_Y + (row2 - 1) * CELL_HEIGHT + CELL_HEIGHT / 2,
        temp2
    )

    Timer.tween(
        1,
        self.swappingElement1,
        {x = self.swappingElement2.x, y = self.swappingElement2.y},
        "linear",
        function()
            self.elements[row1][column1] = temp2
            self.elements[row2][column2] = temp1

            self:processMatches(row1, column1, row2, column2)
        end
    )
    Timer.tween(1, self.swappingElement2, {x = self.swappingElement1.x, y = self.swappingElement1.y}, "linear")
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

function Board:processMatches(row1, column1, row2, column2)
    local rowMatches = {}
    local columnMatches = {}
    local matchCount = 0

    for i = 1, BOARD_ROW_NUMBER do
        table.insert(rowMatches, self:checkRowForMatches(i))
        if #rowMatches[i] > 0 then
            matchCount = matchCount + 1
            print("Match at row " .. i)
        end
    end
    for i = 1, BOARD_COLUMN_NUMBER do
        table.insert(columnMatches, self:checkColumnForMatches(i))
        if #columnMatches[i] > 0 then
            matchCount = matchCount + 1
            print("Match at column " .. i)
        end
    end

    if (matchCount == 0) and self.swappingElement1 and self.swappingElement2 then
        local temp1, temp2 = self.elements[row1][column1], self.elements[row2][column2]
        self.elements[row1][column1], self.elements[row2][column2] = 0, 0

        Timer.tween(
            1,
            self.swappingElement1,
            {x = self.swappingElement2.x, y = self.swappingElement2.y},
            "linear",
            function()
                self.elements[row1][column1] = temp2
                self.elements[row2][column2] = temp1

                self.ignoreUserInput = false
                self.swappingElement1, self.swappingElement2 = nil, nil
            end
        )
        Timer.tween(1, self.swappingElement2, {x = self.swappingElement1.x, y = self.swappingElement1.y}, "linear")
    end

    Timer.after(
        1,
        function()
            if (matchCount > 0) then
                for i, value in pairs(rowMatches) do
                    for j = 1, #rowMatches[i] do
                        for k = rowMatches[i][j].first, rowMatches[i][j].last do
                            print("Element type was " .. self.elements[i][k])
                            self.elements[i][k] = 0
                        end
                        print("==============================")
                    end
                end
                for i, value in pairs(columnMatches) do
                    for j = 1, #columnMatches[i] do
                        for k = columnMatches[i][j].first, columnMatches[i][j].last do
                            print("Element type was " .. self.elements[k][i])
                            self.elements[k][i] = 0
                        end
                        print("==============================")
                    end
                end

                self.swappingElement1, self.swappingElement2 = nil, nil

                --- Then regen
                self:regenRemovedElements(rowMatches, columnMatches)
            end
        end
    )
end

function Board:regenRemovedElements(rowMatches, columnMatches)
    Timer.after(
        2,
        function()
            for i, value in pairs(rowMatches) do
                for j = 1, #rowMatches[i] do
                    for k = rowMatches[i][j].first, rowMatches[i][j].last do
                        self.elements[i][k] = math.random(5)
                    end
                end
            end
            for i, value in pairs(columnMatches) do
                for j = 1, #columnMatches[i] do
                    for k = columnMatches[i][j].first, columnMatches[i][j].last do
                        self.elements[k][i] = math.random(5)
                    end
                end
            end

            self.ignoreUserInput = false
            Timer.clear()
        end
    )
end
