function Game:init()
    self:importFiles()
    MemoryState = MemoryState:new()
    Input = Input:new(keyBinds)
    Display = Display:new()
    ScrCmd = ScrCmd:new()
    LoadLines = LoadLines:new()
    PlayerData = PlayerData:new()
    Player = Player:new()
end

function Game:importFiles()
    dofile(self.dir .. "/Data/PlayerData.lua")
    dofile(self.dir .. "/Data/ScrCmdData.lua")
    dofile(self.dir .. "/Data/KeyBinds.lua")
    dofile(self.dir .. "/Repositories/Player.lua")
    dofile(self.dir .. "/Repositories/ScrCmd.lua")
    dofile(self.dir .. "/Repositories/LoadLines.lua")
    dofile(self.dir .. "/Repositories/MemoryState.lua")
end

function Game:main()
    MemoryState:update() -- always execute this first to get base pointer
    MemoryState:display()
    Input:runChecks()
    PlayerData:update()
    Player:display()
    ScrCmd:display()
    LoadLines:display()
end

