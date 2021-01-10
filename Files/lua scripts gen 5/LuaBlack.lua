update_sprite = False --if set to true pressing hotkey Z will increment sprite index, after which opening and closing a menu will change the player sprite.
hotkey_cam = "C"
hotkeys_battle_cam = {"B","L"} --B is for the camera, L will end a battle.
hotkeys_npc = {"M","Z"}
hotkey_gui = "G"
row = 0
colls = 0 
change_map = false
gui_mode = true 

top_screen = -200
key = {}
last_key = {}
index_cams = 0
index_battle_cams = 0

function debug_inputs()
    btn = input.get()
    print(btn)
end 

--general camera 2148B98
--overworld camera data
cam_pan = {4000,0,0,0x228af28,0x228af24}
cam_slide = {4,0x45,0xffff,0x228af5c,0x228af54}
cam_rotate = {100,0,0xffff,0x228af3c,0x228af3e}
cam_rotate_self = {8000,0,0xffff,0x228af2c,0x228af2e} 
cam_zoom = {-8000,0,0xffff,0x228af40,0x228af40}
cam_setting = {"Off","Smooth move","Rotate focus","Rotate self","Slide (indoors only)","Zoom/Pan"}
cams_array = {cam_pan,cam_rotate,cam_rotate_self,cam_slide,cam_zoom}

cam_pan_text = {"Up","Down","Right","Left"}
cam_slide_text = {"Up","Down","Right","Left"}
cam_rotate_text = {"Up","Down","Right","Left"}
cam_rotate_self_text = {"Up","Down","Up","Down"}
cam_zoom_text = {"Zoom In","Zoom Out","Zoom In","Zoom Out"}
cams_text = {cam_pan_text,cam_rotate_text,cam_rotate_self_text,cam_slide_text,cam_zoom_text}

--battle camera data
--refer to the addresses/offsets inside function update_battle_var()
battle_cam_setting = {"Off","Smooth Move","Zoom","Zoom 2","Rotate focus"}

battle_cam_pan_text = {"Up","Down","Up","Down"}
battle_cam_zoom_text = {"Zoom in","Zoom out","Left","Right"}
battle_cam_zoom2_text = {"Up","Down","Up","Down"}
battle_cam_rotate_text = {"Up","Down","Up","Down"}
battle_cams_text = {battle_cam_pan_text,battle_cam_zoom_text,battle_cam_zoom2_text,battle_cam_rotate_text}
battle_cam_timer = 0x22A637C

chunk_tile_ptr = 0x2FE3264
chunk_tile_data = 0x22F04C0--memory.readdword(chunk_tile_ptr) + 0x60 --0x22F04C0

tiles = {
    Tall_Grass = {
        color = '#4f7f4f',
        id = {0x6}
    },
    Grass = {
        color = '#4fdf3f',
        id = {0x4}
    },
    Road = {
        color ='#ff8f3f',
        id = {0x1F,0x03}
    },
    Water = {
        color = '#0xaef',
        id = {0x3D}
    },
    Cave = {
        color = 'red',
        id = {0x0A}
    }
}

maps = {
    Mystery_zone = {
        color = '#1118a06',
        number = {0xFF}
    },
    legit_map = {
        color= '#8888a06',
        number = {}
    }
}


function get_keys()
	last_key = key
	key = input.get()
end

function check_key(btn,cont)
    if cont and key[btn] then
        return true 
    else    
        if key[btn] and not last_key[btn] then
            return true
        else
            return false
        end
    end 
end

function fmt(len,arg)
    return string.format("%0"..len.."X", bit.band(4294967295, arg))
end

function controll_cam(hotkey)
    if check_key(hotkey) then 
            index_cams = (index_cams + 1)%6
    end

    if key.shift and index_cams ~= 0 then
        if index_cams == 2 then 
        cam_8(cams_array[index_cams],cams_text[index_cams])
        else
        cam_16(cams_array[index_cams],cams_text[index_cams],cam_setting,index_cams)
        end 
    end 
end

function cam_8(cam_var,cam_text)
    --fix it to be readword and writeword for the second rotate
    if key.up then
        move_cam_8(cam_var[4],cam_text[1],cam_var[1])
    elseif key.down then 
        move_cam_8(cam_var[4],cam_text[2],-cam_var[1])
    end 
    if key.right then 
        move_cam_8(cam_var[5],cam_text[3],cam_var[1])
    elseif key.left then 
        move_cam_8(cam_var[5],cam_text[4],-cam_var[1])
    end 
end 

function move_cam_8(cam_val,cam_text_val,amount)
    addr_v = memory.readword(cam_val)
    memory.writeword(cam_val,addr_v+amount)
    print(cam_setting[index_cams+1],cam_text_val,fmt(2,addr_v))
end 

function cam_16(cam_var,cam_text,setting,index)
    --fix it to be readword and writeword for the second rotate
    if key.up then
        move_cam_16(cam_var[4],cam_text[1],cam_var[1],setting,index)
    elseif key.down then 
        move_cam_16(cam_var[4],cam_text[2],-cam_var[1],setting,index)
    end 
    if key.right then 
        move_cam_16(cam_var[5],cam_text[3],cam_var[1],setting,index)
    elseif key.left then 
        move_cam_16(cam_var[5],cam_text[4],-cam_var[1],setting,index)
    end 
end 

function move_cam_16(cam_val,cam_text_val,amount,setting,index)
    addr_v = memory.readdword(cam_val)
    memory.writedword(cam_val,addr_v+amount)
    print(setting[index+1],cam_text_val,fmt(4,addr_v))
end 

function update_battle_var()
    battle_cam = memory.readdword(0x02291de0)
    battle_cam_pan = {0x1000,0,0,battle_cam + 0xA4,battle_cam + 0xA0}
    battle_cam_zoom = {-0x4000,0,0,battle_cam+0x8c,battle_cam+0x88}
    battle_cam_zoom2 = {0x4000,0,0,battle_cam+0x90,battle_cam+0x90}
    battle_cam_rotate = {0x100,0,0,battle_cam + 0x94,battle_cam + 0x94}
    battle_cams_array = {battle_cam_pan,battle_cam_zoom,battle_cam_zoom2,battle_cam_rotate}

    battle_hud_addr = memory.readdword(0x22A62E0)
    battle_hud_ally = {battle_hud_addr + 0x40,battle_hud_addr + 0x44,battle_hud_addr + 0x48,battle_hud_addr + 0x4c,battle_hud_addr + 0x50} --22BE064
    battle_hud_enemy = {battle_hud_addr + 0xC0,battle_hud_addr + 0xC8} --doublebattle:22BE178
    --battle_hud = {0x226DAFC,0x226D6B5} -- enemy, ally. This is HP, if set to 0 when battle starts no hud will be present
end 

function controll_battle_cam(hotkey)
    if check_key(hotkey) then
        index_battle_cams = (index_battle_cams+1)%5
    end

    if index_battle_cams ~= 0 then 
    update_battle_var()   
    memory.writeword(battle_cam_timer,0)

    for i = 1,#battle_hud_ally do
        memory.writedword(battle_hud_ally[i],0)
    end 
    for i = 1,#battle_hud_enemy do 
        memory.writedword(battle_hud_enemy[i],0)
    end
        if key.shift then 
        cam_16(battle_cams_array[index_battle_cams],battle_cams_text[index_battle_cams],battle_cam_setting,index_battle_cams)
        end
    end 
end 

function end_battle(hotkey)
    if check_key(hotkey) then
        update_battle_var()
        memory.writebyte(battle_cam + 0xC4,1)
    end 
end

function controll_pos(hotkeys)
    current_map_id_a = 0x224F90C -- 0x0224FFE0
    current_map_id = memory.readword(current_map_id_a)
    player_pos = memory.readdword(0x227589C)

    vis_pos = {vis_x,vis_y,vis_z}--one npc is 0x200 bytes
    vis_pos_addr = {player_pos+0,player_pos+8,player_pos+16}
    vis_pos = {vis_x = memory.readdword(vis_pos_addr[1]) ;vis_y = memory.readdword(vis_pos_addr[2]) ; vis_z = memory.readdword(vis_pos_addr[3])}

    phys_pos = {phys_x,phys_y}
    phys_pos_addr = {player_pos-8,player_pos-4}
    phys_pos = {phys_x = memory.readword(phys_pos_addr[1]); phys_y= memory.readword(phys_pos_addr[2])}

    true_pos_addr = {0x224F912,0x224F91A}
    true_pos = {true_x = memory.readword(true_pos_addr[1]),true_y = memory.readword(true_pos_addr[2])}
    player_sprite = 0xB0

    if check_key(hotkeys[1]) then
        change_map = not change_map
    end 

    if change_map then
        -- memory.writeword(current_map_id_a,0x151)
        if key.control then 
            if key.up then memory.writeword(current_map_id_a,current_map_id +1)
            elseif key.down then memory.writeword(current_map_id_a,current_map_id -1)
            elseif check_key('left') then memory.writeword(current_map_id_a,current_map_id -1)
            elseif check_key('right') then memory.writeword(current_map_id_a,current_map_id +1)
            end
        end 
    end 


    if check_key(hotkeys[2]) and update_sprite then 
        memory.writeword(player_pos+player_sprite,memory.readdword(player_pos+player_sprite)+1)
    end 

    if key.space then
        if key.right then
            memory.writedword(vis_pos_addr[1],vis_pos["vis_x"]+0x10000)
            memory.writedword(phys_pos_addr[1],phys_pos["phys_x"]+1)
        elseif key.left then
            memory.writedword(vis_pos_addr[1],vis_pos["vis_x"]-0x10000)
            memory.writedword(phys_pos_addr[1],phys_pos["phys_x"]-1)
        end 
        if key.up then
            memory.writedword(vis_pos_addr[2],vis_pos["vis_y"]-0x10000)
            memory.writedword(phys_pos_addr[2],phys_pos["phys_y"]-1)
        elseif key.down then
            memory.writedword(vis_pos_addr[2],vis_pos["vis_y"]+0x10000)
            memory.writedword(phys_pos_addr[2],phys_pos["phys_y"]+1)
        end
    end
end

function drawsquare(sa,sb,a,b,c,d)
    gui.box(a,b,a+sa,b+sb,c,d)
end

function load_map()
    gui.box(0,0,260,200,"#0000009")
    start_mapdata = 0x2250C2C
    map_x_offset = math.modf(true_pos["true_x"] / 32) - 4
    map_y_offset = math.modf(true_pos["true_y"] / 32) - 9
    

    for vertical = map_x_offset,map_x_offset+8 do 
        for horizontal = map_y_offset,map_y_offset+18 do
            current_map_addr = start_mapdata + vertical*2 +horizontal*2*29

            if current_map_addr < start_mapdata or current_map_addr > start_mapdata + 1564 then
                current_map = 0XFFFF
            else
                current_map = memory.readword(current_map_addr)
            end 

            if current_map_addr == start_mapdata + (map_x_offset+4)*2 +(map_y_offset+9)*2*29 then
                map_color = 'yellow'
            elseif current_map == 0xFFFF then 
            map_color = 'grey'
            else 
            map_color = "#80f080" --get_map_color(current_map)
            end 
            
            gui.text(4+ (vertical - map_x_offset) *28, 3+ (horizontal-map_y_offset) * 10, fmt(2,current_map),map_color)
            --drawsquare(2,4+ (vertical - colls) *8, 3+ (horizontal-row) * 8,map_color)
        end
    end 
end

function get_map_color(map_id)
    for k,v in pairs(maps) do
        for i=1,#maps[k]['number'] do
            if maps[k]['number'][i] == map_id then 
                return maps[k]['color']
            end
        end
    end
    return 'white'
end

function get_tile_color(tile)
    for k,v in pairs(tiles) do
        for i=1,#tiles[k]['id'] do
            if tiles[k]['id'][i] == tile then 
                return tiles[k]['color']
            end
        end
    end
    return 'white'
end


function load_chunks()
    current_chunk = 0
    for w = 0,1 do 
        for h = 0,1 do 
            for i = 0,31 do
                for j = 0,31 do
                    current_chunk_addr = chunk_tile_data + i*8 + j*8*32 + current_chunk*(8*32+32*32*8)
                    tile = memory.readbyte(current_chunk_addr)
                    chunkcolor = get_tile_color(tile)
                    drawsquare(2,2,i*4 +w*(32*4),j *3+h*(32*3),chunkcolor)
                end
            end 
           current_chunk = current_chunk + 1
        end
    end
end


function show_gui(hotkey)
    if check_key(hotkey) then 
        gui_mode = not gui_mode
    end
    if gui_mode then 
    load_map()
    --load_chunks()
    --gui.text(5,5,"BW freecam lua by RETIRE",white)
    gui.text(5,top_screen+15,"OW Cam: "..cam_setting[index_cams+1],"red")
    gui.text(5,top_screen+25,"Battle Cam: "..battle_cam_setting[index_battle_cams+1],"red")
    gui.text(5,top_screen+35,"Phys X: "..phys_pos["phys_x"].." Vis X: "..vis_pos["vis_x"],"red")
    gui.text(5,top_screen+45,"Phys Y: "..phys_pos["phys_y"].." Vis Y: "..vis_pos["vis_y"],"red")
    gui.text(5,top_screen+55,"Map Id: "..fmt(2,current_map_id),"red")
    end 
end

function setup_loop()
    get_keys()
    --debug_inputs()
    controll_battle_cam(hotkeys_battle_cam[1])
    end_battle(hotkeys_battle_cam[2])
    controll_cam(hotkey_cam)
    controll_pos(hotkeys_npc)
    show_gui(hotkey_gui)
end

gui.register(setup_loop)