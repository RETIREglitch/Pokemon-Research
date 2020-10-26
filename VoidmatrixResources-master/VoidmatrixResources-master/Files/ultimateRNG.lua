-- Lua Script made by MKDasher
-- Based on gen 3 lua script by FractalFusion

-- TODO:
-- Roaming pkm (birds)
-- Next pkrs frame
-- Object rate for pokemon
-- Fix Encounters in HGSS

-------------------------
local testingseed_forRNG =  0xD50505DF
-------------------------

local berryMod
local berryGift
local berryMode = {5, 17, 26}
local berryMap = {"Floaroma", "Pastoria", "R208"}
local berryModeId = 1
local berryList = {}
local berryList_1 = {"Cheri", "Chesto", "Pecha", "Rawst", "Aspear"}
local berryList_2 = {"Occa", "Passho", "Wacan", "Rindo", "Yache", "Chople", "Kebia", "Shuca", "Coba", "Payapa", "Tanga", "Charti", "Kasib", "Haban", "Colbur", "Babiri", "Chilan"}
local berryList_3 = {"Cheri", "Chesto", "Pecha", "Rawst", "Aspear", "Leppa", "Oran", "Persim", "Lum", "Sitrus", "Figy", "Wiki", "Mago", "Aguav", "Iapapa", "Razz", "Bluk", "Nanab", "Wepear", "Pinap", "Pomeg", "Kelpsy", "Qualot", "Hondew", "Grepa", "Tamato"}

function berries(mode)
	mode = berryModeId
	if mode == 1 then
		berryList = berryList_1
	elseif mode == 2 then
		berryList = berryList_2
	else berryList = berryList_3
	end
end

local isPillar = false

local bottommenu_mode = 1
local bottommenu_str = {"   None   ", "Next encs ", "  Slots   ","   Misc   ", "Minimalist","   NPCs   "}
local num_menus = 6

local land_mode = 1 -- menu mode (Auto = default)
local land_modehitbox = {0, 70, 106, 143}
local curland_mode = 0 -- real mode
local land = 0 -- selected mode
local landstr = {"Grass", "Water"}

local movement_mode = 1
local curmovement_mode = 1
local movement_rate
local movement_str = {"Walk", "Swim", "Bike", "Run "}
local movement_modehitbox = {0,64,94,124,154,180}
local running_check = 0

local encrate_mode = 1
local encrate_modehitbox = {0, 53, 71, 89, 107, 125, 143}

local currentEmuFrameCount = emu.framecount()
local distlast = 0

local hitboxstart = 73
local hitboxheight = -35
local menuvisible = 0

local encrate = 0
local curencrate = 0

local stepcounter = 0
local maxstepcounter = 0

local gameframecount = 0
local lagcount = 0

local rshift, lshift=bit.rshift, bit.lshift
local lastRNG = 0
local i
local tabl={}
local prev={}

local hour = 0

local game = 1
local gamename = ""
local is_hgss = 0

local pointerAddr = {0x02106FAC, 0x02101D2C, 0x0211186C}
local stepcounterAddrOffset = {0x2FA40, 0x2E834, 0x31046}
local stepcnt128AddrOffset = {0xE044, 0xDE34, 0xDE6A}
local oppDirCountOffset = {0,0,0x31044} -- HGSS only. Need space to place this somewhere.
local RNGAddr = {0x021C4D48, 0x021BFB14, 0x021D15A8}
local curlandmodeAddrOffset = {0x31AE2, 0x3090A, 0x32E0E}
local curmovementmodeAddrOffset = {0x31950, 0x30778, 0x32C7C}
local grassEncAddrOffset = {0x315C0, 0x303C4, 0x32A34}
local waterEncAddrOffset = {0x3168C, 0x30490, 0x32AA9}
local framecountAddr = {0x021C48E4, 0x021BF6A8, 0x21D1138}
local IGTAddrOffset = {0xD29A, 0xD07E, 0xD076}
local clockAddr = {0x021C4828, 0x021BF5E8, 0x21D1068}
local TIDAddrOffset = {0xD288, 0xD06C, 0xD064}
local LIDAddrOffset = {0xE028, 0xDE18, 0xDE4C}
local objDataOffset = {0x31A48, 0x30870, 0x32D74}
local objCountOffset = {0x318F0, 0x30718, 0x32C1C}
local objDataSize = {0x128, 0x128, 0x12c}

local encslots_pkm = {}
local encslots_lvl = {}
local waterslots_pkm = {}
local waterslots_minlvl = {}
local waterslots_maxlvl = {}

function npcdraw(a,b,c,size)
	if (a > -60 and a < 60 and b < 60 and b > -60) then
		gui.box(a+193-size,b+63-size,a+193+size,b+63+size,c,c)
	end
end
function drawsquare(a,b,c,d)
 gui.box(a,b,a+d,b+d,c)
end
function drawarrowdown(a,b,c)
 gui.line(a,b,a-2,b-2,c)
 gui.line(a,b,a+2,b-2,c)
 gui.line(a,b,a,b-6,c)
end
function drawarrowleft(a,b,c)
 gui.line(a,b+3,a+2,b+5,c)
 gui.line(a,b+3,a+2,b+1,c)
 gui.line(a,b+3,a+6,b+3,c)
end
function drawarrowright(a,b,c)
 gui.line(a,b+3,a-2,b+5,c)
 gui.line(a,b+3,a-2,b+1,c)
 gui.line(a,b+3,a-6,b+3,c)
end
function mult32(a,b)
 local c=rshift(a,16)
 local d=a%0x10000
 local e=rshift(b,16)
 local f=b%0x10000
 local g=(c*f+d*e)%0x10000
 local h=d*f
 local i=g*0x10000+h
 return i
end

function gettop(a)
	return(rshift(a,16))
end

function getbits(a,b,d)
	return rshift(a,b)%lshift(1,d)
end

local multspa={
 0x41C64E6D, 0xC2A29A69, 0xEE067F11, 0xCFDDDF21, 0x5F748241, 0x8B2E1481, 0x76006901, 0x1711D201,
 0xBE67A401, 0xDDDF4801, 0x3FFE9001, 0x90FD2001, 0x65FA4001, 0xDBF48001, 0xF7E90001, 0xEFD20001,
 0xDFA40001, 0xBF480001, 0x7E900001, 0xFD200001, 0xFA400001, 0xF4800001, 0xE9000001, 0xD2000001,
 0xA4000001, 0x48000001, 0x90000001, 0x20000001, 0x40000001, 0x80000001, 0x00000001, 0x00000001}

local multspb={
 0x00006073, 0xE97E7B6A, 0x31B0DDE4, 0x67DBB608, 0xCBA72510, 0x1D29AE20, 0xBA84EC40, 0x79F01880,
 0x08793100, 0x6B566200, 0x803CC400, 0xA6B98800, 0xE6731000, 0x30E62000, 0xF1CC4000, 0x23988000,
 0x47310000, 0x8E620000, 0x1CC40000, 0x39880000, 0x73100000, 0xE6200000, 0xCC400000, 0x98800000,
 0x31000000, 0x62000000, 0xC4000000, 0x88000000, 0x10000000, 0x20000000, 0x40000000, 0x80000000}

function rngAdvance(a)
	return mult32(a,0x41C64E6D) + 0x6073
end

function getSeedDistance(a)
	test=testingseed_forRNG
    distseed=0
    for j=0,31,1 do
			if getbits(a,j,1)~=getbits(test,j,1) then
				test=mult32(test,multspa[j+1])+multspb[j+1]
				distseed=distseed+bit.lshift(1,j)
				if j==31 then
					distseed=distseed+0x100000000
				end
			end
    end
	if distseed > 0x7FFFFFFF then
		distseed = distseed - 0xFFFFFFFF
	end
	return distseed
end

function fillEncSlots()
	if is_hgss == 1 then
		-- fill grass slots
		slotAddr = pointer + grassEncAddrOffset[game] + 8
		for i=1,12,1 do
			encslots_lvl[i] = memory.readbyte(slotAddr)
			slotAddr = slotAddr + 1
		end
		slotAddr = pointer + grassEncAddrOffset[game] + 20
		if hour >= 10 and hour < 20 then
			slotAddr = slotAddr + 24
		elseif hour >= 20 or hour < 4 then
		    slotAddr = slotAddr + 48
		end
		for i=1,12,1 do
			encslots_pkm[i] = memory.readword(slotAddr)
			slotAddr = slotAddr + 2
		end
		-- fill water slots
		slotAddr = pointer + waterEncAddrOffset[game] - 17
		for i=1,5,1 do
			waterslots_minlvl[i] = memory.readbyte(slotAddr)
			slotAddr = slotAddr + 1
			waterslots_maxlvl[i] = memory.readbyte(slotAddr)
			slotAddr = slotAddr + 1
			waterslots_pkm[i] = memory.readword(slotAddr)
			slotAddr = slotAddr + 2
		end
	else
		-- fill grass slots
		slotAddr = pointer + grassEncAddrOffset[game] + 4
		for i=1,12,1 do
			encslots_lvl[i] = memory.readdword(slotAddr)
			slotAddr = slotAddr + 4
			encslots_pkm[i] = memory.readdword(slotAddr)
			slotAddr = slotAddr + 4
		end
		-- overwrite slot 2 and 3 (3 and 4 in the array) with day / night encounters
		slotAddr = pointer + grassEncAddrOffset[game] + 0x6c
		if hour >= 10 and hour < 20 then --day
			encslots_pkm[3] = memory.readdword(slotAddr)
			encslots_pkm[4] = memory.readdword(slotAddr + 4)
		elseif hour >= 20 or hour < 4 then --night
			encslots_pkm[3] = memory.readdword(slotAddr + 8)
			encslots_pkm[4] = memory.readdword(slotAddr + 12)
		end
		-- fill water slots
		slotAddr = pointer + waterEncAddrOffset[game] + 4
		for i=1,5,1 do
			waterslots_maxlvl[i] = memory.readbyte(slotAddr)
			slotAddr = slotAddr + 1
			waterslots_minlvl[i] = memory.readbyte(slotAddr)
			slotAddr = slotAddr + 3
			waterslots_pkm[i] = memory.readdword(slotAddr)
			slotAddr = slotAddr + 4
		end
	end
end

function getHGSSEncRate(a, b) --0X14 0X28 0X46 / walk run bike
	erate = 0
	if (b > 3) then erate = 0x3c + a
	elseif (b > 2) then erate = 0x28 + a
	elseif (b > 1) then erate = 0x1E + a
	else erate = a
	end
	if erate > 0x64 then
		return 0x64
	else
		return erate
	end
end

function ModeHandler()
	curland_mode = memory.readbyte(pointer + curlandmodeAddrOffset[game])
	if (curland_mode == 16 or curland_mode == 21) then --16 and 21 are water values
		curland_mode = 2
	else
		curland_mode = 1
	end

	if land_mode == 2 then -- Grass
		land = 1
	elseif land_mode == 3 then --(Water)
		land = 2
	else --(Auto)
		land = curland_mode
	end

	if land == 1 then -- Grass
		curencrate = memory.readbyte(pointer + grassEncAddrOffset[game])
	else -- land == 2 --(Water)
		curencrate = memory.readbyte(pointer + waterEncAddrOffset[game])
	end
	maxstepcounter = 8 - lshift(curencrate,8) / 2560

	encrate = curencrate
	if encrate_mode > 1 then
		encrate = 5 * encrate_mode
	end

	-- CURMOVEMENT_MODE -> 1 = WALK, 2 = SWIM, 3 = BIKE, 4 = RUN HGSS ONLY --

	-- 1 = walk, 6 = swim, 3 = bike
	curmovement_mode = memory.readdword(pointer + curmovementmodeAddrOffset[game])
	-- Since I store mode on array [walk, swim, bike], I convert mode 6 (swim) to 2
	if curmovement_mode == 6 then
		curmovement_mode = 2
	elseif curmovement_mode ~= 3 then
		curmovement_mode = 1 -- just to avoid lua crashing
	end
	running_check = memory.readword(pointer + curlandmodeAddrOffset[game] + 0x4A)
	if running_check == 9 and curmovement_mode == 1 then
		curmovement_mode = 4
	end

	-- CALCULATE ENCOUNTER RATE --

	if is_hgss == 1 then
		movement_rate = 0x14
		if (movement_mode == 1 and curmovement_mode == 3) or movement_mode == 4 then
			movement_rate = 0x46
		elseif (movement_mode == 1 and curmovement_mode == 4) or movement_mode == 5 then
			movement_rate = 0x28
		end
	else
		movement_rate = 40
		if (movement_mode == 1 and curmovement_mode == 3) or movement_mode == 4 then --bike
			movement_rate = 70 -- bike enc rate
		end
	end

	-- PRINT --

	if bottommenu_mode ~= 5 then
		if menuvisible == 0 then
			gui.box(0,hitboxheight-5,12,0,"#00FF00B0")
			gui.text(3,hitboxheight-3, "S\nH\nO\nW\n", "#88FF88B0")
		else
			gui.box(0,hitboxheight,256,0,"#000000B0")
			gui.box(0,hitboxheight-5,12,0,"#FF0000B0")
			gui.text(3,hitboxheight-3, "H\nI\nD\nE\n", "#FF8888B0")
			gui.box(land_modehitbox[1]+hitboxstart,hitboxheight,land_modehitbox[4]+hitboxstart,hitboxheight+10,"#FF0000B0", "#00000000")
			gui.box(movement_modehitbox[1]+hitboxstart,hitboxheight+10,movement_modehitbox[6]+hitboxstart,hitboxheight+20,"#FF0000B0", "#00000000")
			gui.box(encrate_modehitbox[1]+hitboxstart,hitboxheight+20,encrate_modehitbox[7]+hitboxstart,hitboxheight+30,"#FF0000B0", "#00000000")
			gui.box(land_modehitbox[land_mode]+hitboxstart,hitboxheight,land_modehitbox[land_mode+1]+hitboxstart,hitboxheight+10,"#0000FFFF", "#00000000")
			gui.box(movement_modehitbox[movement_mode]+hitboxstart,hitboxheight+10,movement_modehitbox[movement_mode+1]+hitboxstart,hitboxheight+20,"#0000FFFF", "#00000000")
			gui.box(encrate_modehitbox[encrate_mode]+hitboxstart,hitboxheight+20,encrate_modehitbox[encrate_mode+1]+hitboxstart,hitboxheight+30,"#0000FFFF", "#00000000")
			gui.text(15, hitboxheight+2, "LandType: Auto(" .. landstr[curland_mode] .. ") Grass Water","#FFFFFFB0")
			gui.text(15, hitboxheight+12, "Movement: Auto(" .. movement_str[curmovement_mode] .. ") Walk Swim Bike Run","#FFFFFFB0")
			if curencrate < 10 then
				gui.text(15, hitboxheight+22, "Enc.rate: Auto( " .. curencrate .. ") 10 15 20 25 30","#FFFFFFB0")
			else
				gui.text(15, hitboxheight+22, "Enc.rate: Auto(" .. curencrate .. ") 10 15 20 25 30","#FFFFFFB0")
			end
		end
	end
end

function UpdateTab()
	tabl = input.get()
	if tabl["B"] and not prev["B"] then
		berryModeId = berryModeId + 1
		if berryModeId > 3 then
			berryModeId = 1
		end
	end
	if tabl["1"] and not prev["1"] then
		cur=memory.readdword(RNGAddr[game])
		cur=mult32(cur,0XEEB9EB65) + 0XA3561A1
		memory.writedword(RNGAddr[game], bit.band(cur))
	end
	if tabl["2"] and not prev["2"] then
		cur=memory.readdword(RNGAddr[game])
		cur=mult32(cur,0x41C64E6D) + 0x6073
		memory.writedword(RNGAddr[game], bit.band(cur))
	end
	if tabl["3"] and not prev["3"] then
		if bottommenu_mode == 1 then
			bottommenu_mode = num_menus
		else
			bottommenu_mode = bottommenu_mode - 1
		end
	end
	if tabl["4"] and not prev["4"] then
		if bottommenu_mode == num_menus then
			bottommenu_mode = 1
		else
			bottommenu_mode = bottommenu_mode + 1
		end
	end
	if tabl["5"] and not prev["5"] then
		memory.writedword(RNGAddr[game], bit.band(testingseed_forRNG))
	end
	if tabl["9"] and not prev["9"] then
		for i=1, 16, 1 do --go back 16 times
			cur=memory.readdword(RNGAddr[game])
			cur=mult32(cur,0XEEB9EB65) + 0XA3561A1
			memory.writedword(RNGAddr[game], bit.band(cur))
		end

	end
	if tabl["0"] and not prev["0"] then
		for i=1, 16, 1 do --advance 16 times
			cur=memory.readdword(RNGAddr[game])
			cur=mult32(cur,0x41C64E6D) + 0x6073
			memory.writedword(RNGAddr[game], bit.band(cur))
		end
	end
	if (tabl['leftclick'] and not prev['leftclick']) or (tabl['rightclick'] and not prev['rightclick']) then
		x = tabl['xmouse']
		y = tabl['ymouse']
		if menuvisible == 1 and bottommenu_mode ~= 5 then
			if y >= hitboxheight and y < hitboxheight+10 then
				for i = 1, 3, 1 do
					if x >= land_modehitbox[i]+hitboxstart and x < land_modehitbox[i+1]+hitboxstart then
						land_mode = i
						break
					end
				end
			end
			if y >= hitboxheight+10 and y < hitboxheight+20 then
				for i = 1, 5, 1 do
					if x >= movement_modehitbox[i]+hitboxstart and x < movement_modehitbox[i+1]+hitboxstart then
						movement_mode = i
						break
					end
				end
			end
			if y >= hitboxheight+20 and y < hitboxheight+30 then
				for i = 1, 6, 1 do
					if x >= encrate_modehitbox[i]+hitboxstart and x < encrate_modehitbox[i+1]+hitboxstart then
						encrate_mode = i
						break
					end
				end
			end
		end
		if x > 0 and x < 12 and y >= hitboxheight and y < hitboxheight+30 and bottommenu_mode ~= 5 then
			if menuvisible == 1 then
				menuvisible = 0
			else
				menuvisible = 1
			end
		end
		if x > 1 and x < 15 and y > 177 and y < 189 then
			if bottommenu_mode == 1 then
				bottommenu_mode = num_menus
			else
				bottommenu_mode = bottommenu_mode - 1
			end
		end
		if x > 79 and x < 93 and y > 177 and y < 189 then
			if bottommenu_mode == num_menus then
				bottommenu_mode = 1
			else
				bottommenu_mode = bottommenu_mode + 1
			end
		end
	end
	prev=tabl
end

local pokemonname =  {"none", "Bulbasaur", "Ivysaur", "Venusaur", "Charmander", "Charmeleon", "Charizard",
			"Squirtle", "Wartortle", "Blastoise", "Caterpie", "Metapod", "Butterfree",
			"Weedle", "Kakuna", "Beedrill", "Pidgey", "Pidgeotto", "Pidgeot", "Rattata", "Raticate",
			"Spearow", "Fearow", "Ekans", "Arbok", "Pikachu", "Raichu", "Sandshrew", "Sandslash",
			"Nidoran F", "Nidorina", "Nidoqueen", "Nidoran M", "Nidorino", "Nidoking",
			"Clefairy", "Clefable", "Vulpix", "Ninetales", "Jigglypuff", "Wigglytuff",
			"Zubat", "Golbat", "Oddish", "Gloom", "Vileplume", "Paras", "Parasect", "Venonat", "Venomoth",
			"Diglett", "Dugtrio", "Meowth", "Persian", "Psyduck", "Golduck", "Mankey", "Primeape",
			"Growlithe", "Arcanine", "Poliwag", "Poliwhirl", "Poliwrath", "Abra", "Kadabra", "Alakazam",
			"Machop", "Machoke", "Machamp", "Bellsprout", "Weepinbell", "Victreebel", "Tentacool", "Tentacruel",
			"Geodude", "Graveler", "Golem", "Ponyta", "Rapidash", "Slowpoke", "Slowbro",
			"Magnemite", "Magneton", "Farfetch'd", "Doduo", "Dodrio", "Seel", "Dewgong", "Grimer", "Muk",
			"Shellder", "Cloyster", "Gastly", "Haunter", "Gengar", "Onix", "Drowzee", "Hypno",
			"Krabby", "Kingler", "Voltorb", "Electrode", "Exeggcute", "Exeggutor", "Cubone", "Marowak",
			"Hitmonlee", "Hitmonchan", "Lickitung", "Koffing", "Weezing", "Rhyhorn", "Rhydon", "Chansey",
			"Tangela", "Kangaskhan", "Horsea", "Seadra", "Goldeen", "Seaking", "Staryu", "Starmie",
			"Mr. Mime", "Scyther", "Jynx", "Electabuzz", "Magmar", "Pinsir", "Tauros", "Magikarp", "Gyarados",
			"Lapras", "Ditto", "Eevee", "Vaporeon", "Jolteon", "Flareon", "Porygon", "Omanyte", "Omastar",
			"Kabuto", "Kabutops", "Aerodactyl", "Snorlax", "Articuno", "Zapdos", "Moltres",
			"Dratini", "Dragonair", "Dragonite", "Mewtwo", "Mew",
			"Chikorita", "Bayleef", "Meganium", "Cyndaquil", "Quilava", "Typhlosion",
			"Totodile", "Croconaw", "Feraligatr", "Sentret", "Furret", "Hoothoot", "Noctowl",
			"Ledyba", "Ledian", "Spinarak", "Ariados", "Crobat", "Chinchou", "Lanturn", "Pichu", "Cleffa",
			"Igglybuff", "Togepi", "Togetic", "Natu", "Xatu", "Mareep", "Flaaffy", "Ampharos", "Bellossom",
			"Marill", "Azumarill", "Sudowoodo", "Politoed", "Hoppip", "Skiploom", "Jumpluff", "Aipom",
			"Sunkern", "Sunflora", "Yanma", "Wooper", "Quagsire", "Espeon", "Umbreon", "Murkrow", "Slowking",
			"Misdreavus", "Unown", "Wobbuffet", "Girafarig", "Pineco", "Forretress", "Dunsparce", "Gligar",
			"Steelix", "Snubbull", "Granbull", "Qwilfish", "Scizor", "Shuckle", "Heracross", "Sneasel",
			"Teddiursa", "Ursaring", "Slugma", "Magcargo", "Swinub", "Piloswine", "Corsola", "Remoraid", "Octillery",
			"Delibird", "Mantine", "Skarmory", "Houndour", "Houndoom", "Kingdra", "Phanpy", "Donphan",
			"Porygon2", "Stantler", "Smeargle", "Tyrogue", "Hitmontop", "Smoochum", "Elekid", "Magby", "Miltank",
			"Blissey", "Raikou", "Entei", "Suicune", "Larvitar", "Pupitar", "Tyranitar", "Lugia", "Ho-Oh", "Celebi",
			"Treecko", "Grovyle", "Sceptile", "Torchic", "Combusken", "Blaziken", "Mudkip", "Marshtomp",
			"Swampert", "Poochyena", "Mightyena", "Zigzagoon", "Linoone", "Wurmple", "Silcoon", "Beautifly",
			"Cascoon", "Dustox", "Lotad", "Lombre", "Ludicolo", "Seedot", "Nuzleaf", "Shiftry",
			"Taillow", "Swellow", "Wingull", "Pelipper", "Ralts", "Kirlia", "Gardevoir", "Surskit",
			"Masquerain", "Shroomish", "Breloom", "Slakoth", "Vigoroth", "Slaking", "Nincada", "Ninjask",
			"Shedinja", "Whismur", "Loudred", "Exploud", "Makuhita", "Hariyama", "Azurill", "Nosepass",
			"Skitty", "Delcatty", "Sableye", "Mawile", "Aron", "Lairon", "Aggron", "Meditite", "Medicham",
			"Electrike", "Manectric", "Plusle", "Minun", "Volbeat", "Illumise", "Roselia", "Gulpin",
			"Swalot", "Carvanha", "Sharpedo", "Wailmer", "Wailord", "Numel", "Camerupt", "Torkoal",
			"Spoink", "Grumpig", "Spinda", "Trapinch", "Vibrava", "Flygon", "Cacnea", "Cacturne", "Swablu",
			"Altaria", "Zangoose", "Seviper", "Lunatone", "Solrock", "Barboach", "Whiscash", "Corphish",
			"Crawdaunt", "Baltoy", "Claydol", "Lileep", "Cradily", "Anorith", "Armaldo", "Feebas",
			"Milotic", "Castform", "Kecleon", "Shuppet", "Banette", "Duskull", "Dusclops", "Tropius",
			"Chimecho", "Absol", "Wynaut", "Snorunt", "Glalie", "Spheal", "Sealeo", "Walrein", "Clamperl",
			"Huntail", "Gorebyss", "Relicanth", "Luvdisc", "Bagon", "Shelgon", "Salamence", "Beldum",
			"Metang", "Metagross", "Regirock", "Regice", "Registeel", "Latias", "Latios", "Kyogre",
			"Groudon", "Rayquaza", "Jirachi", "Deoxys",
			"Turtwig", "Grotle", "Torterra", "Chimchar", "Monferno", "Infernape", "Piplup", "Prinplup",
			"Empoleon", "Starly", "Staravia", "Staraptor", "Bidoof", "Bibarel", "Kricketot", "Kricketune",
			"Shinx", "Luxio", "Luxray", "Budew", "Roserade", "Cranidos", "Rampardos", "Shieldon", "Bastiodon",
			"Burmy", "Wormadam", "Mothim", "Combee", "Vespiquen", "Pachirisu", "Buizel", "Floatzel", "Cherubi",
			"Cherrim", "Shellos", "Gastrodon", "Ambipom", "Drifloon", "Drifblim", "Buneary", "Lopunny",
			"Mismagius", "Honchkrow", "Glameow", "Purugly", "Chingling", "Stunky", "Skuntank", "Bronzor",
			"Bronzong", "Bonsly", "Mime Jr.", "Happiny", "Chatot", "Spiritomb", "Gible", "Gabite", "Garchomp",
			"Munchlax", "Riolu", "Lucario", "Hippopotas", "Hippowdon", "Skorupi", "Drapion", "Croagunk",
			"Toxicroak", "Carnivine", "Finneon", "Lumineon", "Mantyke", "Snover", "Abomasnow", "Weavile",
			"Magnezone", "Lickilicky", "Rhyperior", "Tangrowth", "Electivire", "Magmortar", "Togekiss",
			"Yanmega", "Leafeon", "Glaceon", "Gliscor", "Mamoswine", "Porygon-Z", "Gallade", "Probopass",
			"Dusknoir", "Froslass", "Rotom", "Uxie", "Mesprit", "Azelf", "Dialga", "Palkia", "Heatran",
			"Regigigas", "Giratina", "Cresselia", "Phione", "Manaphy", "Darkrai", "Shaymin", "Arceus",
}
nature = {"Hardy","Lonely","Brave","Adamant","Naughty",
			"Bold","Docile","Relaxed","Impish","Lax",
			"Timid","Hasty","Serious","Jolly","Naive",
			"Modest","Mild","Quiet","Bashful","Rash",
			"Calm","Gentle","Sassy","Careful","Quirky"}

function MethodJK(initialrng, a)
	frame = getSeedDistance(initialrng)
	rng2 = initialrng
	rng = rngAdvance(initialrng)
	if is_hgss == 1 then
		slot = gettop(rng2) % 100
	else
		slot = math.floor(gettop(rng2) / 656)
	end
	pkmstr = ""
	lvlnum = 0
	if land == 1 then --(Grass)
		if (slot < 20) then slot = 0
		elseif (slot < 40) then slot = 1
		elseif (slot < 50) then slot = 2
		elseif (slot < 60) then slot = 3
		elseif (slot < 70) then slot = 4
		elseif (slot < 80) then slot = 5
		elseif (slot < 85) then slot = 6
		elseif (slot < 90) then slot = 7
		elseif (slot < 94) then slot = 8
		elseif (slot < 98) then slot = 9
		elseif (slot == 98) then slot = 10
		else slot = 11
		end
		pkmstr = pokemonname[encslots_pkm[slot+1]+1]
		lvlnum = encslots_lvl[slot+1]
	else -- land == 2 (Water)
		if (slot < 60) then slot = 0
		elseif (slot < 90) then slot = 1
		elseif (slot < 95) then slot = 2
		elseif (slot < 99) then slot = 3
		else slot = 4
		end
		pkmstr = pokemonname[waterslots_pkm[slot+1]+1]
		lvlnum = gettop(rng) % (waterslots_maxlvl[slot+1] - waterslots_minlvl[slot+1] + 1) + waterslots_minlvl[slot+1]
		rng = rngAdvance(rng)
		frame = frame + 1
	end
	if is_hgss == 1 then
		mynat = gettop(rng) % 25
	else
		mynat = math.floor(gettop(rng) / 0xA3E)
	end
	loop = 0
	while (true) do
		rng2 = rngAdvance(rng)
		rng = rngAdvance(rng2)
		pid = gettop(rng)*65536 + gettop(rng2)
		if (pid % 25 == mynat) then break end
	end
	rng = rngAdvance(rng)
	IV = gettop(rng)
	rng = rngAdvance(rng)
	IV2 = gettop(rng)
	gui.text(112,a, "F:".. frame ..
		", " .. pkmstr .. " L." .. lvlnum, "#FFFFFF80")
	gui.text(112,a+10, "IV: [".. IV%32 .. "," .. math.floor(IV/32)%32 .. ","
		.. math.floor(IV/1024)%32 .. "," .. math.floor(IV2/32)%32 .. ","
		.. math.floor(IV2/1024)%32 .. "," .. IV2%32 .. "]", "#FFFFFF80")
	gui.text(112,a+20, "Nat: " .. nature[mynat+1], "#FFFFFF80")
end

function fn()
	gameIDAddr = memory.readdword(0x23FFE0C)
	is_hgss = 0

	if gameIDAddr == 0x45415041 then
		game = 1
		gamename = "Pearl (U)"
	elseif gameIDAddr == 0x45414441 then
		game = 1
		gamename = "Diamond (U)"
	elseif gameIDAddr == 0x45555043 then
		game = 2
		gamename = "Platinum (U)"
	elseif gameIDAddr == 0x454B5049 then
		game = 3
		gamename = "HeartGold (U)"
		is_hgss = 1
	elseif gameIDAddr == 0x45475049 then
		game = 3
		gamename = "SoulSilver (U)"
		is_hgss = 1
	else
		game = -1
		gamename = "Invalid game"
	end

	gui.box(0,-192,256,-181,"#00000080")
	gui.box(0,0,256,192,"#000000A0")
	gui.text(0,-190,"Game: " .. gamename,"#FFFFFFB0")
	gui.text(170,-190,"Seed: " .. bit.tohex(testingseed_forRNG),"#FFFFFFB0")
	if game == -1 then
		return
	end

	pointer = memory.readdword(pointerAddr[game])
	stepcounter = memory.readbyte(pointer + stepcounterAddrOffset[game])
	stepcnt128 = memory.readbyte(pointer + stepcnt128AddrOffset[game])

	UpdateTab()
	ModeHandler()

	currentRNG = memory.readdword(RNGAddr[game])
	nextRNG = rngAdvance(currentRNG)

	berries(berryModeId)
	berryMod = (nextRNG/65536)%berryMode[berryModeId]
	berryMod = math.floor(berryMod)
	berryGift = berryList[berryMod+1]

	test = lastRNG
	if currentEmuFrameCount ~= emu.framecount() then
		currentEmuFrameCount = emu.framecount()
		for i = 0, 150, 1 do
			if bit.tohex(currentRNG)==bit.tohex(test) then
				distlast = i
				break
			elseif i >= 150 then
				distlast = ">150"
				break
			end
			test=rngAdvance(test)
		end
	end

	distanceseed = getSeedDistance(currentRNG)
	hour = memory.readdword(clockAddr[game])
	oppDirCount = 0
	if bottommenu_mode ~= 5 then
		gui.text(0,83,"Curr RNG: "..bit.tohex(currentRNG), "#FFFF00A0")
		gui.text(0,93,"Next RNG: "..bit.tohex(nextRNG), "#FFFF00A0")
		if is_hgss == 1 then
			gui.text(0,103, "Dist seed: " .. distanceseed, "#FFFF00A0")
			gui.text(0,113, "Step Cnt (128): " .. stepcnt128, "#FFFF00A0")
			oppDirCount = memory.readword(pointer + oppDirCountOffset[game])
			gui.text(0,123, "Opp dir count: " .. oppDirCount, "#FFFF00A0")
			gui.text(0,133, "Step Cnt(area): " .. stepcounter, "#FFFF00A0")
		else
			gui.text(0,103,"Dist last: "..distlast, "#FFFF00A0")
			gui.text(0,113,"Dist seed: " .. distanceseed, "#FFFF00A0")
			gui.text(0,123, "Step Cnt (128): ".. stepcnt128, "#FFFF00A0")
			gui.text(0,133, "Enc. Rate Cnt: ".. stepcounter .. "/".. maxstepcounter, "#FFFF00A0")
		end
		gui.text(0,143, "Clock: "
			.. hour .. ":"
			.. memory.readdword(clockAddr[game]+4) .. ":"
			.. memory.readdword(clockAddr[game]+8)
		, "#FFFF00A0")
		gui.text(0,153, "IGT: "
			.. memory.readbyte(pointer + IGTAddrOffset[game]) .. ":"
			.. memory.readbyte(pointer + IGTAddrOffset[game]+2) .. ":"
			.. memory.readbyte(pointer + IGTAddrOffset[game]+3)
		, "#FFFF00A0")
		gui.text(0,163, "Framecount: " .. gameframecount, "#FFFF00A0")
		gui.text(0,173, "Lag: " .. lagcount, "#FFFF00A0")
	else
		gui.text(0,58, "Dist: " .. distanceseed, "#FFFF0080")
	end

	-- Enc Slots
	if bottommenu_mode == 2 or bottommenu_mode == 3 then
		fillEncSlots()
	end

	-- NPC
	if bottommenu_mode == 6 then
	    gui.box(133,3,253,123,"#00000080","#FFFFFFFF")
		num_npc = memory.readdword(pointer + objCountOffset[game])
		num_rednpc = 0
		if (num_npc > 50) then
			num_npc = 0
		end
		myxpos = 0
		myypos = 0
		for i = 0, num_npc-1, 1 do
			xpos = memory.readdword(pointer + objDataOffset[game] + 0x44 + objDataSize[game]*i)
			ypos = memory.readdword(pointer + objDataOffset[game] + 0x4C + objDataSize[game]*i)
			zpos = memory.readdword(pointer + objDataOffset[game] + 0x48 + objDataSize[game]*i)
			if i == 0 then
				myxpos = xpos
				myypos = ypos
				myzpos = zpos
			else
				objtype = memory.readdword(pointer + objDataOffset[game] + objDataSize[game]*i)
				if objtype > 0 then
					npcdraw(xpos*3-myxpos*3,ypos*3-myypos*3, "#FF0000FF",1)
					num_rednpc = num_rednpc + 1
				else
					npcdraw(xpos*3-myxpos*3,ypos*3-myypos*3, "#AAAAAAFF",1)
				end
			end
		end
		npcdraw(0,0,"#FFFF00FF",1)
		gui.text(140,128, "Total objects: "  ..  num_npc)
		gui.box(183-2,143-2,183+2,143+2,"#AAAAAAFF","#AAAAAAFF")
		gui.text(190,140,num_npc - num_rednpc - 1, "#AAAAAAFF")
		gui.box(183-2,153-2,183+2,153+2,"#FF0000FF","#FF0000FF")
		gui.text(190,150,num_rednpc,"#FF0000FF")
	end

	-- Point Grid
	test = currentRNG
	lastRNG = currentRNG

	futureencs = {}
	futureencs_n = 0

	if bottommenu_mode ~= 5 then
		gui.box(3,3,103,79,"#AAAAAAA0", "white")
	else
		gui.box(3,3,69,53,"#AAAAAAA0", "white")
	end

	for i = 0, 11, 1 do
		for j = 0, 15, 1 do
			clr = "#000000FF" -- init square color to black
			randvalue = gettop(test)
			randvalue2 = randvalue
			if is_hgss == 1 then
				if math.floor(randvalue % 100) < getHGSSEncRate(movement_rate, oppDirCount) then
					clr = "#666666FF"
					test2=mult32(test,0x41C64E6D) + 0x6073
					randvalue=gettop(test2)
					if math.floor(randvalue % 100) < encrate then
						clr = "#FF0000FF"
						if futureencs_n < 10 then
							futureencs[futureencs_n] = rngAdvance(test2)
							futureencs_n = futureencs_n + 1
						end
					end
				end
			else
				test2 = test
				if (stepcounter >= maxstepcounter) or (encrate_mode > 1) or (randvalue / 0x290 < 5) then
					if (stepcounter < maxstepcounter and encrate_mode == 1) then
						clr = "#666666FF"
						test2=rngAdvance(test2)
						randvalue=gettop(test2)
					end
					if (randvalue / 0x290 < movement_rate) then
						clr = "#666666FF"
						test2=rngAdvance(test2)
						randvalue=gettop(test2)
						if (randvalue / 0x290 < encrate) then
							test2 = rngAdvance(test2)
							clr = "#FF0000FF"
							if futureencs_n < 10 then
								futureencs[futureencs_n] = rngAdvance(test2)
								futureencs_n = futureencs_n + 1
							end
						end
					end
				end
			end
			if bottommenu_mode == 4 and math.floor(randvalue2%100) < 25 then
				clr = "yellow" --Pillar Room
			end
			if bottommenu_mode ~= 5 then
				drawsquare(6+6*j,6+6*i, clr,4)
			else
			    drawsquare(5+4*j,5+4*i, clr,2)
			end
			test=rngAdvance(test)
		end
	end

	gui.box(2,177,93,189,"#00000080","#FFFFFFFF")
	drawarrowleft(5,180,"#FFFFFFFF")
	gui.text(20,180, bottommenu_str[bottommenu_mode], "#FFFFFFFF")
	drawarrowright(90,180,"#FFFFFFFF")

	if bottommenu_mode == 2 then
		for i = 0, futureencs_n-1, 1 do
			MethodJK(futureencs[i],-170 + 35*i)
		end
	elseif bottommenu_mode == 3 then
		gui.text(115,5, "Encounter slots (" .. landstr[land] .. ")", "#00FF00FF")
		if land == 1 then -- (Grass)
			for i = 1, 12, 1 do
				gui.text(115, (i+1)*10, i-1 .. " - " .. pokemonname[encslots_pkm[i]+1] .. " L." .. encslots_lvl[i])
			end
		else --land == 2 (Water)
			for i = 1, 5, 1 do
				gui.text(115, (i+1)*10, i-1 .. " - " .. pokemonname[waterslots_pkm[i]+1] .. " L." .. waterslots_minlvl[i] .. "-" .. waterslots_maxlvl[i])
			end
		end
	elseif bottommenu_mode == 4 then
		gui.text(115,5, "Misc. Data", "#00FF00FF")
		gui.text(115,20, "Trainer ID: " .. memory.readword(pointer + TIDAddrOffset[game]))
		gui.text(115,30, "Secret  ID: " .. memory.readword(pointer + TIDAddrOffset[game]+2))
		gui.text(115,40, "Lottery ID: " .. memory.readword(pointer + LIDAddrOffset[game]))
		if is_hgss ~= 1 then
			gui.text(115,50, berryGift.." Berry ("..berryMap[berryModeId]..")", "red")
			gui.text(115,60, "Giratina Pillar Room", "yellow")
		end
		if is_hgss == 1 then
			gui.text(115,55, "Second RNG index: " .. memory.readword(0x0210F6CC))
			gui.text(115,65, "Raikou Location: " .. memory.readdword(pointer + 0x138A4))
		end
	end
end

function fm()
	gameframecountold = gameframecount
	gameframecount = memory.readdword(framecountAddr[game])
	if (gameframecount == gameframecountold) then
		lagcount = lagcount + 1
	end
end

gui.register(fn)
emu.registerafter(fm)
