Display = {
    top = 0;
    bottom = 0;
    left = 260;
    right = 260;
    screenX = 260,
    topScreenY = 0,
    bottomScreenY = 382
    screenY = {self.topScreenY,self.bottomScreenY}
}

function Display:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Display:setGameExtraPadding()
    client.SetGameExtraPadding(Display.left,Display.top,Display.right,Display.bottom)
    client.setwindowsize(2)
    gui.defaultTextBackground(0)
end

function Display:drawLine(x,y,width,height,clr,screenY,screenX)
	screenY = screenY or 1
    screenX = screenX or 0
	gui.drawLine(x+screenX*self.screenX,self.screenY[screen]+y,x+screenX*self.screenX+width,self.screenY[screen]+y+height,clr)
end 

function Display:update()
    if MemoryState.gameplayState == "Underground" then 
        self.screenY = {self.bottomScreenY,self.topScreenY} 
        return 
    end
    self.screenY = {self.topScreenY,self.bottomScreenY}
end