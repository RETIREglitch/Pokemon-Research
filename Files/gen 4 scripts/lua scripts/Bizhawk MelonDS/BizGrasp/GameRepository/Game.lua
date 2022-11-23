Game =  {
    romName,
    id,
    language,
    game,
    gameName,
    dir
}

gameSelection = {
    ["POKEMON D   ADA"] = {game = 1, gameName = "Diamond", dir = "/DP", script = "/DiamondPearl.lua"},
    ["POKEMON P   APA"] = {game = 1, gameName = "Pearl", dir = "/DP", script = "/DiamondPearl.lua"},
    ["POKEMON PL  CPU"] = {game = 2, gameName = "Platinum", dir = "/PL", script = "/Platinum.lua"},
    ["POKEMON SS  IPG"] = {game = 3, gameName = "Soulsilver", dir = "/HGSS", script = "/HeartGoldSoulSilver.lua"},
    ["POKEMON HG  IPK"] = {game = 3, gameName = "Heartgold", dir = "/HGSS", script = "/HeartGoldSoulSilver.lua"},
    ["PKMN DP DEMOY23"] = {game = 4, gameName = "Diamond & Pearl DEMO", dir = "/DPDEMO", script = "/DiamondPearlDemo.lua"},
    ["POKEMON B   IRB"] = {game = 5, gameName = "Black", dir = "/BW", script = "/BlackWhite.lua"},
    ["POKEMON W   IRA"] = {game = 5, gameName = "White", dir = "/BW", script = "/BlackWhite.lua"},
    ["POKEMON B2  IRE"] = {game = 5, gameName = "B2", dir = "/BW2", script = "/BlackWhite2.lua"},
    ["POKEMON W2  IRD"] = {game = 5, gameName = "W2", dir = "/BW2", script = "/BlackWhite2.lua"} 
}

languageTable = {
    D = "German",
    E = "English",
    F = "French",
    I = "Italian",
    K = "Korean",
    S = "Spanish",
    J = "Japanese"
}

function Game:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Game:detect()
    self.romName = Memory:readascii(0x023FFE00,0x10)
    self.id = string.sub(self.romName,0,#self.romName-1)
    self.language = languageTable[string.sub(self.romName,#self.romName,#self.romName)] -- or "Unknown" -- You may edit this, or add code to find language for BW2
    self.game = (gameSelection[self.id] or {game = 0}).game
    self.gameName = (gameSelection[self.id] or {gameName = ""}).gameName
    self.dir = gameFolder .. (gameSelection[self.id] or {dir = ""}).dir
    self.script = self.dir .. (gameSelection[self.id] or {script = ""}).script
end 

function Game:runScript()
    Display:setGameExtraPadding()

    dofile(self.script) -- extend Game class with detected game's features
    self:init()

	while true do
		collectgarbage()
        self:main()
		emu.frameadvance()
	end
end

function Game:displayGameInfo()
    gui.text(0,20,"Rom: " .. self.romName .. " - " .. self.language .. " " .. self.gameName)
end 