---------------------------------------------
---- RSFD - Routing Script For Dummies ------
---------------------------------------------

---------------------------------------------
--Original versions 'void.lua' and 'loadline.lua' created by MKdasher, 
--Game version and Basepointer setup by Ganix
--Additional features (NPC,Item,Warps...) by RETIRE
--Modified to work for all languages of DPPt and HGSS by RETIRE

--NOTE: don't enable infinite repel until actually in game, will reset the game if you select savefile with it active.
---------------------------------------------
jump = 31 --teleportamount by default 
modoption = 15
tilename = {"nothing","nothing","Grass","Grass","4","5","6","7","Cave","9","10", "HauntH","CaveW","13","14","15",
			"Pond","Water","Water","WaterF","Water","Water","Puddle","ShallW","24","Water","26","27","28","29","30","31",
			"ice","Sand","Water","35","Grass?","37","38","39","40","41","Water","43","44","45","46","47",
			"Chair","Chair","50","51","52","53","54","55","LedgeR","LedgeL","LedgeU","LedgeD","60","61","62","63",
			"SpinR","SpinL","SpinU","SpinD","68","69","70","71","72","Stair","74","RockCVert","RockCHor","77","78","79",
			"Water","Water","Water","Water","84","85","HightM","HightM","HightM","HightM","90","91","92","93","Warp","Warp",
			"Warp","Warp","Doormat","Doormat","Doormat","Doormat","Warp","Warp","Warp","Warp","Warp","Warp","Warp","Warp","Warp","Warp",
			"StartBr","BridgeNul","BridgeCave","BridgeWat","Bridge?","BridgeSn","BikeBr","BikeBr?","BikeBr","BikeBr","BikeBr","BBridgeEnc","BikeBr?","BikeBr","126","127",
			"Counter","129","130","PC","132","Map","Television","135","Bookcases","137","138","139","140","141","Book","143",
			"144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159",
			"Soil","SnowSp2","SnowSp1","SnowSp0","Mud","MudBlock","MudGr","MudGrBlock","Snow","MeltSnow","170","171","172","173","174","175",
			"176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191",
			"192","193","194","195","196","197","198","199","200","201","202","203","204","205","206","207",
			"208","209","210","211","212","213","214","BikeLR","BikeLL","SlopeTop","SlopeBot","bikeStall","220","221","222","223",
			"Bookcases","Bookcases","Bookcases","227","ThrashBin","Obj","230","231","232","233","234","235","236","237","238","239",
			"240","241","242","243","244","245","246","247","248","249","250","251","252","253","254","Void"
			}
			
			
			local mapId = {
	Highlight = {
		color = '#f7bbf3',
		number = {212}
	},
	Highlight2= {
		color = '#F8540',
		number = {210,211,347}--228,235,236,242
	},
	MysteryZone = {
		color = '#88888866',
		number = {0}
	},
	Blackout = {
		color = 'orange',
		number = {332, 333}
	},
	Movement = {
		color = 'purple',
		number = {117, 177, 179, 181, 183, 192, 393,
            474, 475, 476, 477, 478, 479, 480, 481, 482, 483,
            484, 485, 486, 487, 488, 489, 490, 496}
	},
	VoidExit = {
		color = 'yellow',
		number = {105, 114, 337, 461, 516,186,187}
	},
	BSOD_DANGER = {
		color = 'red',
		number = {35, 88, 91, 93, 95, 115, 122, 150,154,155,156, 176, 178, 180, 182, 184, 185, 188}
	},
	Wrongwarp = {
		color = '#666fd',
		number = {7,37,49,70,102,124,135,152,169,174,190,421,429,436,444,453,460,495}
	},
	Jubilife = {
		color = '#66ffbbff',
		number = {3}
	},
	Normal = {
		color = '#00bb00ff',
		number = {}
	}
}

local CollisionId = {
    Custom = {
        color = '#f7bbf3',
        number = {}
    },
    Grass = {
        color = '#2ac615',
        number = {0x2}
    },
    TallGrass = {
        color = '#2aa615',
        number = {0x3}		
	},
    Cave = {
        color = '#9F80',
        number = {0x8}
	},
    HauntedHouse = {
        color = '#A292BC',
        number = {0xB}
    },
    Water = {
        color = '#238cdc',
        number = {0x10,0x13,0x15,0x16,0x17}
    },
    Ice = {
        color = '#56b3e0',
        number = {0x20,0x20}
    },
    Sand = {
        color = 'yellow',
        number = {0x21,0x21}
	},
    Ledge = {
        color = '#D3A',
        number = {0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F}
    },
    RockClimb = {
        color = '#C76',
        number = {0x4B,0x4C}
    },
    Bridge = {
        color = '#C79',
        number = {0x70,0x71,0x72,0x73,0x74,0x75,}
	},
    BridgeBike = {
        color = '#C7A55',
        number = {0x76,0x77,0x78,0x79,0x7A,0x7B,0x7C,0x7D}
	},
    Berrysoil = {
        color = '#b2703',
        number = {0xA0}
    },
    SnowSlow = {
        color = '#8da9cb',
        number = {0xA1}
    },
    Snow2xSlow = {
        color = '#6483a7',
        number = {0xA2}
    },
    Snow3xslow = {
        color = '#52749d',
        number = {0xA3}
	},
    Mud = {
        color = '#92897',
        number = {0xA4}
    },
    StuckMud = {
        color = '#92704',
        number = {0xA5}
    },
    GrassMud = {
        color = '#4090',
        number = {0xA6}
    },
    GrassMudStuck = {
        color = '#55906',
        number = {0xA7}
	},
    Snow = {
        color = '#b9d0eb',
        number = {0xA8}
	},
    BikeRamp = {
        color = '#B890',
        number = {0xD7,0xD8}
	},
    Quicksand = {
        color = '#A880',
        number = {0xD9,0xDA}
    },
    Normal = {
        color = '#88888866',
        number = {}
    }
}
------------------------
DebugOffs = 0x0
ver = memory.readdword(0x023FFE0C)
if ver == 0 then
	ver = memory.readdword(0x027FFE0C)
end
id = bit.band(ver, 0xFF)
lang = bit.band(bit.rshift(ver, 24), 0xFF)
base_addr = 0

if id == 0x59 then                                     -- Pokemon D/P Demo
	if     lang == 0x45 then base_addr = 0x02106BAC    -- US / EU
	OffsArray = {0x1454,0x24AA4,0x23CC4,0x24BC0,0x248F0,
				0x75F4,0x23CBC,0x23CB8,0x22ADA,0x3E924,
				0x1384,0x57708}	
	AddrArray = {0x2056C06, 0x223C1F4}
	LanguageArray = {0x102}
	end
end

if id == 0x41 then										-- Pokemon D/P
	OffsArray = {0x1454,0x24AA4,0x23CC4,0x24BC0,0x248F0,
				0x75F4,0x23CBC,0x23CB8,0x22ADA,0x3E924,
				0x1384,0x57708,0x229F0}	
	AddrArray = {0x2056C06, 0x223C1F4} 
	LanguageArray = {0x00}
	
	if     lang == 0x44 then base_addr = 0x02107100    -- DE
	LanguageArray = {0x70}
	elseif lang == 0x45 then base_addr = 0x02106FC0    -- US / EU
	elseif lang == 0x46 then base_addr = 0x02107140    -- FR
	LanguageArray = {0x70}
	elseif lang == 0x49 then base_addr = 0x021070A0    -- IT
	LanguageArray = {0x70}
	elseif lang == 0x4A then 
	
	if memory.readword(0x23FFE2C) == 0xB8 then base_addr = 0x211F988 --Pokemon DP Debug
	DebugOffs = 0x4000
	else base_addr = 0x02108818   -- JP
	LanguageArray = {0x27DA}
	end 
	
	elseif lang == 0x4B then base_addr = 0x021045C0    -- KS
	elseif lang == 0x53 then base_addr = 0x02107160    -- ES
	LanguageArray = {0x70}
	end

	elseif id == 0x43 then 							 	-- Pokemon Pt
	OffsArray = {0x129C,0x238EC,0x22AE8,0x23A08,0x23738,
				0x8087,0x22AE0,0x22ADC,0x218FE,0x3D734,
				0x1198}
	AddrArray = {0x2060C20,0x224a75c} 
	LanguageArray = {0x00}
	if     lang == 0x44 then base_addr = 0x02101EE0    -- DE
	LanguageArray = {0xA4}
	elseif lang == 0x45 then base_addr = 0x02101D40    -- US / EU
	elseif lang == 0x46 then base_addr = 0x02101F20    -- FR
	LanguageArray = {0xA4}
	elseif lang == 0x49 then base_addr = 0x02101EA0    -- IT
	LanguageArray = {0xA4}
	elseif lang == 0x4A then base_addr = 0x02101140    -- JP
	LanguageArray = {-0x738}
	elseif lang == 0x4B then base_addr = 0x02102C40    -- KS
	elseif lang == 0x53 then base_addr = 0x02101F40    -- ES
	LanguageArray = {0xA4}
	end

elseif id == 0x49 then									-- Pokemon HG/SS CFe0
	OffsArray = {0x124C,0x25DF0,0x25158,0x2603C,0x25C3C,
				0x6919,0x25150,0x2514C,0x24166,0x3FF30,
				0x0}
	AddrArray = {0x205DAA2,} 
	LanguageArray = {0x00}
	if     lang == 0x44 then base_addr = 0x02111860    -- DE
	elseif lang == 0x45 then base_addr = 0x02111880    -- US / EU
	elseif lang == 0x46 then base_addr = 0x021118A0    -- FR
	elseif lang == 0x49 then base_addr = 0x02111820    -- IT
	elseif lang == 0x4A then base_addr = 0x02110DC0    -- JP
	elseif lang == 0x4B then base_addr = 0x02112280    -- KS
	elseif lang == 0x53 then base_addr = 0x021118C0    -- ES
	end
end 

local base = memory.readdword(base_addr) 
local cursor = 1
local fasttoggle = true

if id == 0x41 or id == 0x43 then 
customwarpid = 510 --id of map to fly to when selecting 'FlyOptionId' 
				   --set to '3' for overworld.
customwarpx = 32
customwarpy = 34
FlyOptionId = 0x41 -- location that you want to fly to to activate warp. (default = Eterna, 0x41)

elseif id == 0x49 then
customwarpid = 2 --id of map to fly to when selecting 'FlyOptionId'
				   --set to '20' for overworld.
customwarpx = 10
customwarpy = 10 
FlyOptionId = 0x3C -- location that you want to fly to to activate warp.(default = New Bark, 0x3C)
end 


local mapAddrOffset = OffsArray[9]

local map_box
local menu_box
local mapcontrol_box

local mode = 1
local mode_str = {
	"BottomScr",
	"TopScreen",
}
local max_cols = 0
local max_rows = 0

local map = {}

local x_position = 0
local y_position = 0

local map_centered = true
local menu1_opened = false
local menu2_opened = false
local x_paint = 0
local y_paint = 0

local tabl={}
local prev={}
------------------------------------------
local LiveMapIdOffs = OffsArray[1] - 0x8
local curptrmap = base + LiveMapIdOffs

local XPositionAddrOffset = OffsArray[1] 
local YPositionAddrOffset = OffsArray[1] + 0x4

local teleportX = OffsArray[2] -0xC 
local teleportXmov = OffsArray[2] +0x2
local teleportY = OffsArray[2] -0x4
local teleportYmov = OffsArray[2] + 0xA

local movementXAddrOffset = OffsArray[2] 
local movementYAddrOffset = OffsArray[2] + 0x8

local stepamountAddr = OffsArray[11]

local XPos = {0,0,0,0,0,0}
local YPos = {0,0,0,0,0,0}
local movementX = {0,0,0,0,0,0}
local movementY = {0,0,0,0,0,0}

local bnd,br,bxr=bit.band,bit.bor,bit.bxor
local rshift, lshift=bit.rshift, bit.lshift

local Loadlines_view = false
local Grid_view = false
local CustomWarp = false
local Map = true
local InfRepel = false
local Trigger = false 
local NPC = false
local Item = false
local Warp = false
local WTW = false

local PerfectCatch= false
local teleport1 = true 
local mapediting = false
local demostop = true
local flycursor = false
local Collision = false 
local chunkediting = false
local collisionediting = false 
local temps8 = false
local temps9 = false
local temps10 = false

local temps11 = false
local temps12 = false
local temps13 = false
local temps14 = false
local temps15 = false

local CustomWarp0 = true 
-------------------------------
characterlist = {"/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/",
				 "/","/","/","/","/","/","/","/","/","/","/","/","0","1","2","3","4","5","6","7",
				 "8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R",
				 "S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l",
				 "m","n","o","p","q","r","s","t","u","v","w","x","y","z","A.","A.","A.","A.","A.","A.",
				 "AE","C.","E.","E.","E.","E.","I.","I.","I.","I.","D.","N.","O.","O.","O.","O.","O.",
				 "X.","O.","U.","U.","e.","i.","i.","i.","i.","a.","a.","a.","a.","a.","a.","ae","c.",
				 "e.","e.","e.","e.","i.","i.","i.","i.","a.","n.","o","o","o","o","o","%","o.","u",
				 "u","u","u","y.","|P","y.","OE","oe","S.","s.","a","o","er","re","r","P.","i.","?","!",
				 "?",",",".","...",".^","/","'","'","''","''",",,","<<",">>","(",")","Mr","Ms","+","-",
				 "*","#","=","~",":",";","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/",
				 "/","/","/","/","/","/","/","/"," ","e^"}
----------------------------------------------
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
function drawarrowdown(a,b,c)
	gui.line(a,b,a-2,b-2,c)
	gui.line(a,b,a+2,b-2,c)
	gui.line(a,b,a,b-6,c)
end
function drawarrowup(a,b,c)
	gui.line(a,b,a-2,b+2,c)
	gui.line(a,b,a+2,b+2,c)
	gui.line(a,b,a,b+6,c)
end
function drawsquare(a,b,c,d)
	gui.box(a,b,a+4,b+4,c,d)
end

function isCoordInBox(x, y, box)
	return (x >= box[1] and x <= box[3] and y >= box[2] and y <= box[4])
end

function updateTab()
	tabl = input.get()
	if tabl['leftclick'] and not prev['leftclick'] or tabl['rightclick']then
	--if tabl['leftclick'] and Fasttogle == false and not prev['leftclick'] then
		x = tabl['xmouse']
		y = tabl['ymouse']
		
		-- Menu Mode --
		if isCoordInBox(x, y, {menu_box[3] - 84, menu_box[2], menu_box[3] - 72, menu_box[4]}) then
			mode = (mode - 2) % 2 + 1
		elseif isCoordInBox(x, y, {menu_box[3] - 12, menu_box[2], menu_box[3], menu_box[4]}) then
			mode = mode % 2 + 1
		end
		
		if tabl['shift'] then 
		moveval = 10
		else 
		moveval = 2
		end
		
		-- Moving Map --
		if not map_centered then
			if isCoordInBox(x, y, {menu_box[1] + 2, menu_box[2] + 28, menu_box[1] + 15, menu_box[2] + 42}) then
				x_paint = x_paint - moveval/2
			elseif isCoordInBox(x, y, {menu_box[1] + 29, menu_box[2] + 28, menu_box[1] + 42, menu_box[2] + 42}) then
				x_paint = x_paint + moveval/2
			elseif isCoordInBox(x, y, {menu_box[1] + 16, menu_box[2] + 15, menu_box[1] + 28, menu_box[2] + 29}) then
				y_paint = y_paint - moveval
			elseif isCoordInBox(x, y, {menu_box[1] + 16, menu_box[2] + 41, menu_box[1] + 28, menu_box[2] + 55}) then
				y_paint = y_paint + moveval
			end
		end
		
		-- Centered --
		if isCoordInBox(x, y, {menu_box[1] + 2, menu_box[2] + 57, 42, menu_box[2] + 69}) then
			map_centered = not map_centered
		end
		
		-- Menu open --
		if isCoordInBox(x, y, {menu_box[1] + 2, menu_box[2] + 178, menu_box[1] + 42, menu_box[2] + 190}) then
			menu1_opened = not menu1_opened
			menu2_opened = false 
		end
		
		if isCoordInBox(x, y, {menu_box[1] + 52, menu_box[2] + 178, menu_box[1] + 92, menu_box[2] + 190}) then
			menu2_opened = not menu2_opened
			menu1_opened = false 
		end
		
		-- Menu--
		if menu1_opened then
			if isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 78, menu_box[1] + 17, menu_box[2] + 90}) then
				Loadlines_view = not Loadlines_view
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 98, menu_box[1] + 17, menu_box[2] + 110}) then
				Grid_view = not Grid_view
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 118, menu_box[1] + 17, menu_box[2] + 130}) then
				CustomWarp = not CustomWarp
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 138, menu_box[1] + 17, menu_box[2] + 150}) then
				Map = not Map
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 158, menu_box[1] + 17, menu_box[2] + 170}) then
				InfRepel = not InfRepel
			-------------------------------------------row2
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 78, menu_box[1] + 97, menu_box[2] + 90}) then
				Trigger = not Trigger
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 98, menu_box[1] + 97, menu_box[2] + 110}) then
				NPC = not NPC
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 118, menu_box[1] + 97, menu_box[2] + 130}) then
				Item = not Item
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 138, menu_box[1] + 97, menu_box[2] + 150}) then
				Warp = not Warp
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 158, menu_box[1] + 97, menu_box[2] + 170}) then
				WTW = not WTW
				
			end
		end
			
		if menu2_opened then
			if isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 78, menu_box[1] + 17, menu_box[2] + 90}) then
				PerfectCatch= not PerfectCatch
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 98, menu_box[1] + 17, menu_box[2] + 110}) then
				teleport1 = not teleport1
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 118, menu_box[1] + 17, menu_box[2] + 130}) then
				mapediting = not mapediting
				teleport1 = false 
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 138, menu_box[1] + 17, menu_box[2] + 150}) then
				demostop = not demostop
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 158, menu_box[1] + 17, menu_box[2] + 170}) then
				flycursor = not flycursor
			-------------------------------------------row2
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 78, menu_box[1] + 97, menu_box[2] + 90}) then
				Collision = not Collision
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 98, menu_box[1] + 97, menu_box[2] + 110}) then
				chunkediting = not chunkediting
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 118, menu_box[1] + 97, menu_box[2] + 130}) then
				temps8 = not temps8
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 138, menu_box[1] + 97, menu_box[2] + 150}) then
				temps9 = not temps9
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 158, menu_box[1] + 97, menu_box[2] + 170}) then
				temps10 = not temps10
				
			end
		end
	end
	prev = tabl
end

function printTopMenu()
	gui.box(menu_box[1], menu_box[2], menu_box[3], menu_box[4], "#00000090")
	gui.box(menu_box[3] - 12, menu_box[2], menu_box[3], menu_box[4], "#000000CC")
	gui.box(menu_box[3] - 84, menu_box[2], menu_box[3] - 72, menu_box[4], "#000000CC")
	drawarrowleft(menu_box[3] - 81, menu_box[2] + 2, '#FFF282')
	drawarrowright(menu_box[3] - 3, menu_box[2] + 2, '#FFF282')
	gui.text(menu_box[3] - 68, menu_box[2] + 2, mode_str[mode],'white')
end

function printMapControl()
	if map_centered then
	mapclr = '#666666cc'
	mapbclr = "#00006633"
	mapbclr2 = "#00006655"
	
		gui.box(menu_box[1] + 2, menu_box[2] + 57, menu_box[1] + 42, menu_box[2] + 69, "#00006633", "#00006655")
		gui.text(menu_box[1] + 5, menu_box[2] + 60,"CENTER", '#FFF282')
	else
	mapclr = 'yellow'
	mapbclr = "#00000090"
	mapbclr2 = "#00000090"
		
		gui.box(menu_box[1] + 2, menu_box[2] + 57, menu_box[1] + 42, menu_box[2] + 69, "#00000090")
		gui.text(menu_box[1] + 5, menu_box[2] + 60,"MANUAL", "yellow")
	end
		gui.box(menu_box[1] + 2,menu_box[2] + 15, menu_box[1] + 42, menu_box[2] + 55, mapbclr, mapbclr2)
		drawarrowleft(menu_box[1] + 5,menu_box[2] + 32, mapclr)
		drawarrowright(menu_box[1] + 39,menu_box[2] + 32, mapclr)
		drawarrowup(menu_box[1] + 22,menu_box[2] + 19, mapclr)
		drawarrowdown(menu_box[1] + 22,menu_box[2] + 50, mapclr)
end


function printSettingsMenu1()
	if menu1_opened then
		gui.box(menu_box[1] + 2, menu_box[2] + 75, menu_box[3] - 4, menu_box[2] + 190, "#15928280")
		
		activated_clr = "#ffffffbb"
		deactivated_clr = "#00000055"
		clr = {}
		
		CheckAddr = {Loadlines_view,Grid_view,CustomWarp,Map,InfRepel,Trigger,NPC,Item,Warp,WTW}
		for i = 1,10 do
		if CheckAddr[i] then
			clr[i] = activated_clr
		else
			clr[i] = deactivated_clr
		end
		end
		
		
		
		gui.box(menu_box[1] + 5, menu_box[2] + 78, menu_box[1] + 17, menu_box[2] + 90, clr[1], "#ffffffff")
		gui.text(menu_box[1] + 21, menu_box[2] + 81, "Loadlines")
		
		gui.box(menu_box[1] + 5, menu_box[2] + 98, menu_box[1] + 17, menu_box[2] + 110, clr[2], "#ffffffff")
		gui.text(menu_box[1] + 21, menu_box[2] + 101, "Grid")
		
		gui.box(menu_box[1] + 5, menu_box[2] + 118, menu_box[1] + 17, menu_box[2] + 130, clr[3], "#ffffffff")
		gui.text(menu_box[1] + 21, menu_box[2] + 121, "CustomWarp")
		
		gui.box(menu_box[1] + 5, menu_box[2] + 138, menu_box[1] + 17, menu_box[2] + 150, clr[4], "#ffffffff")
		gui.text(menu_box[1] + 21, menu_box[2] + 141, "Map mv.")
		
		gui.box(menu_box[1] + 5, menu_box[2] + 158, menu_box[1] + 17, menu_box[2] + 170, clr[5], "#ffffffff")
		gui.text(menu_box[1] + 21, menu_box[2] + 161, "Repel")
		
		-------------------------------------------row2
		gui.box(menu_box[1] + 85, menu_box[2] + 78, menu_box[1] + 97, menu_box[2] + 90, clr[6], "#ffffffff")
		gui.text(menu_box[1] + 101, menu_box[2] + 81, "Trigger")
		
		gui.box(menu_box[1] + 85, menu_box[2] + 98, menu_box[1] + 97, menu_box[2] + 110, clr[7], "#ffffffff")
		gui.text(menu_box[1] + 101, menu_box[2] + 101, "NPC")
		
		gui.box(menu_box[1] + 85, menu_box[2] + 118, menu_box[1] + 97, menu_box[2] + 130, clr[8], "#ffffffff")
		gui.text(menu_box[1] + 101, menu_box[2] + 121, "Item")
		
		gui.box(menu_box[1] + 85, menu_box[2] + 138, menu_box[1] + 97, menu_box[2] + 150, clr[9], "#ffffffff")
		gui.text(menu_box[1] + 101, menu_box[2] + 141, "Warp")
		
		gui.box(menu_box[1] + 85, menu_box[2] + 158, menu_box[1] + 97, menu_box[2] + 170, clr[10], "#ffffffff")
		gui.text(menu_box[1] + 101, menu_box[2] + 161, "WTW")
		i = 0
		for k,v in pairs(mapId) do
			drawsquare(menu_box[3] - 78, menu_box[2] + 81 + i, mapId[k]['color'])
			gui.text(menu_box[3] - 70, menu_box[2] + 80 + i, k, '#bbffffcc')
			i = i + 10
		end
	end

	gui.box(menu_box[1] + 2, menu_box[2] + 178, menu_box[1] + 42, menu_box[2] + 189, "#00006633", "#00006655")
	aux = "MENU "
	if menu1_opened then
		aux = "CLOSE "
	end
	gui.text(menu_box[1] + 4, menu_box[2] + 181, aux, "yellow")
end

function printSettingsMenu2()
	if menu2_opened then
		gui.box(menu_box[1] + 2, menu_box[2] + 75, menu_box[3] - 4, menu_box[2] + 190, "#15928280")
		
		activated_clr = "#ffffffbb"
		deactivated_clr = "#00000055"
		clr = {}
		
		CheckAddr = {PerfectCatch,teleport1,mapediting,demostop,flycursor,Collision,chunkediting,temps8,temps9,temps10}
		for i = 1,10 do
		if CheckAddr[i] then
			clr[i] = activated_clr
		else
			clr[i] = deactivated_clr
		end
		end
		
		
		
		gui.box(menu_box[1] + 5, menu_box[2] + 78, menu_box[1] + 17, menu_box[2] + 90, clr[1], "#ffffffff")
		gui.text(menu_box[1] + 21, menu_box[2] + 81, "100% Catch")
		
		gui.box(menu_box[1] + 5, menu_box[2] + 98, menu_box[1] + 17, menu_box[2] + 110, clr[2], "#ffffffff")
		gui.text(menu_box[1] + 21, menu_box[2] + 101, "teleport")
		
		gui.box(menu_box[1] + 5, menu_box[2] + 118, menu_box[1] + 17, menu_box[2] + 130, clr[3], "#ffffffff")
		gui.text(menu_box[1] + 21, menu_box[2] + 121, "mapediting")
		
		gui.box(menu_box[1] + 5, menu_box[2] + 138, menu_box[1] + 17, menu_box[2] + 150, clr[4], "#ffffffff")
		gui.text(menu_box[1] + 21, menu_box[2] + 141, "pausetimer")
		
		gui.box(menu_box[1] + 5, menu_box[2] + 158, menu_box[1] + 17, menu_box[2] + 170, clr[5], "#ffffffff")
		gui.text(menu_box[1] + 21, menu_box[2] + 161, "flycursor")
		
		-------------------------------------------row2
		gui.box(menu_box[1] + 85, menu_box[2] + 78, menu_box[1] + 97, menu_box[2] + 90, clr[6], "#ffffffff")
		gui.text(menu_box[1] + 101, menu_box[2] + 81, "Collision")
		
		gui.box(menu_box[1] + 85, menu_box[2] + 98, menu_box[1] + 97, menu_box[2] + 110, clr[7], "#ffffffff")
		gui.text(menu_box[1] + 101, menu_box[2] + 101, "chunkediting")
		
		gui.box(menu_box[1] + 85, menu_box[2] + 118, menu_box[1] + 97, menu_box[2] + 130, clr[8], "#ffffffff")
		gui.text(menu_box[1] + 101, menu_box[2] + 121, "temps8")
		
		gui.box(menu_box[1] + 85, menu_box[2] + 138, menu_box[1] + 97, menu_box[2] + 150, clr[9], "#ffffffff")
		gui.text(menu_box[1] + 101, menu_box[2] + 141, "temps9")
		
		gui.box(menu_box[1] + 85, menu_box[2] + 158, menu_box[1] + 97, menu_box[2] + 170, clr[10], "#ffffffff")
		gui.text(menu_box[1] + 101, menu_box[2] + 161, "temps10")
		-------------------------------------------row3
		gui.box(menu_box[1] + 165, menu_box[2] + 78, menu_box[1] + 177, menu_box[2] + 90, clr[6], "#ffffffff")
		gui.text(menu_box[1] + 181, menu_box[2] + 81, "temps11")
		
		gui.box(menu_box[1] + 165, menu_box[2] + 98, menu_box[1] + 177, menu_box[2] + 110, clr[7], "#ffffffff")
		gui.text(menu_box[1] + 181, menu_box[2] + 101, "temps12")
		
		gui.box(menu_box[1] + 165, menu_box[2] + 118, menu_box[1] + 177, menu_box[2] + 130, clr[8], "#ffffffff")
		gui.text(menu_box[1] + 181, menu_box[2] + 121, "temps13")
		
		gui.box(menu_box[1] + 165, menu_box[2] + 138, menu_box[1] + 177, menu_box[2] + 150, clr[9], "#ffffffff")
		gui.text(menu_box[1] + 181, menu_box[2] + 141, "temps14")
		
		gui.box(menu_box[1] + 165, menu_box[2] + 158, menu_box[1] + 177, menu_box[2] + 170, clr[10], "#ffffffff")
		gui.text(menu_box[1] + 181, menu_box[2] + 161, "temps15")
		end 

	gui.box(menu_box[1] + 52, menu_box[2] + 178, menu_box[1] + 92, menu_box[2] + 189, "#00006633", "#00006655")
	aux2 = "MENU "
	if menu2_opened then
		aux2 = "CLOSE "
	end
	gui.text(menu_box[1] + 54, menu_box[2] + 181, aux2, "yellow")
end

function getTileColor(maptile)
	if Map or flycursor then 
	if maptile > 558 then
		return mapId['Jubilife']['color']
	else
		for k,v in pairs(mapId) do
			for i=1,#mapId[k]['number'] do
				if mapId[k]['number'][i] == maptile then 
					return mapId[k]['color']
				end
			end
		end
	end
	return mapId['Normal']['color']
elseif Collision then 
		for k,v in pairs(CollisionId) do
			for i=1,#CollisionId[k]['number'] do
				if CollisionId[k]['number'][i] == collisiontile then 
					return CollisionId[k]['color']
				end
			end
		end
	end
	return CollisionId['Normal']['color']
	
	end 
	
function printMap()
	if Map then 
	gui.box(map_box[1], map_box[2], map_box[3], map_box[4], "#00000080")
	
	if map_centered == true then
		x_paint = map_x_pos - math.floor(max_cols / 2)
		y_paint = map_y_pos - math.floor(max_rows / 2)
	end
	
	if x_paint < 0 or max_cols == maplayoutv then
		x_paint = 0
	elseif x_paint > maplayoutv - max_cols then
		x_paint = maplayoutv - max_cols
	end
	
	for i = x_paint, x_paint + max_cols - 1, 1 do
	for j = y_paint, y_paint + max_rows - 1, 1 do
		maptile = memory.readword(pointer + mapAddrOffset + 2 * i + maplayoutv*2*j)
		color = getTileColor(maptile)
		if (i == map_x_pos and j == map_y_pos) then
			gui.text(92,-190,("cur:")..bit.tohex(pointer+mapAddrOffset + 2*i + maplayoutv*2*j),'yellow')
			color = 'white'
		end
		if mode == 3 then
			drawsquare(2 + 4*(i-x_paint) + map_box[1], 2 + 4*(j-y_paint) + map_box[2], color, '#00000055')
		elseif hex_view then
			gui.text((i-x_paint)*25 + 4 + map_box[1],(j-y_paint) * 10 + 3 + map_box[2],bit.tohex(maptile, 4), color)
		else
			if maptile > 999 then
				maptile = '>999'
			end
			gui.text((i-x_paint)*25 + 4 + map_box[1],(j-y_paint) * 10 + 3 + map_box[2], maptile, color)
			end 
			
	end
	end 
	
	elseif flycursor then 
		if map_centered == true then
		x_paint = flycux - math.floor(max_cols / 2)
		y_paint = flycuy- math.floor(max_rows / 2)
		end
	
		if x_paint < 0 or max_cols == maplayoutv then
		x_paint = 0
		elseif x_paint > maplayoutv - max_cols then
		x_paint = maplayoutv - max_cols
		end
	
	for i = x_paint, x_paint + max_cols - 1, 1 do
	for j = y_paint, y_paint + max_rows - 1, 1 do
		maptile = memory.readword(pointer + 0x42C30 + 2 * i + maplayoutv*2*j)
		color = getTileColor(maptile)
		if (i == flycux and j == flycuy) then
			gui.text(92,-190,("cur:")..bit.tohex(base + 0x42C30 + 2*i + maplayoutv*2*j),'yellow')
			color = 'white'
		end
		if mode == 3 then
			drawsquare(2 + 4*(i-x_paint) + map_box[1], 2 + 4*(j-y_paint) + map_box[2], color, '#00000055')
		elseif hex_view then
			gui.text((i-x_paint)*25 + 4 + map_box[1],(j-y_paint) * 10 + 3 + map_box[2],bit.tohex(maptile, 4), color)
		else
			if maptile > 999 then
				maptile = '>999'
			end
			gui.text((i-x_paint)*25 + 4 + map_box[1],(j-y_paint) * 10 + 3 + map_box[2], maptile, color)
			end 
		end 
		end	
		
end 	
	gui.text(menu_box[1] + 3, menu_box[2] + 2, "Base: " .. bit.tohex(base),'yellow')
	gui.text(menu_box[1] + 50, menu_box[2] + 18, "X: "..(Xpostrackerx )..","..fmt4(Xpostrackerx ),'yellow')
	gui.text(menu_box[1] + 50, menu_box[2] + 28, "Y: "..(Ypostrackery)..","..fmt4(Ypostrackery),'yellow')
	
	if mapediting then
	mapcolor = 'red'
	else 
	mapcolor = 'yellow'
	end 
	
	if customjump then
	jumpcolor = 'red'
	else 
	jumpcolor = 'yellow'
	end 
	
	if collisionediting then
	collisioncolor = 'red'
	else 
	collisioncolor = 'yellow'
	end 
	gui.text(menu_box[1] + 50, menu_box[2] + 38, "Map: "..(LiveMapId)..","..fmt4(LiveMapId),mapcolor)
	gui.text(menu_box[1] + 50, menu_box[2] + 48, "Jump: "..(jump)..","..fmt4(jump),jumpcolor)
	gui.text(menu_box[1] + 140, menu_box[2] + 18, "Tile: "..(tilename[currenttile+1])..","..fmt2(currenttile),'yellow')
	--gui.text(menu_box[1] + 50, menu_box[2] + 58, "Chunk: "..(CurrentChunkv)..","..fmt2(CurrentChunkv),collisioncolor)
	--gui.text(menu_box[1] + 95, menu_box[2] + 2, (Repelsteps),'yellow')
end 

function updateLayout()
	if mode == 1 then
		menu_box = {0, -192, 256, -181}
		map_box = {0, 0, 256, 192}
		max_rows = 19
		max_cols = 10
	elseif mode == 2 then
		menu_box = {0, 0, 256, 11}
		map_box = {0, -192, 256, 0}
		max_rows = 19
		max_cols = 10
	end
end

function drawLoadLines()
	if key.shift then
		if check_key("L") then 
		Loadlines_view = not Loadlines_view
		end 
		if check_key("G") then 
		Grid_view = not Grid_view
		end
	end 
	xmiddle = 128
	ystart = menu_box[2]
	xstartLoop = -111 - rshift(movementX[1],12)
	yend = 200
	xloadX = -(XPos[1] % 32) + 23
	xloadY = -(YPos[1] % 32) + 25
	if NPC == true then
	gui.box(129 - rshift(movementX[1],12),-81 - rshift(movementY[1],12),144 - rshift(movementX[1],12),-95 - rshift(movementY[1],12), "#88FFFFA0", "#0FB58")
	end
	
	
	for i = -1,15,1 do
		colour = "#0FB58"
		if Grid_view == true then 
		gui.line((xstartLoop+i*16)+xmiddle,ystart,(xstartLoop+i*16)+xmiddle,yend, colour)
		end
		
		if Loadlines_view == true then
		if i == xloadX then colour = "red"
		gui.line((xstartLoop+i*16)+xmiddle,ystart,(xstartLoop+i*16)+xmiddle,yend, colour)
		end
		end

		end 
	ystart = ystart + 2 - rshift(movementY[1],12)
	for i = 1,15 do
		colour = "#0FB58"
		auxy = {-5,7,18,31,42,55,68,81,95,109,123,138,153,168,185}
		ynum = auxy[i]
		if Loadlines_view == true then 
		if i == xloadY then colour = "red"
		gui.line(0,ynum + ystart, 255, ynum + ystart, colour)
		end 
		
		end 
		if Grid_view == true then 
		gui.line(0,ynum + ystart, 255, ynum + ystart, colour)
		end 
	
	end
end

function showitem()
if key.shift then
	if check_key("I") then 
		Item = not Item 
		NPC = not NPC
		Trigger = not Trigger
		Warp = not Warp
	end 	
end 
		
if Item == true then
local ItemCoordPointer = base + OffsArray[3]
local ItemAmount = memory.readword(ItemCoordPointer-4)
local ItemXAddr = (ItemCoordPointer+ 0x4)
local ItemYAddr = (ItemCoordPointer+ 0x8)
local ItemXa = {}
local ItemYa = {}
local colour = "yellow"
local item = 0
-------------------------------
for i = 0,ItemAmount-1 do --Track Items, do -1 because you don't wanna add i*14 on the last item, that'd be max item + 0x14
ItemXa[i] = ItemXAddr + i*0x14
ItemYa[i] = ItemYAddr + i*0x14
	DX = 15*(Xpostrackerx -memory.readword(ItemXa[i]))
	DY = 15*(Ypostrackery-memory.readword(ItemYa[i]))
	gui.box(131-rshift(movementX[1],12)- DX,-93 - rshift(movementY[1],12)-  DY,
	142 - rshift(movementX[1],12)- DX,-83 - rshift(movementY[1],12)- DY, "#9793FF8", "purple")
end
end
-------------------------------
if NPC == true then
local NpcCoordPointer = base + OffsArray[4]
local NpcAmount = memory.readword(base + OffsArray[5])
local NpcCollXAddr = (NpcCoordPointer)
local NpcCollYAddr = (NpcCoordPointer + 0x8)
local NpcCollXa = {}
local NpcCollYa = {}
gui.text(5,5,(NpcAmount-1),'yellow')
-------------------------------
if id == 0x49 then 
NpcBlockSize = 0x12C
NpcNul = 3
else 
NpcBlockSize = 0x128
NpcNul = 2
end

for i = 0,(NpcAmount-NpcNul) do --Track NPC'select, do -2 because the NPC count tracks the player, + you don't wanna add i*0x128, that'd be max NPC + 0x128
NpcCollXa[i] = NpcCollXAddr + i*NpcBlockSize
NpcCollYa[i] = NpcCollYAddr + i*NpcBlockSize

		NPCX = 15*(Xpostrackerx -memory.readword(NpcCollXa[i]))
		NPCY = 15*(Ypostrackery-memory.readword(NpcCollYa[i]))
		boxcolor = "#88FFFFA0" edgecolor =  "#0FB58" --normal NPC
		--end 
		gui.box(131-rshift(movementX[1],12)- NPCX,-93 - rshift(movementY[1],12)- NPCY,
		142 - rshift(movementX[1],12)- NPCX,-83 - rshift(movementY[1],12)- NPCY, boxcolor, edgecolor)
		end
		 
if id == 0x49 then 	
FollowNPC = base + 0x25F10
FNpcX = memory.readword(FollowNPC)
FNpcY = memory.readword(FollowNPC+0x8)
if FNpcX ~= Xpostrackerx  or FNpcY ~= Ypostrackery then
		FNPCX = 15*(Xpostrackerx -FNpcX)
		FNPCY = 15*(Ypostrackery-FNpcY)
		gui.box(131-rshift(movementX[1],12)- FNPCX,-93 - rshift(movementY[1],12)- FNPCY,
		142 - rshift(movementX[1],12)- FNPCX,-83 - rshift(movementY[1],12)- FNPCY, "#88FFFFA0", "#0FB58")
end
gui.text(5,-20,(FNpcX),'yellow')
end
end
-------------------------------
if Trigger == true then 
local TriggerPointer = base + OffsArray[7]
local TriggerAddr= memory.readdword(TriggerPointer)
local TriggerTotalAmount = memory.readbyte(TriggerAddr - 0x4)
local TriggerXAmount = memory.readword(TriggerAddr+0x6)
local TriggerYAmount = memory.readword(TriggerAddr+0x8)
local TriggerXAddr = (TriggerAddr+0x2)
local TriggerYAddr = (TriggerAddr + 0x4)
local TriggerX = {}
local TriggerY = {}

--gui.text(20,10,TriggerXAmount,'yellow')
--gui.text(20,20,TriggerYAmount,'yellow')
--gui.text(20,30,bit.tohex(TriggerPointer),'yellow')
--gui.text(20,40,bit.tohex(TriggerAddr),'yellow')
--gui.text(20,50,bit.tohex(TriggerTotalAmount),'yellow')

if TriggerXAmount < 0xF then 
for i = 0,TriggerTotalAmount-1 do
TriggerX[i] = TriggerXAddr + i*0x10
TriggerY[i] = TriggerYAddr + i*0x10
local TriggerXAmount = memory.readword(TriggerAddr+0x6+i*0x10)
local TriggerYAmount = memory.readword(TriggerAddr+0x8+i*0x10)
for j = 0,TriggerXAmount-1 do
for k = 0,TriggerYAmount-1 do

		TrX = 15*(Xpostrackerx -memory.readword(TriggerX[i])-j)
		TrY = 15*(Ypostrackery-memory.readword(TriggerY[i])-k)
		gui.box(131-rshift(movementX[1],12)- TrX,-93 - rshift(movementY[1],12)- TrY,
		142 - rshift(movementX[1],12)- TrX,-83 - rshift(movementY[1],12)- TrY, "#FFF8666","#FFF66")
		
		
	end
	end
end
end	

end

if Warp == true then 
local WarpPointer = base+OffsArray[8]
local WarpAddr = memory.readdword(WarpPointer)
local WarpAmount = memory.readdword(WarpAddr - 0x4)
local WarpXAddr = WarpAddr
local WarpYAddr = WarpAddr+0x2
local WarpMapId = WarpAddr+0x4
local WarpXa = {}
local WarpYa = {}

for i = 0,WarpAmount-1 do
WarpXa[i] = WarpXAddr + i*0xC
WarpYa[i] = WarpYAddr + i*0xC
	WX = 15*(Xpostrackerx -memory.readword(WarpXa[i]))
	WY = 15*(Ypostrackery-memory.readword(WarpYa[i]))
	gui.box(131-rshift(movementX[1],12)- WX,-93 - rshift(movementY[1],12)-  WY,
	142 - rshift(movementX[1],12)- WX,-83 - rshift(movementY[1],12)- WY,"#600038", "#C00058")
end
end
end  
--
-- Keypress setup and checking
--
key = {}
last_key = {}
joy = {}
last_joy = {}

function get_keys()
	last_key = key
	key = input.get()
end

function check_key(btn)
	if key[btn] and not last_key[btn] then
		return true
	else
		return false
	end
end

function up(steps)
	target = bit.band(Ypostrackery - steps, 0xFFFF)
	if target < 0 and Ypostrackery > 0 then
		target = bit.band(bit.bnot(target) - 1, 0xFFFF)
	end
	while Ypostrackery ~= target do
		joy.up = true
		joy.down = false
		joy.left = false
		joy.right = false
		joypad.set(joy)
		joy = {}
		emu.frameadvance()
	Ypostrackery = memory.readword(YPositionAddrOffset + base)
	end
end

function right(steps)
	target = bit.band(Xpostrackerx  + steps, 0xFFFF)
	if target < 0 and Xpostrackerx  > 0 then
		target = bit.band(bit.bnot(target) - 1, 0xFF)
	end
	while Xpostrackerx  ~= target do
		joy.up = false
		joy.down = false
		joy.left = false
		joy.right = true
		joypad.set(joy)
		joy = {}
		emu.frameadvance()
	Xpostrackerx  = memory.readword(XPositionAddrOffset + base)
	end
end

function down(steps)
	target = bit.band(Ypostrackery + steps, 0xFFFF)
	if target < 0 and Ypostrackery > 0 then
		target = bit.band(bit.bnot(target) - 1, 0xFFFF)
	end
	while Ypostrackery ~= target do
		joy.up = false
		joy.down = true
		joy.left = false
		joy.right = false
		joypad.set(joy)
		joy = {}
		emu.frameadvance()
	Ypostrackery = memory.readword(YPositionAddrOffset + base)
	end
end

function left(steps)
	target = bit.band(Xpostrackerx  - steps, 0xFFFF)
	while Xpostrackerx  ~= target do
		joy.up = false
		joy.down = false
		joy.left = true
		joy.right = false
		joypad.set(joy)
		joy = {}
		emu.frameadvance()
	Xpostrackerx  = memory.readword(XPositionAddrOffset + base)
	end
end

function tweak()
	if key.shift then
		if check_key("T") then
		down (4)
		right (1)
		left (1)
		up (1)
		left (14)
		down (1)
		left (4)
		down (3)
		left (7)
		up(2)
		left (6)
		up (2)
		left (1)
		right (1)
		down (1)
		right (7)
		down (3)
		right (5)
		up (3)
		right (4)
		down (6)
		right (16)
		up (7)
		left (1)
		right (1)
		down (1)
		right (12)
		down (8)
		right (8)
		elseif check_key("Y") then 
		right (15)
		up (3)
		right (8)
		up (5)
		elseif check_key("K") then 
		down (4)
		left (1)
		right (1)
		left (19)
		down (3)
		left (7)
		up(2)
		left (6)
		up (2)
		left (1)
		right (1)
		down (2)
		up (2)
		right (7)
		down (4)
		right (5)
		up (3)
		right (4)
		down (6)
		right (16)
		up (7)
		left (1)
		right (1)
		down (1)
		right (12)
		down (8)
		right (8)
		
		
end
end
end

function walkthroughwalls()
if check_key("W") then
WTW = not WTW

if WTW == true then
memory.writeword(AddrArray[1] + LanguageArray[1],0x1000)
else
memory.writeword(AddrArray[1]+ LanguageArray[1],0x1C20)
end 
end 
end 

function infRepelfunc()
local RepelAddr = base + OffsArray[6]
local Repelsteps = memory.readbyte(RepelAddr)
--gui.text(menu_box[1] + 95, menu_box[2] + 2, "Repel: "..(Repelsteps),'yellow')
if InfRepel == true then
memory.writebyte(RepelAddr,0x10)
end 
end 

function CustomFly()
--select fly to eterna City to activate
if CustomWarp == true then
FlyMapIDAddr = base + OffsArray[10]
FlyMapId = memory.readdword(FlyMapIDAddr) 
FlyMapxAddr = FlyMapIDAddr + 0x8
FlyMapyAddr = FlyMapxAddr + 0x4
FlyMapx = memory.readdword(FlyMapxAddr)
FlyMapy = memory.readdword(FlyMapyAddr)  
	if FlyMapId == FlyOptionId then
	memory.writedword(FlyMapIDAddr,customwarpid)
	memory.writedword(FlyMapxAddr,customwarpx)
	memory.writedword(FlyMapyAddr,customwarpy)
	end
gui.text(menu_box[1] + 95, menu_box[2] + 2, "Warp: "..(FlyMapId),'yellow')	
end 
end 

function teleport()
if teleport1 == true then 
	if key.shift then
		if check_key("left") then
			memory.writedword(base + teleportX, (Xtel- jump))
			memory.writeword(base + teleportXmov, (telXmov - jump))
			if id == 0x41 or id == 0x43 or id == 0x59 then
			memory.writeword(base + stepamountAddr, stepamount + jump)
			end
		end
		if check_key("down") then
			memory.writedword(base + teleportY, (Ytel + jump))
			memory.writeword(base + teleportYmov, (telYmov + jump))
			if id == 0x41 or id == 0x43 or id == 0x59 then
			memory.writeword(base + stepamountAddr, stepamount + jump)
			end
		end
		if check_key("right") then
			memory.writedword(base + teleportX, (Xtel + jump))
			memory.writeword(base + teleportXmov, (telXmov + jump))
						if id == 0x41 or id == 0x43 or id == 0x59 then
			memory.writeword(base + stepamountAddr, stepamount + jump)
			end 
		end
		if check_key("up") then
			memory.writedword(base + teleportY, (Ytel  - jump))
			memory.writeword(base + teleportYmov, (telYmov - jump))
						if id == 0x41 or id == 0x43 or id == 0x59 then
			memory.writeword(base + stepamountAddr, stepamount + jump)
			end 
		end
		end 
	end
end 

function demostoptimer() 
if check_key("S") then
demostop = not demostop
end 
if id == 0x59 and demostop == true then
	memory.writeword(0x2106B90,0000)
end 
end 

function Catchratemod()
if id == 0x41 or id == 0x59 then 
	CatchAddr = AddrArray[2]
	if PerfectCatch then
	memory.writeword(CatchAddr, 0x4280)
	elseif memory.readword(CatchAddr) == 0x4280 then 
	memory.writeword(CatchAddr, 0x2801)
end 

elseif id == 0x43 then 
	if memory.readdword(AddrArray[2]) == 0x4A7E497D then 
	if PerfectCatch then
	--memory.writeword(0x224A774,0xE005)
	memory.writeword(0x224A782,0x2001)
	--memory.writedword(0x224A784,0x38010400)
	elseif memory.readword(0x224A774) == 0xE005 then 
	--memory.writeword(0x224A774,0xE009)
	memory.writeword(0x224A782,0x2008)
	--memory.writedword(0x224A784,0x38010400)
	
	end
	end 
end 
end 

function writemap(value)
if mapediting then 
if in_edit then 
	value = memory.readbyte(curptrmap) + value
	memory.writebyte(curptrmap, value)
	curptrmap = curptrmap - 1
	in_edit = false
else
	memory.writebyte(curptrmap, value*0x10)
	in_edit = true
end 

if curptrmap == LiveMapIdAddr -0x1 then 
curptrmap = LiveMapIdAddr + 1
mapediting = false 
end 
end 
end 
 
function CollisionMap()
if Collision then 
Tiledatapointer = memory.readdword(base+OffsArray[13])
CurrentChunkvAddr = Tiledatapointer + 0xAD
if chunkediting then 
else 
CurrentChunkvword = memory.readword(CurrentChunkvAddr-1)
CurrentChunkv = (CurrentChunkvword %0x10)
end 
CurrentChunkpointer = Tiledatapointer + 0x90 + 0x4*CurrentChunkv
CurrentChunk = memory.readdword(CurrentChunkpointer)
--gui.text (50,-60,"Chunkdat:"..bit.tohex(CurrentChunkv))
gui.text(50,-60,fmt8(CurrentChunkvAddr))
gui.text (50,-50,"Pointer:"..bit.tohex(CurrentChunkpointer))
gui.text (50,-40,"Chunkdat:"..bit.tohex(CurrentChunk))
--32*32 area * 2 bytes
	if map_centered == true then
		x_paint = 1
		y_paint = 1
	end
	 
	
	if x_paint <= 0 or max_cols == 32 then
		x_paint = 1
	elseif x_paint > 28 - max_cols then
		x_paint = 28 - max_cols 
	end
	
	if y_paint <= 0 then
		y_paint = 1
	elseif y_paint > 27 - max_rows then 
		y_paint = 27 - max_rows 
	end 
		
	
	
	for i = x_paint, x_paint + 15, 1 do
	for j = y_paint ,y_paint + max_rows-1, 1 do
		collisiontileAddr = (CurrentChunk + 2 * i + 32*2*j+2*chunktilepos-64-16)
		collisiontile = memory.readbyte(collisiontileAddr)
		color = getTileColor(collisiontile)	
		if collisiontileAddr == (CurrentChunk + 2*chunktileposo) then
		color = 'red'else 
		--debug gui.text(160,-50,fmt8(collisiontileAddr)) 
		--debug gui.text(160,-40,fmt8(CurrentChunk+chunktilepos)) 
		end 
		if collisiontile then 
		gui.text((i-x_paint)*16 + 4 + map_box[1],(j-y_paint) * 10 + 3 + map_box[2], fmt2(collisiontile), color)
		end 
			end 
	end 
	end 
end
 
function Customvalue()
LiveMapIdAddr = base +  LiveMapIdOffs
if check_key("M") then
mapediting = not mapediting
curptrmap = LiveMapIdAddr + 1
end 

if check_key("J") then
customjump = not customjump
if customjump then
jump = 31
end 
end 

if customjump then
if key.up then 
jump = jump + 8
elseif key.down then
jump = jump - 8
elseif check_key("right") then 
jump = jump + 1
elseif check_key("left") then 
jump = jump - 1
end
if jump < 1 then 
jump = 65535
end 
if jump > 65535 then 
jump = 1
end 
end 

if check_key("C") then 
collisionediting = true 
chunkediting = true 
if key.shift then
collisionediting = false
chunkediting = false 
end
end 

if collisionediting then 
if check_key("up") then
CurrentChunkv = CurrentChunkv + 1
if CurrentChunkv > 3 then 
CurrentChunkv = 3
end
collisionediting = false 
elseif check_key("down") then 
CurrentChunkv = CurrentChunkv -1
if CurrentChunkv < 0 then 
CurrentChunkv = 0
end 
collisionediting = false 
end 
end 

--gui.text(menu_box[1] + 20, menu_box[2] + 78, "curptr" .. bit.tohex(curptrmap),'yellow')
   for i, v in ipairs({0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF}) do
      if check_key(string.format("%X", i)) then writemap(v) break end
      if check_key("0") or check_key("numpad0") then writemap(0) break end
	  if check_key("numpad1") then writemap(1) break end 
	  if check_key("numpad2") then writemap(2) break end
	  if check_key("numpad3") then writemap(3) break end
	  if check_key("numpad4") then writemap(4) break end
	  if check_key("numpad5") then writemap(5) break end
	  if check_key("numpad6") then writemap(6) break end
	  if check_key("numpad7") then writemap(7) break end
	  if check_key("numpad8") then writemap(8) break end
	  if check_key("numpad9") then writemap(9) break end
	   end
end 

function flycursorfunc()
if flycursor then 
Map = false 
Collision = false 
FlycuXAddr = base + OffsArray[12]
FlycuYAddr = FlycuXAddr + 0x4
flycux = memory.readword(FlycuXAddr)
flycuy = memory.readword(FlycuYAddr)
estimatex = 0
estimatey = 0
if id == 0x41 or id == 0x59 then
gui.text(menu_box[1] + 140, menu_box[2] + 18, "X cursor: "..fmt4(flycux),'yellow')
gui.text(menu_box[1] + 140, menu_box[2] + 28, "Y cursor: "..fmt4(flycuy),'yellow')
if flycux > 0x1C then 
if flycux < 0x8000 then 
estimatex = (flycux)/10
gui.text(menu_box[1] + 140, menu_box[2] + 38, "Left for "..round(estimatex).."s",'yellow')
else 
estimatex = (flycux - 0x8000)/10
gui.text(menu_box[1] + 140, menu_box[2] + 38, "Right for "..round(estimatex).."s",'yellow')
end 
end 
if flycuy > 0x1C then 
if flycuy < 0x8000 then 
estimatey = (flycuy)/10
gui.text(menu_box[1] + 140, menu_box[2] + 48, "Up for "..round(estimatey).."s",'yellow')
else
estimatey = (flycuy - 0x8000)/10
gui.text(menu_box[1] + 140, menu_box[2] + 48, "Down for "..round(estimatey).."s",'yellow')
end 
end
estimatetotal = estimatex + estimatey 
gui.text(menu_box[1] + 140, menu_box[2] + 58, "Total: "..round(estimatetotal).."s",'yellow')

end
end 
end 

function tilefunc()
currenttile = memory.readbyte(OffsArray[2] + base + 0x3C)
end 

function fmt8(arg)
    return string.format("%08X", bit.band(4294967295, arg))
end

function fmt4(arg)
    return string.format("%04X", bit.band(65535, arg))
end

function fmt2(arg)
    return string.format("%02X", bit.band(255, arg))
end

function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

function fn()
	base = memory.readdword(base_addr)
	pointer = base 
	x_position = memory.readdwordsigned(pointer + XPositionAddrOffset)
	y_position = memory.readdwordsigned(pointer + YPositionAddrOffset)
	if id == 0x41 or id == 0x43 or id == 0x59 then 
	maplayoutv = 30
	elseif id == 0x49 then
	maplayoutv = 47
	end
	map_width = memory.readbyte(pointer + mapAddrOffset - 1)
	map_height = memory.readbyte(pointer + mapAddrOffset - 2)
	
	map_tile_pos = (math.modf(x_position / 32) or nil) + (math.modf(y_position / 32) or nil) * map_width
	map_y_pos = math.floor(map_tile_pos / maplayoutv)
	map_x_pos = map_tile_pos - map_y_pos * maplayoutv
	
	for i = 1,4 do
		movementX[i] = movementX[i+1]
		movementY[i] = movementY[i+1]
		XPos[i] = XPos[i+1]
		YPos[i] = YPos[i+1]
	end
	movementX[5] = memory.readword(base + movementXAddrOffset)
	movementY[5] = memory.readword(base + movementYAddrOffset)
	XPos[5] = memory.readword(base + OffsArray[2]+0x2)
	YPos[5] = memory.readword(base + OffsArray[2]+0xA)
	Xpostrackerx = memory.readword(base + OffsArray[1])
	Ypostrackery = memory.readword(base + OffsArray[1]+0x4)
	
	chunkxposo = (Xpostrackerx) % 32
	chunkyposo = ((Ypostrackery) % 32)*32
	chunkxpos = chunkxposo
	chunkypos = chunkyposo
	if chunkxposo < 7 then
	chunkxpos = 7
	elseif chunkxposo > 23 then
	chunkxpos = 23
	end 
	
	if chunkyposo > 6*32 then
	if chunkyposo > 19*32 then
	chunkypos = 19*32 
	end 
	chunkypos = chunkypos - 6*32
	else 
	chunkypos = 0
	end 
	
	chunktileposo = chunkxposo + chunkyposo
	chunktilepos = chunkxpos + chunkypos 
	--debug gui.text(5,-50,(chunktilepos),'yellow')

	
	Xtel = memory.readdword(base + teleportX)
	Ytel = memory.readdword(base + teleportY)
	telXmov = memory.readword(base + teleportXmov)
	telYmov = memory.readword(base + teleportYmov)
	stepamount = memory.readword(base + stepamountAddr)
	LiveMapId = memory.readword(base +LiveMapIdOffs)
	tilefunc()
	flycursorfunc()
	CollisionMap()
	showitem()
	get_keys()
	updateLayout()
	drawLoadLines()
	updateTab()
	printTopMenu()
	printMapControl()
	printSettingsMenu1()
	printSettingsMenu2()
	printMap()
	infRepelfunc()
	CustomFly()
	tweak()
	walkthroughwalls()
	teleport()
	Catchratemod()
	Customvalue()
	demostoptimer()


	if check_key("P") then 
	print(LiveMapId,fmt8(CurrentChunkpointer),fmt8(CurrentChunkpointer-base))
	memory.writeword(LiveMapIdAddr,LiveMapId+1)
	end 
end

gui.register(fn)