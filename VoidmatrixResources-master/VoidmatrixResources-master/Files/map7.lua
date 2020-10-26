---------------------------------------------
local mapId = {
	Highlight = {
		color = '#ff8800',
		number = {357, 212}
	},
	Underground = { 
		color = 'cyan',
		number = {2}
	},
	MysteryZone = {
		color = '#444444',
		number = {0, 1, 224, 243, 408}
	},
	Blackout = {
		color = '#ff00ff',
		number = {332, 333}
	},
	Movement = {
		color = 'purple',
		number = {117, 177, 179, 181, 183, 185, 188, 192, 393, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 496}
	},
	VoidExit = {
		color = 'yellow',
		number = {105, 114, 186, 187, 337, 461, 516}
	},
	Softlock = {
		color = '#ff0000',
		number = {35, 88, 91, 93, 95, 115, 122, 133, 150, 154, 155, 156, 176, 178, 180, 182, 184}
	},
	WWdanger = {
		color = 'blue',
		number = {7, 37, 49, 70, 102, 124, 135, 152, 169, 174, 190, 421, 429, 436, 444, 453, 460}
	},
	Outdoors = {
		color = '#66ffbbff',
		number = {3, 33, 45, 65, 86, 120, 132, 150, 165, 172, 188, 200, 202, 204, 206, 222, 224, 243, 252, 260, 262, 266, 274, 276, 277, 288, 320, 334, 336, 340, 341, 342, 343, 344, 345, 346, 347, 349, 350, 353, 354, 356, 362, 363, 365, 366, 367, 371, 373, 380, 382, 383, 385, 388, 391, 392, 395, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 411, 418, 426, 433, 442, 450, 457, 467, 468, 469, 470, 471, 472, 473}
	},
	Normal = {
		color = '#00bb00ff',
		number = {}
	}
}
------------------------

local pointerAddr = 0x02106FC0
local pointer
local mapAddrOffset = 0x22ADA
local xAddrOffset = 0x24A98+0x0
local yAddrOffset = 0x24AA0+0x0

-- +0x8104 to the coords for BT mode -- 

local map_box
local menu_box
local mapcontrol_box

local mode = 1
local mode_str = {
	"BottomScr",
	"TopScreen",
	"Small Map"
}
local max_cols = 0
local max_rows = 0

local map = {}

local map_tile_pos = 0
local map_x_pos = 0
local map_y_pos = 0

local map_width = 0
local map_height = 0

local x_position = 0
local y_position = 0

local map_centered = true
local menu_opened = false
local x_paint = 0
local y_paint = 0

local hex_view = true

local tabl={}
local prev={}
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
	if tabl['leftclick'] and not prev['leftclick'] then
		x = tabl['xmouse']
		y = tabl['ymouse']
		
		-- Menu Mode --
		if isCoordInBox(x, y, {menu_box[3] - 84, menu_box[2], menu_box[3] - 72, menu_box[4]}) then
			mode = (mode - 2) % 3 + 1
		elseif isCoordInBox(x, y, {menu_box[3] - 12, menu_box[2], menu_box[3], menu_box[4]}) then
			mode = mode % 3 + 1
		end
		-- Moving Map --
		if not map_centered then
			if isCoordInBox(x, y, {menu_box[1] + 2, menu_box[2] + 28, menu_box[1] + 15, menu_box[2] + 42}) then
				x_paint = x_paint - 1
			elseif isCoordInBox(x, y, {menu_box[1] + 29, menu_box[2] + 28, menu_box[1] + 42, menu_box[2] + 42}) then
				x_paint = x_paint + 1
			elseif isCoordInBox(x, y, {menu_box[1] + 16, menu_box[2] + 15, menu_box[1] + 28, menu_box[2] + 29}) then
				y_paint = y_paint - 1
			elseif isCoordInBox(x, y, {menu_box[1] + 16, menu_box[2] + 41, menu_box[1] + 28, menu_box[2] + 55}) then
				y_paint = y_paint + 1
			end
		end
		-- Centered --
		if isCoordInBox(x, y, {menu_box[1] + 2, menu_box[2] + 57, 42, menu_box[2] + 69}) then
			map_centered = not map_centered
		end
		-- Menu open --
		if isCoordInBox(x, y, {menu_box[1] + 2, menu_box[2] + 178, menu_box[1] + 42, menu_box[2] + 190}) then
			menu_opened = not menu_opened
		end
		-- Menu --
		if menu_opened then
			if isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 78, menu_box[1] + 17, menu_box[2] + 90}) then
				hex_view = not hex_view
			end
		end
	end
	prev = tabl
end

function printTopMenu()
	gui.box(menu_box[1], menu_box[2], menu_box[3], menu_box[4], "#00000090")
	gui.box(menu_box[3] - 12, menu_box[2], menu_box[3], menu_box[4], "#000000CC")
	gui.box(menu_box[3] - 84, menu_box[2], menu_box[3] - 72, menu_box[4], "#000000CC")
	drawarrowleft(menu_box[3] - 81, menu_box[2] + 2, 'white')
	drawarrowright(menu_box[3] - 3, menu_box[2] + 2, 'white')
	gui.text(menu_box[3] - 68, menu_box[2] + 2, mode_str[mode])
	
	gui.text(menu_box[1] + 3, menu_box[2] + 2, "X: " .. memory.readword(pointer + xAddrOffset))
	gui.text(menu_box[1] + 55, menu_box[2] + 2, "Y: " .. memory.readword(pointer + yAddrOffset))
	gui.text(menu_box[1] + 107, menu_box[2] + 2, "Off: " .. map_tile_pos)
end

function printMapControl()
	if map_centered then
		gui.box(menu_box[1] + 2,menu_box[2] + 15, menu_box[1] + 42, menu_box[2] + 55, "#00006633", "#00006655")
		drawarrowleft(menu_box[1] + 5,menu_box[2] + 32, '#666666cc')
		drawarrowright(menu_box[1] + 39,menu_box[2] + 32, '#666666cc')
		drawarrowup(menu_box[1] + 22,menu_box[2] + 19, '#666666cc')
		drawarrowdown(menu_box[1] + 22,menu_box[2] + 50, '#666666cc')
	
		gui.box(menu_box[1] + 2, menu_box[2] + 57, menu_box[1] + 42, menu_box[2] + 69, "#0000ff99")
		gui.text(menu_box[1] + 5, menu_box[2] + 60,"CENTER", "#00ffffff")
	else
		gui.box(menu_box[1] + 2,menu_box[2] + 15, menu_box[1] + 42, menu_box[2] + 55, "#0000ff66")	
		drawarrowleft(menu_box[1] + 5,menu_box[2] + 32, 'yellow')
		drawarrowright(menu_box[1] + 39,menu_box[2] + 32, 'yellow')
		drawarrowup(menu_box[1] + 22,menu_box[2] + 19, 'yellow')
		drawarrowdown(menu_box[1] + 22,menu_box[2] + 50, 'yellow')	
		
		gui.box(menu_box[1] + 2, menu_box[2] + 57, menu_box[1] + 42, menu_box[2] + 69, "#0000ff99")
		gui.text(menu_box[1] + 5, menu_box[2] + 60,"MANUAL", "#00ffffff")
	end
end

function printSettingsMenu()
	if menu_opened then
		gui.box(menu_box[1] + 2, menu_box[2] + 75, menu_box[3] - 4, menu_box[2] + 190, "#0000ff55")
		
		activated_clr = "#ffffffbb"
		deactivated_clr = "#00000055"
		clr = activated_clr
		
		if hex_view then
			clr = activated_clr
		else
			clr = deactivated_clr
		end
		gui.box(menu_box[1] + 5, menu_box[2] + 78, menu_box[1] + 17, menu_box[2] + 90, clr, "#ffffffff")
		gui.text(menu_box[1] + 21, menu_box[2] + 81, "HEX")
		
		i = 0
		for k,v in pairs(mapId) do
			drawsquare(menu_box[3] - 78, menu_box[2] + 81 + i, mapId[k]['color'])
			gui.text(menu_box[3] - 70, menu_box[2] + 80 + i, k, '#bbffffcc')
			i = i + 10
		end
	end

	gui.box(menu_box[1] + 2, menu_box[2] + 178, menu_box[1] + 42, menu_box[2] + 190, "#0000ff99")
	aux = "MENU "
	if menu_opened then
		aux = "CLOSE "
	end
	gui.text(menu_box[1] + 4, menu_box[2] + 181, aux, "#00ffffff")
end

function getTileColor(maptile)
	if maptile > 558 then
		return mapId['Outdoors']['color']
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
end

function printMap()
	gui.box(map_box[1], map_box[2], map_box[3], map_box[4], "#00000080")
	
	if map_centered == true then
		x_paint = map_x_pos - math.floor(max_cols / 2)
		y_paint = map_y_pos - math.floor(max_rows / 2)
	end
	
	if x_paint < 0 or max_cols == 30 then
		x_paint = 0
	elseif x_paint > 30 - max_cols then
		x_paint = 30 - max_cols
	end
	
	for i = x_paint, x_paint + max_cols - 1, 1 do
	for j = y_paint, y_paint + max_rows - 1, 1 do
		maptile = memory.readword(pointer + mapAddrOffset + 2 * i + 60 * j)
		color = getTileColor(maptile)
		if (i == map_x_pos and j == map_y_pos) then
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
	else
		menu_box = {0, -192, 256, -181}
		map_box = {0, 0, 124, 192}
		max_rows = 47
		max_cols = 30
	end
end

function fn()
	pointer = memory.readdword(pointerAddr)
	x_position = memory.readdwordsigned(pointer + xAddrOffset)
	y_position = memory.readdwordsigned(pointer + yAddrOffset)
	map_width = memory.readbyte(pointer + mapAddrOffset - 1)
	map_height = memory.readbyte(pointer + mapAddrOffset - 2)
	
	map_tile_pos = (math.modf(x_position / 32) or nil) + (math.modf(y_position / 32) or nil) * map_width
	
	map_y_pos = math.floor(map_tile_pos / 30)
	map_x_pos = map_tile_pos - map_y_pos * 30
	
	
	updateTab()
	updateLayout()
	printTopMenu()
	printMapControl()
	printSettingsMenu()
	printMap()
end

gui.register(fn)