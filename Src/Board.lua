---@class Board
Board = Class {}

BOARD_ROW_NUMBER, BOARD_COLUMN_NUMBER = 5, 5
CELL_WIDTH, CELL_HEIGHT = 100, 100
BOARD_X, BOARD_Y =
    WINDOW_WIDTH / 2 - BOARD_COLUMN_NUMBER * CELL_WIDTH / 2,
    WINDOW_HEIGHT / 2 - BOARD_ROW_NUMBER * CELL_HEIGHT / 2
ELEMENT_RADIUS = 30
NUM_OF_ELEMENT_TYPE = 5
ELEMENT_SWAP_DURATION = 0.4

local function myStencilFunc()
    love.graphics.rectangle(
        "fill",
        BOARD_X,
        BOARD_Y - BOARD_ROW_NUMBER * CELL_HEIGHT,
        BOARD_COLUMN_NUMBER * CELL_WIDTH,
        BOARD_ROW_NUMBER * CELL_HEIGHT
    )
end

function Board:init()
    self.elements = {}
    for i = 1, BOARD_ROW_NUMBER do
        self.elements[i] = {}
        for j = 1, BOARD_COLUMN_NUMBER do
            table.insert(self.elements[i], math.random(NUM_OF_ELEMENT_TYPE))
        end
    end

    --- Add an extra row to avoid indexing nil value when check last column for matches
    self.elements[BOARD_ROW_NUMBER + 1] = {}
    for i = 1, BOARD_COLUMN_NUMBER do
        table.insert(self.elements[BOARD_ROW_NUMBER + 1], 0)
    end

    self.cellCollisionBoxes = {} ---@type CollisionBox[][]
    for i = 1, BOARD_ROW_NUMBER do
        self.cellCollisionBoxes[i] = {}
        for j = 1, BOARD_COLUMN_NUMBER do
            table.insert(
                self.cellCollisionBoxes[i],
                CollisionBox(BOARD_X + (j - 1) * CELL_WIDTH, BOARD_Y + (i - 1) * CELL_HEIGHT, CELL_WIDTH, CELL_HEIGHT)
            )
        end
    end

    self.prevSelectedElementPos = nil
    self.ignoreUserInput = false
    self.swappingElement1, self.swappingElement2 = nil, nil ---@type Element

    self.droppingElements = {} ---@type Element[]

    self:removeMatches()
end

function Board:draw()
    -- Render cells
    for i = 1, BOARD_ROW_NUMBER do
        for j = 1, BOARD_COLUMN_NUMBER do
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
    for i = 1, BOARD_ROW_NUMBER do
        for j = 1, BOARD_COLUMN_NUMBER do
            local id = self.elements[i][j]
            if id ~= 0 then
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(
                    Sprites.elements[self.elements[i][j]],
                    BOARD_X + (j - 1) * CELL_WIDTH + CELL_WIDTH / 2,
                    BOARD_Y + (i - 1) * CELL_HEIGHT + CELL_HEIGHT / 2,
                    0,
                    1,
                    1,
                    Sprites.elements[self.elements[i][j]]:getWidth() / 2,
                    Sprites.elements[self.elements[i][j]]:getHeight() / 2
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

    love.graphics.stencil(myStencilFunc, "replace", 1)
    love.graphics.setStencilTest("less", 1)

    love.graphics.rectangle(
        "fill",
        BOARD_X,
        BOARD_Y - BOARD_ROW_NUMBER * CELL_HEIGHT,
        BOARD_COLUMN_NUMBER * CELL_WIDTH,
        BOARD_ROW_NUMBER * CELL_HEIGHT
    )

    for i = 1, #self.droppingElements do
        self.droppingElements[i]:draw()
    end

    if (self.prevSelectedElementPos) then
        love.graphics.setLineWidth(10)
        love.graphics.rectangle(
            "line",
            BOARD_X + (self.prevSelectedElementPos.column - 1) * CELL_WIDTH + 10,
            BOARD_Y + (self.prevSelectedElementPos.row - 1) * CELL_HEIGHT + 10,
            CELL_WIDTH - 20,
            CELL_HEIGHT - 20,
            4,
            4
        )
        love.graphics.setLineWidth(1)
    end

    love.graphics.setStencilTest()
    love.graphics.setColor(1, 1, 1)
end

function Board:update(dt)
    if (not self.ignoreUserInput) then
        for i = 1, BOARD_ROW_NUMBER do
            for j = 1, BOARD_COLUMN_NUMBER do
                if (self.cellCollisionBoxes[i][j]:collidesWithMouse()) then
                    if (love.mouse.wasPressed(1)) then
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
                                    self.elements[self.prevSelectedElementPos.row][self.prevSelectedElementPos.column] ~=
                                        0 and
                                    self.elements[i][j] ~= 0)
                             then
                                self.ignoreUserInput = true

                                self:swapElements(
                                    self.prevSelectedElementPos.row,
                                    self.prevSelectedElementPos.column,
                                    i,
                                    j
                                )
                            end
                            self.prevSelectedElementPos = nil
                        end
                    end
                    if (love.mouse.wasPressed(2)) then
                        self.elements[i][j] = self.elements[i][j] < NUM_OF_ELEMENT_TYPE and self.elements[i][j] + 1 or 1
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
        Element(
        BOARD_X + (column1 - 1) * CELL_WIDTH + CELL_WIDTH / 2,
        BOARD_Y + (row1 - 1) * CELL_HEIGHT + CELL_HEIGHT / 2,
        temp1
    )
    self.swappingElement2 =
        Element(
        BOARD_X + (column2 - 1) * CELL_WIDTH + CELL_WIDTH / 2,
        BOARD_Y + (row2 - 1) * CELL_HEIGHT + CELL_HEIGHT / 2,
        temp2
    )

    Timer.tween(
        ELEMENT_SWAP_DURATION,
        self.swappingElement1,
        {x = self.swappingElement2.x, y = self.swappingElement2.y},
        "linear",
        function()
            self.elements[row1][column1] = temp2
            self.elements[row2][column2] = temp1

            self:processMatches(row1, column1, row2, column2)
        end
    )
    Timer.tween(
        ELEMENT_SWAP_DURATION,
        self.swappingElement2,
        {x = self.swappingElement1.x, y = self.swappingElement1.y},
        "linear"
    )
end

function Board:isNeighborElements(row1, column1, row2, column2)
    return (math.abs(row1 - row2) == 1 and column1 == column2) or (row1 == row2 and math.abs(column1 - column2) == 1)
end

---@return table
function Board:checkRowForMatches(row)
    local matches = {}
    local first, last
    for column = 1, BOARD_COLUMN_NUMBER do
        if (self.elements[row][column] == self.elements[row][column + 1] and self.elements[row][column] ~= 0) then
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
        if (self.elements[row][column] == self.elements[row + 1][column] and self.elements[row][column] ~= 0) then
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
        table.insert(rowMatches, i, self:checkRowForMatches(i))
        if #rowMatches[i] > 0 then
            matchCount = matchCount + 1
        end
    end
    for i = 1, BOARD_COLUMN_NUMBER do
        table.insert(columnMatches, i, self:checkColumnForMatches(i))
        if #columnMatches[i] > 0 then
            matchCount = matchCount + 1
        end
    end

    if (matchCount == 0) then
        Timer.after(
            ELEMENT_SWAP_DURATION,
            function()
                self.ignoreUserInput = false
            end
        )

        if self.swappingElement1 and self.swappingElement2 then
            local temp1, temp2 = self.elements[row1][column1], self.elements[row2][column2]
            self.elements[row1][column1], self.elements[row2][column2] = 0, 0

            Timer.tween(
                ELEMENT_SWAP_DURATION,
                self.swappingElement1,
                {x = self.swappingElement2.x, y = self.swappingElement2.y},
                "linear",
                function()
                    self.elements[row1][column1] = temp2
                    self.elements[row2][column2] = temp1

                    self.swappingElement1, self.swappingElement2 = nil, nil

                    if (not self:hasPotentialMatches()) then
                        self:regenBoard()
                        self:removeMatches()
                    end
                end
            )
            Timer.tween(
                ELEMENT_SWAP_DURATION,
                self.swappingElement2,
                {x = self.swappingElement1.x, y = self.swappingElement1.y},
                "linear"
            )
        end
    end

    if (matchCount > 0) then
        Timer.after(
            0.15,
            function()
                for i, value in pairs(rowMatches) do
                    for j = 1, #rowMatches[i] do
                        for k = rowMatches[i][j].first, rowMatches[i][j].last do
                            self.elements[i][k] = 0
                        end
                    end
                end
                for i, value in pairs(columnMatches) do
                    for j = 1, #columnMatches[i] do
                        for k = columnMatches[i][j].first, columnMatches[i][j].last do
                            self.elements[k][i] = 0
                        end
                    end
                end

                self.swappingElement1, self.swappingElement2 = nil, nil

                self:dropElementsAfterMatching()
            end
        )
    end
end

function Board:genAndDropNewElements(row1, column1, row2, column2)
    local initBoard = table.deepcopy(self.elements)
    local endPositions = {}
    self.droppingElements = {}

    for i = 1, BOARD_ROW_NUMBER do
        for j = 1, BOARD_COLUMN_NUMBER do
            if (self.elements[i][j] == 0) then
                self.elements[i][j] = math.random(5)

                table.insert(
                    endPositions,
                    {
                        x = BOARD_X + (j - 1) * CELL_WIDTH + CELL_WIDTH / 2,
                        y = BOARD_Y + (i - 1) * CELL_HEIGHT + CELL_HEIGHT / 2
                    }
                )
                table.insert(
                    self.droppingElements,
                    Element(
                        BOARD_X + (j - 1) * CELL_WIDTH + CELL_WIDTH / 2,
                        BOARD_Y + (i - 1) * CELL_HEIGHT + CELL_HEIGHT / 2 - BOARD_ROW_NUMBER * CELL_HEIGHT,
                        self.elements[i][j]
                    )
                )
            end
        end
    end

    local resultBoard = table.deepcopy(self.elements)
    self.elements = initBoard

    local time = (endPositions[1].y - self.droppingElements[1].y) / 600
    for i = 1, #self.droppingElements do
        Timer.tween(
            (endPositions[i].y - self.droppingElements[i].y) / 600,
            self.droppingElements[i],
            endPositions[i],
            "linear"
        )
    end

    Timer.after(
        time,
        function()
            self.droppingElements = {}
            self.elements = resultBoard

            self:processMatches()
        end
    )
end

function Board:dropElementsAfterMatching()
    local endPositions = {}

    local initialBoard = table.deepcopy(self.elements)
    for column = 1, BOARD_COLUMN_NUMBER do
        for row = BOARD_ROW_NUMBER - 1, 1, -1 do
            if (self.elements[row][column] ~= 0) then
                local i, j, type = row, column, self.elements[row][column]
                local elementFellOnce = false
                while (i <= BOARD_ROW_NUMBER - 1 and self.elements[i + 1][j] == 0) do
                    if (not elementFellOnce) then
                        initialBoard[i][j] = 0
                        elementFellOnce = true
                    end

                    self.elements[i + 1][j] = self.elements[i][j]
                    self.elements[i][j] = 0
                    i = i + 1
                end

                if (elementFellOnce) then
                    table.insert(
                        endPositions,
                        {
                            x = BOARD_X + (j - 1) * CELL_WIDTH + CELL_WIDTH / 2,
                            y = BOARD_Y + (i - 1) * CELL_HEIGHT + CELL_HEIGHT / 2
                        }
                    )
                    table.insert(
                        self.droppingElements,
                        Element(
                            BOARD_X + (column - 1) * CELL_WIDTH + CELL_WIDTH / 2,
                            BOARD_Y + (row - 1) * CELL_HEIGHT + CELL_HEIGHT / 2,
                            type
                        )
                    )
                end
            end
        end
    end
    local resultBoard = table.deepcopy(self.elements)
    self.elements = initialBoard

    for i = 1, #self.droppingElements do
        Timer.tween(0.5, self.droppingElements[i], endPositions[i], "linear")
    end

    Timer.after(
        0.5,
        function()
            self.droppingElements = {}
            self.elements = resultBoard

            self:genAndDropNewElements()
        end
    )
end

function Board:removeMatches()
    local matchCount

    repeat
        local rowMatches = {}
        local columnMatches = {}
        matchCount = 0

        for i = 1, BOARD_ROW_NUMBER do
            table.insert(rowMatches, i, self:checkRowForMatches(i))
            if #rowMatches[i] > 0 then
                matchCount = matchCount + 1
            end
        end
        for i = 1, BOARD_COLUMN_NUMBER do
            table.insert(columnMatches, i, self:checkColumnForMatches(i))
            if #columnMatches[i] > 0 then
                matchCount = matchCount + 1
            end
        end

        if (matchCount > 0) then
            for i, value in pairs(rowMatches) do
                for j = 1, #rowMatches[i] do
                    for k = rowMatches[i][j].first, rowMatches[i][j].last do
                        self.elements[i][k] = math.random(NUM_OF_ELEMENT_TYPE)
                    end
                end
            end
            for i, value in pairs(columnMatches) do
                for j = 1, #columnMatches[i] do
                    for k = columnMatches[i][j].first, columnMatches[i][j].last do
                        self.elements[k][i] = math.random(NUM_OF_ELEMENT_TYPE)
                    end
                end
            end
        end
    until matchCount == 0
end

function Board:regenBoard()
    for i = 1, BOARD_ROW_NUMBER do
        self.elements[i] = {}
        for j = 1, BOARD_COLUMN_NUMBER do
            table.insert(self.elements[i], math.random(NUM_OF_ELEMENT_TYPE))
        end
    end
end

function Board:hasPotentialMatches()
    for row = 1, BOARD_ROW_NUMBER do
        for column = 1, BOARD_COLUMN_NUMBER do
            if
                (self:getElement(row, column) == self:getElement(row + 2, column) and
                    self:getElement(row + 2, column) ~= nil) and
                    (self:getElement(row, column) == self:getElement(row + 1, column - 1) or
                        self:getElement(row, column) == self:getElement(row + 1, column + 1))
             then
                return true
            end

            if
                (self:getElement(row, column) == self:getElement(row, column + 2) and
                    self:getElement(row, column + 2) ~= nil) and
                    (self:getElement(row, column) == self:getElement(row - 1, column + 1) or
                        self:getElement(row, column) == self:getElement(row + 1, column + 1))
             then
                return true
            end

            if
                (self:getElement(row, column) == self:getElement(row, column + 1) and
                    self:getElement(row, column + 1) ~= nil) and
                    (self:getElement(row, column - 2) == self:getElement(row, column) or
                        self:getElement(row, column + 3) == self:getElement(row, column) or
                        self:getElement(row + 1, column - 1) == self:getElement(row, column) or
                        self:getElement(row - 1, column - 1) == self:getElement(row, column) or
                        self:getElement(row + 1, column + 2) == self:getElement(row, column) or
                        self:getElement(row - 1, column + 2) == self:getElement(row, column))
             then
                return true
            end

            if
                self:getElement(row, column) == self:getElement(row + 1, column) and
                    (self:getElement(row, column) == self:getElement(row + 3, column) or
                        self:getElement(row, column) == self:getElement(row - 2, column))
             then
                return true
            end
        end
    end
    return false
end

function Board:getElement(row, column)
    if (self.elements[row]) then
        return self.elements[row][column]
    end
    return nil
end
