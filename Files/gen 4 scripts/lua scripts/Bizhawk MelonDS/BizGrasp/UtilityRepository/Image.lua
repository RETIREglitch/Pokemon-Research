BMP = {}

function BMP:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
	self.key = {}
	self.lastKey = {}
    return o
end



function BMP:createImage(colorArray,filename,width,height)
    file = io.open("Images/" .. filename .. ".bmp", "wb")
    io.output(file)
    local bmpHeader = self:addHeader(width,height,10)

    io.close(file)
end

function BMP:addHeader(width,height,colorCount)
    local headerSize = 0x28
    local imageSize = width * height
    local size = imageSize + headerSize
    local colorCount = colorCount
    
    file:write(string.char(0x4D)) -- signature, must be 4D42 hex ("BM")
    --io.write(size)
    -- local header = {
    --     signature = {0x4D42,4}, -- signature, must be 4D42 hex ("BM")
    --     size = {size,4}, -- size of BMP file in bytes (unreliable)
    --     reserved0 = {0,2}, -- reserved, must be zero
    --     reserved1 = {0,2}, -- reserved, must be zero
    --     imageOffs = {headerSize+4,4}, -- offset to start of image data in bytes, from start of file
    --     sizeBitMapInfoHeader = {headerSize,4}, -- size of BITMAPINFOHEADER structure
    --     width = {width,4},-- image width in pixels
    --     height = {height,4}, -- image height in pixels
    --     planes = {1,2}, -- number of planes in the image, must be 1
    --     bpp = {24,2}, -- number of bits per pixel (1, 4, 8, or 24)
    --     compressionType = {0,4}, -- compression type (0=none, 1=RLE-8, 2=RLE-4)
    --     sizeImageData = {Imagesize,4}, -- size of image data in bytes (including padding)
    --     ppmHorizontal = {0,4}, -- horizontal resolution in pixels per meter (unreliable)
    --     ppmVertical = {0,4}, -- vertical resolution in pixels per meter (unreliable)
    --     colorCount = {colorCount,4},-- number of colors in image, or zero
    --     importantColorCount = {colorCount,4}-- number of important colors, or zero
    -- }

end