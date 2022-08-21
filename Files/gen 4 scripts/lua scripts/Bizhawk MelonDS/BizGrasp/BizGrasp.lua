-- Lua script made by RETIRE

-- if the emu lags when extending screen size do the following:
-- go to display options
-- user prescale: 1x
-- scaling filter: None
-- Final filter: None

gameFolder  = "GameRepository"
displayFolder = "DisplayRepository"
utilityFolder = "UtilityRepository"
dataFolder = "Data"

dofile(displayFolder .. "/Display.lua")
dofile(gameFolder .. "/Game.lua")
dofile(utilityFolder .. "/Input.lua")
dofile(utilityFolder .. "/Memory.lua")
dofile(utilityFolder .. "/Utility.lua")

game = Game:new()
game:detect()

if game.game == 0 then
	while true do
		gui.text(0, 0, "Unknown or invalid ROM")
		emu.frameadvance()
	end
else
    game:runScript()
end