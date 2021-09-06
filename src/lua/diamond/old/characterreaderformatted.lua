---------------------------------------------
--Original version 'void.lua' created by MKdasher, 
--Basefinder by Ganix
--Modified into Character Converter for US gen 4 games
--V1.0, no JP/KR characterset
---------------------------------------------
local char_word = {
	Char_id = {
		color = '#FFFF9',
		number = {0x220,0x118,0x58}
	},
	Zero = {
		color = '#88888866',
		number = {0}
	},
	FFFF = {
		color = '#0FB58',
		number = {0xFFFF}
	},
	Normal = {
		color = '#159282',
		number = {}
	}
}
------------------------

ver = memory.readdword(0x023FFE0C)
if ver == 0 then
	ver = memory.readdword(0x027FFE0C)
end
id = bit.band(ver, 0xFF)
lang = bit.band(bit.rshift(ver, 24), 0xFF)
base_addr = 0

if id == 0x59 then                                     -- Pokemon D/P Demo
	if     lang == 0x45 then base_addr = 0x02106BAC    -- US / EU
	end
end

if id == 0x41 then                                     -- Pokemon D/P
	if     lang == 0x44 then base_addr = 0x02107100    -- DE
	elseif lang == 0x45 then base_addr = 0x02106FC0    -- US / EU
	elseif lang == 0x46 then base_addr = 0x02107140    -- FR
	elseif lang == 0x49 then base_addr = 0x021070A0    -- IT
	elseif lang == 0x4A then base_addr = 0x02108818    -- JP
	elseif lang == 0x4B then base_addr = 0x021045C0    -- KS
	elseif lang == 0x53 then base_addr = 0x02107160    -- ES
	end

elseif id == 0x43 then                                 -- Pokemon Pt
	if     lang == 0x44 then base_addr = 0x02101EE0    -- DE
	elseif lang == 0x45 then base_addr = 0x02101D40    -- US / EU
	elseif lang == 0x46 then base_addr = 0x02101F20    -- FR
	elseif lang == 0x49 then base_addr = 0x02101EA0    -- IT
	elseif lang == 0x4A then base_addr = 0x02101140    -- JP
	elseif lang == 0x4B then base_addr = 0x02102C40    -- KS
	elseif lang == 0x53 then base_addr = 0x02101F40    -- ES
	end

elseif id == 0x49 then                                 -- Pokemon HG/SS
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
local customaddress = 0x22AE39C--0x2298E4C --0x22B0514 --base + 0x2845
--0x22c2af0
--base + 0x33790
-- end overflow? 0x80B60
-- 0x6DB7E start cascade overflow
--0x22CF41E partytext
local Customcolor_address = base + 0
local customcolor = 'green'
local prevaddr = customaddress + 0x27E

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
local menu_opened = false
local x_paint = 0
local y_paint = 0

local hex_view = true 
local random_string_search = false
local specific_string_search = false 

continuous = 0
counter = 0
loop = 0

local tabl={}
local prev={}

local hex_view = true 
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

				for i = 33,94 do
					print(i," ",characterlist[i])
				end 
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
	drawarrowleft(menu_box[3] - 81, menu_box[2] + 2, '#FFF282')
	drawarrowright(menu_box[3] - 3, menu_box[2] + 2, '#FFF282')
	gui.text(menu_box[3] - 68, menu_box[2] + 2, mode_str[mode],'white')
end

function printMapControl()
	if map_centered then
		gui.box(menu_box[1] + 2,menu_box[2] + 15, menu_box[1] + 42, menu_box[2] + 55, "#00006633", "#00006655")
		drawarrowleft(menu_box[1] + 5,menu_box[2] + 32, '#666666cc')
		drawarrowright(menu_box[1] + 39,menu_box[2] + 32, '#666666cc')
		drawarrowup(menu_box[1] + 22,menu_box[2] + 19, '#666666cc')
		drawarrowdown(menu_box[1] + 22,menu_box[2] + 50, '#666666cc')
	
		gui.box(menu_box[1] + 2, menu_box[2] + 57, menu_box[1] + 42, menu_box[2] + 69, "#00006633", "#00006655")
		gui.text(menu_box[1] + 5, menu_box[2] + 60,"CENTER", '#FFF282')
	else
		gui.box(menu_box[1] + 2,menu_box[2] + 15, menu_box[1] + 42, menu_box[2] + 55, "#00000090")	
		drawarrowleft(menu_box[1] + 5,menu_box[2] + 32, 'yellow')
		drawarrowright(menu_box[1] + 39,menu_box[2] + 32, 'yellow')
		drawarrowup(menu_box[1] + 22,menu_box[2] + 19, 'yellow')
		drawarrowdown(menu_box[1] + 22,menu_box[2] + 50, 'yellow')	
		
		gui.box(menu_box[1] + 2, menu_box[2] + 57, menu_box[1] + 42, menu_box[2] + 69, "#00000090")
		gui.text(menu_box[1] + 5, menu_box[2] + 60,"MANUAL", "yellow")
	end
end


function printSettingsMenu()
	if menu_opened then
		gui.box(menu_box[1] + 2, menu_box[2] + 75, menu_box[3] - 4, menu_box[2] + 190, "#15928280")
		
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
		for k,v in pairs(char_word) do
			drawsquare(menu_box[3] - 78, menu_box[2] + 81 + i, char_word[k]['color'])
			gui.text(menu_box[3] - 70, menu_box[2] + 80 + i, k, '#bbffffcc')
			i = i + 10
		end
	end

	gui.box(menu_box[1] + 2, menu_box[2] + 178, menu_box[1] + 42, menu_box[2] + 189, "#00006633", "#00006655")
	aux = "MENU "
	if menu_opened then
		aux = "CLOSE "
	end
	gui.text(menu_box[1] + 4, menu_box[2] + 181, aux, "yellow")
end

function get_char_tile_color(chartile)			
			for k,v in pairs(char_word) do
				for i=1,#char_word[k]['number'] do
					if char_word[k]['number'][i] == chartile then 
						return char_word[k]['color']
					end break
				end
			end
	return char_word['Normal']['color']
end

function get_continuous(char_addr)
	char = 0
	count = 0
		for i=0,5 do
			char = memory.readword(char_addr+i*4) - 256
			if char > 32 and char < 95 then
				count = count + 1
			end
		end 

		if count >= 3 then
			return false
		else
			return true
		end 
end

function get_specific_string(char_addr,specific_string)
	char = 0
	count = 0
		for i=0,#specific_string-1 do
			char = memory.readword(char_addr+i*4) - 256
			var = string.find(specific_string,characterlist[char])
				if var == nil or var == '' then
					print("this is nil")
					return true
				else
					count = count + 1
				end
		end 
	if count >= 2 then
		return false
	else
		return true
	end 
end


function character_map()
	gui.box(map_box[1], map_box[2], map_box[3], map_box[4], "#00000080")

	if map_centered == true then
			x_paint = 1
			y_paint = 1
	end

	for i = x_paint, x_paint + 19, 1 do
		for j = y_paint, y_paint + 30, 2 do
			chartile_addr = (customaddress -22 + 2 *i + 20 * j + counter)
			
			while random_string_search do
				chartile_addr = (customaddress -22 + 2 *i + 20 * j + counter)
				random_string_search = get_continuous(chartile_addr)
				if random_string_search == false  then
					print("A potential word has been found at 0x",bit.tohex(chartile_addr))
				end 
				if counter >= 0x20000 + loop then
					random_string_search = false
					loop = loop + 0x20000
				else 
					counter = counter + 1
				end 
				prevaddr = chartile_addr + 0x27E + 1
			end 

			while specific_string_search do
				chartile_addr = (customaddress -22 + 2 *i + 20 * j + counter)
				specific_string_search = get_specific_string(chartile_addr,"RETIRE")
				if specific_string_search == false  then
					print("A potential word has been found at 0x",bit.tohex(chartile_addr))
				end 
				if counter >= 0x20000 + loop then
					print("nope")
					specific_string_search = false
					loop = loop + 0x20000
				else 
					counter = counter + 2
				end 
				prevaddr = chartile_addr + 0x27E + 1
			end 

			chartile = memory.readword(chartile_addr)
			-- print(chartile)
			color = get_char_tile_color(chartile)
			chartiledef = chartile - 256

		if chartile_addr == Customcolor_address - 4 then			
		color = customcolor
		end 
		
		if tabl['leftclick']or tabl['rightclick'] or cleared then
			if isCoordInBox(x, y, {menu_box[1] + 2, menu_box[2] + 15, menu_box[1] + 42, menu_box[2] + 55}) then
				prevaddr = chartile_addr
			elseif cleared then 
				prevaddr = chartile_addr + 0x27E
			cleared = false 
			end 
		end 
			-- -base after prevaddr
			if prevaddr >= base then 
			gui.text(menu_box[1] + 77, menu_box[2] + 2, "Off: " ..bit.tohex(prevaddr-0x27E -base),'yellow')
			gui.text(menu_box[1] + 11, menu_box[1] + 5, "Curr. Addr: " ..bit.tohex(prevaddr-0x27E),'yellow')
			else
			gui.text(menu_box[1] + 77, menu_box[2] + 2, "Curr: " ..bit.tohex(prevaddr-0x27E -base),'yellow')		
			end 
			
			movv = 11
			movv2 = 15
			multi = 12
			
			gui.text(menu_box[1] + 3, menu_box[2] + 2, "X: " .. bit.tohex(base),'yellow')
			if chartiledef <= #characterlist and chartiledef > 0 then 
			gui.text((i-x_paint)*multi + movv + map_box[1],(j-y_paint) * 5 + movv2 + map_box[2],characterlist[chartiledef],'#DFFf62')
			elseif chartile == 65535 then
			gui.text((i-x_paint)*multi + movv + map_box[1],(j-y_paint) * 5 + movv2 + map_box[2],"||",color)
			elseif chartile == 0xE0 then
			gui.text((i-x_paint)*multi + movv + map_box[1],(j-y_paint) * 5 + movv2 + map_box[2],"NL",'#0FB58')
			else
			gui.text((i-x_paint)*multi + movv + map_box[1],(j-y_paint) * 5 + movv2 + map_box[2],".",color)
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
	end
end

function enable_random_string_search()
	if check_key("S") then
		if key.shift then 
			specific_string_search = not specific_string_search 
		else 
		random_string_search = not random_string_search
		end
	end


	if check_key("L") then
		counter = 0
		cleared = true 
	end 
end

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

function fn()
	base = memory.readdword(base_addr) 
	updateTab()
	updateLayout()
	printTopMenu()
	printMapControl()
	printSettingsMenu()
	character_map()
	get_keys()
	enable_random_string_search()
end

gui.register(fn)