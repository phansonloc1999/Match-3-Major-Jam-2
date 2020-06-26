---@class ScanLine
ScanLine = Class {}

LINES_PER_FRAME = 20

function ScanLine:init()
    self.currentData = love.image.newImageData("Assets/eat-1.png")
    self.currentImage = love.graphics.newImage(self.currentData)
    self.newData = love.image.newImageData("Assets/eat-2.png") ---@type ImageData

    self.nextPixelX = 0
    self.nextPixelY = 0
end

function ScanLine:draw()
    love.graphics.draw(self.currentImage, 0, 0, 0, 5, 5)
end

function ScanLine:update(dt)
    for i = 1, LINES_PER_FRAME do
        if
            (self.nextPixelX <= self.currentData:getWidth() - 1) and
                (self.nextPixelY <= self.currentData:getHeight() - 1)
         then
            local r, g, b, a = self.newData:getPixel(self.nextPixelX, self.nextPixelY)
            self.currentData:setPixel(self.nextPixelX, self.nextPixelY, r, g, b, a)

            self.nextPixelX = self.nextPixelX + 1
            if (self.nextPixelX == self.currentData:getWidth() - 1) then
                self.currentImage = love.graphics.newImage(self.currentData)
                self.nextPixelY = self.nextPixelY + 1
                self.nextPixelX = 0
            end
        end
    end
end
