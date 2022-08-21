LoadLines = {
    showLoadLines = true,
    showMapLines = true,
    showChunkLines = false,
    showGridLines = false,
    gridColor = "#0FB58"
}

function LoadLines:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function LoadLines:toggleLoadLines()
    self.showLoadLines = not self.showLoadLines
end

function LoadLines:toggleMapLines()
    self.showMapLines = not self.showMapLines
end

function LoadLines:toggleChunkLines()
    self.showChunkLines = not self.showChunkLines
end

function LoadLines:toggleGridLines()
    self.showGridLines = not self.showGridLines
end

function LoadLines:displayLoadLines()
    
end 

function LoadLines:displayMapLines()

end 

function LoadLines:displayChunkLines()

end 

function LoadLines:displayGridLines()
    for i = 0,15 do Display:drawLine(i*16+7,0,0,200, self.gridColor) end 
	for i = 0,7 do Display:drawLine(0,i*13,256,0, self.gridColor) end
	for i = 0,6 do Display:drawLine(0,7*13+15.5*i,256,0, self.gridColor) end
end 

function LoadLines:display()
    if self.showLoadLines then self:displayLoadLines() end
    if self.showMapLines then self:displayMapLines() end
    if self.showChunkLines then self:displayChunkLines() end
    if self.showGridLines then self:displayGridLines() end
end 
