Chunks = {
    showChunks = false;
    currentTileColors = {{},{},{},{}}
}

function Chunks:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Chunks:displayChunks()
    --gui.drawImage(game.dir .. "/Images/test.bmp",Display.rightScreen,0)
    for i = 0, 3 do
        self:displayChunk(ChunkData.startChunks[i+1],i)
    end
end

function Chunks:displayChunk(addr,chunkId)
    -- local w = 3
    -- local h = 3
    -- local paddingLeft = (32*w)*(chunkId%2)
    -- local paddingTop = (32*h)*(math.floor(chunkId/2))
    local chunk = memory.read_bytes_as_array(addr,2048)

    for i=0,1023 do
        tileId = chunk[i*2+1]
        collision = chunk[i*2+2]
        tileColor = self:getTileColor(tileId,collision)
        self.currentTileColors[chunkId+1][i+1] = tileColor
        BMP:createImage(self.currentTileColors[chunkId+1],"chunk" ..chunkId,32,32)
        --gui.drawRectangle(Display.rightScreen + paddingLeft + i%32*w,paddingTop + math.floor(i/32)*h,w-1,h-1,tileColor,tileColor)
        
    end

end

function Chunks:getTileColor(tileId,collision)
	if tileId == 0x00 then 
		if collision > 0x7F then return 0xCCCCCC end
	end 
	return ChunkData.tileIds[tileId]
end

function Chunks:toggleChunks()
    self.showChunks = not self.showChunks
end 

function Chunks:display()
    if MemoryState.gameplayState == not "Overworld" then return end
    if self.showChunks then self:displayChunks() end 
end