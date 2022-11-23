function Game:init()
    self:importFiles()
    MemoryState = MemoryState:new()
    Input = Input:new(keyBinds)
    ScrCmd = ScrCmd:new()
    LoadLines = LoadLines:new()
    PlayerData = PlayerData:new()
    Player = Player:new()
    ChunkData = ChunkData:new()
    Chunks = Chunks:new()
end

function Game:importFiles()
    dofile(self.dir .. "/Data/ChunkData.lua")
    dofile(self.dir .. "/Data/PlayerData.lua")
    dofile(self.dir .. "/Data/ScrCmdData.lua")
    dofile(self.dir .. "/Data/KeyBinds.lua")
    dofile(self.dir .. "/Repositories/Player.lua")
    dofile(self.dir .. "/Repositories/ScrCmd.lua")
    dofile(self.dir .. "/Repositories/LoadLines.lua")
    dofile(self.dir .. "/Repositories/MemoryState.lua")
    dofile(self.dir .. "/Repositories/Chunks.lua")
end

function Game:main()
    MemoryState:update() -- always execute this first to get base pointer
    Display:update()
    PlayerData:update()
    ChunkData:update()

    Input:runChecks()

    MemoryState:display()
    Player:display()
    ScrCmd:display()
    LoadLines:display()
    Chunks:display()
    self:displayGameInfo()
end

