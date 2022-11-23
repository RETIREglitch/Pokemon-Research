-------------------------------------------------
----    RSFD - Routing Script For Dummies    ----
-------------------------------------------------
--              by RETIREglitch                --
-------------------------------------------------
--  base pointer addresses provided by Ganix   --
--  void formula based on void.lua by MKdasher --
-------------------------------------------------

-- DATA TABLES

local map_id_list = {
	Goal = {
		color = '#f7bbf3',
		ids = {333,332}
		},
	Chains= {
		color = '#DfA',
		ids = {469,406,385,40, 442, 450, 457, 499, 501,342, 406, 501, 502, 503}
	},
	MysteryZone = {
		color = '#88888866',
		ids = {0}
	},
	Blackout = {
		color = 'orange',
		ids = {332, 333}
	},
	Movement = {
		color = 'purple',
		ids = {117, 177, 179, 181, 183, 192, 393,
            474, 475, 476, 477, 478, 479, 480, 481, 482, 483,
            484, 485, 486, 487, 488, 489, 490, 496}
	},
	VoidExit = {
		color = 'yellow',
		ids = {105, 114, 337, 461, 516, 186, 187}
	},
	DANGER = {
		color = 'red',
		ids = {35, 88, 93, 95, 122,133, 150 ,154, 155, 156, 176, 178, 180, 182,
				184, 185, 188, 291, 293, 295, 504, 505, 506, 507, 508, 509}
	},
	Wrongwarp = {
		color = '#666fd',
		ids = {7,37,49,70,102,124,135,152,169,174,190,421,429,436,444,453,460,495}
	},
	Jubilife = {
		color = '#66ffbbff',
		ids = {3}
	},
	Normal = {
		color = '#00bb00ff',
		ids = {}
	}
}

map_ids = {}

for k,v in pairs(map_id_list) do
	for i=1,#map_id_list[k]['ids'] do
		map_ids[map_id_list[k]['ids'][i]] = map_id_list[k]['color']
	end
end

local tile_names = {
			"nothing","nothing","Grass","Grass","4","Cave","Cave","7","Cave","9","10", "Haunted House","Cave wall","13","14","15",
			"Pond","Water","Water","WaterF","Water","Water","Puddle","ShallW","24","Water","26","27","28","29","30","31",
			"Ice","Sand","Water","35","Cave","Cave","38","39","40","41","Water","43","44","45","46","47",
			"Onesided Wall","Onesided Wall","Onesided Wall","Onesided Wall","Doublesided Wall","Doublesided Wall","Doublesided Wall","Doublesided Wall","Ledge (R)","Ledge (L)","Ledge (U)","Ledge (D)","60","61","62","Ledge Corner",
			"Spin (R)","Spin (L)","Spin (U)","Spin (D)","68","69","70","71","72","Stair","Stair","Rockclimb (V)","Rockclimb (H)","77","78","79",
			"Water","Water","Water","Water","84","85","Raised Model","Raised Model","Raised Model","Raised Model","90","91","92","93","Warp","Warp",
			"Warp","Warp","Doormat","Doormat","Doormat","Doormat","Warp","Warp","Warp","Warp","Warp","Warp","Warp","Warp","Warp","Warp",
			"Start Bridge","Bridge","Bridge (C)","Bridge (W)","Bridge","Bridge (Sn)","Bike Bridge","Bike Bridge","Bike Bridge","Bike Bridge","Bike Bridge","Bike Bridge (G)","Bike Bridge (W)","Bike Bridge","126","127",
			"Counter","129","130","PC","132","Map","Television","135","Bookcases","137","138","139","140","141","Book","143",
			"144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159",
			"Soil","Deep Snow 1","Deep Snow 2","Deep Snow 3","Mud","Mud (B)","Mud Grass","Mud Grass (B)","Snow","Melting snow","170","171","172","173","174","175",
			"176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191",
			"192","193","194","195","196","197","198","199","200","201","202","203","204","205","206","207",
			"208","209","210","211","212","213","214","Bike ramp (R)","Bikeramp (L)","Slope top","Slope bottom","Bikestall","220","221","222","223",
			"Bookcases","Bookcases","Bookcases","227","Thrashbin","Misc Objects","230","231","232","233","234","235","236","237","238","239",
			"240","241","242","243","244","245","246","247","248","249","250","251","252","253","254","Unloaded"
} -- 6 is tree in HGSS

tile_id_list = {
	Grass = {
        color = '#40a',
        ids = {0x2,0x7B}
    },
	Warps = {
        color = '#f03',
        ids ={0x5E,0x5f,0x62,0x63,0x69,0x65,0x6f,0x6D,0x6A,0x6C,0x6E}
	},
	Cave = {
        color = '#bb7410',
        ids = {0x6,0x8,0xC}
	},
	Water = {
        color = '#4888f',
        ids = {0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x19,0x22,0x2A,0x7C}
    },
    Sand = {
        color = '#e3c',
        ids = {0x21,0x21}
	},
	DeepSnow1 = {
        color = '#8da9cb',
        ids = {0xA1}
    },
    DeepSnow2 = {
        color = '#6483a7',
        ids = {0xA2}
    },
    DeepSnow3 = {
        color = '#52749d',
        ids = {0xA3}
	},
    Mud = {
        color = '#92897',
        ids = {0xA4}
    },
    MudBlocking = {
        color = '#92704',
        ids = {0xA5}
    },
    MudGrass = {
        color = '#4090',
        ids = {0xA6}
    },
    MudGrassBlocking = {
        color = '#55906',
        ids = {0xA7}
	},
    Snow = {
        color = '#b9d0eb',
        ids = {0xA8}
	},
	TallGrass = {
        color = '#2aa615',
        ids = {0x3}		
	},
	RandomObj = {
        color = 'white',
        ids = {0xE5,0X8E,0X8f}
    },
	Spinners = {
        color = '#ffd',
        ids = {0x40,0x41,0x42,0x43}
    },
	Ice = {
        color = '#56b3e0',
        ids = {0x20,0x20}
    },
	icestair = {
        color = '#ffd',
        ids = {0x49,0x4A}
    },
	CircleWarps = {
        color = '#a0a',
        ids = {0x67}
    },
	Modelfl = {
        color = '#afb',
       ids = {0x56,0x57,0x58,} 
    },
	ModelFloor = {
        color = '#a090f',
       ids = {0x59}
    },
	OnesidedWall = {
        color = '#a090f',
       ids = {0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37}
    },
	Bikestalls = {
        color = '#0690a',
       ids = {0xDB}
    },
	Counter = {
        color = '#f7a',
        ids = {0x80}
    },
	PC = {
       color = '#0690b',
       ids = {0x83}
    },
	Map = {
       color = '#00eee',
       ids = {0x85}
    },
	TV = {
       color = '#4290e',
       ids = {0x86}
    },
	Bookcases = {
        color = '#0ddd7',
        ids = {0x88,0xE1,0xE0,0xE2}
    },
	Bin = {
        color = '#06b04',
       ids = {0xE4}
	},
    HauntedHouse = {
        color = '#A292BC',
        ids = {0xB}
    },
    Ledge = {
        color = '#D3A',
        ids = {0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F}
    },
    RockClimb = {
        color = '#C76',
        ids = {0x4B,0x4C}
    },
    Bridge = {
        color = '#C79',
        ids = {0x70,0x71,0x72,0x73,0x74,0x75}
	},
    BikeBridge= {
        color = '#C7A55',
        ids = {0x76,0x77,0x78,0x79,0x7A,0x7D}
		-- BikeBridge 0x7C moves to water, 0x7B moved to grass
	},
    Berrysoil = {
        color = '#b2703',
        ids = {0xA0}
    },
    BikeRamp = {
        color = '#B890',
        ids = {0xD7,0xD8}
	},
    Quicksand = {
        color = '#A880',
        ids = {0xD9,0xDA}
    },
	Normal = {
        color = '',
        ids = {0xff}
    },
	-- Trees = {
    --     color = '#CCCCC',
    --     ids = {0x6}
    -- }, -- HGSS, remove 0x6 from cave list if used
}

tile_ids = {}

for k,v in pairs(tile_id_list) do
	for i=1,#tile_id_list[k]['ids'] do
		tile_ids[tile_id_list[k]['ids'][i]] = tile_id_list[k]['color']
	end
end

data_tables = {
	--1 DP and PD demo
	{	
		item_struct_offs = 0x838,
		step_counter_offs = 0x1384,

		-- start of structure offsets/structure data
		player_live_struct_offs = 0x1440,
		signature_offs = 0x5B15,
		signature_size = 0x600,
	
		mapdata_and_menu_struct_offs = 0x22964,
		chunk_calculation_ptr = 0x229F0,
		matrix_struct_offs = 0x22A84,
		matrix_size = 30,

		general_npc_struct_offs = 0x248C8,
		player_npc_struct_offs = 0x24A14,

		object_struct_offs = 0x23C80,
		object_struct_size = 0x14,
		warp_struct_size = 0xC,
		trigger_struct_size = 0x10,

		npc_struct_offs =  0x24B5C,
		npc_struct_size = 0x128,

		memory_shift = {
			UG=0x8104,
			BT=0x8104,
			OW=0x0
		},
		
		memory_state_check_offs = 0x22A00, -- 0x22A00,0x22A04,0x22A20
		opcode_pointer =  0x29500, -- affected by bt

		memory_state_check_val = 0x2C9EC,
	
		menu_data = 0x29434,
		current_pocket_index_offs = 0x2977C,
		hall_of_fame_struct_offs = 0x2C298,
		hall_of_fame_entry_size = 0x3C,


		ug_revealing_circle_struct_offs = 0x115150,
		ug_trap_struct_offs = 0x12B5B0,
		ug_trap_struct_size = 0x6,
		

		ug_cur_gem_ptr = 0x12DBC0,
		ug_gem_struct_offs = 0x12D5E0,
		ug_gem_struct_size = 0x6,
		ug_gem_count = 0xFA,

		ug_excavation_minigame_offs = 0x12DD36,
		ug_excavation_minigame_tile_count = 0x81, -- 13 col * 9 row of 1 byte each
		ug_excavation_minigame_visual_offs = 0x534C4,

		

		-- static addresses
		bag_hovering_data_ptr = 0x2106FAC,
		menu_addr = 0x21C45BC, -- also check for underground minigame

		ug_trap_count_addr= 0x222CAD7,

		ug_init_addr = 0x2250E86,
		ug_init_val = 0x1F,

		game_state = 0x21C45B8, -- 4 = wifiroom, 5 = underground, 6 = overworld, 0x10 = battle
		battle_check = 0x221885E
	},

	--2 DP KOREAN version
	{

	},
	--3 Pl
	{

	},
	--4 HGSS
	{

	},
}

demo = false
hgss = false

game_specific_data = {
	Y = {
		game_name = "DP Demo",
		demo = true,
		language_specific_data = {
			E = {base_addr=0x02106BAC,data_table_index=1,collision_check_addr=0x2056C06,catch_chance_addr=0x223C1F4} -- US/EU ENGLISH
		}
	},
	A = {
		game_name  = "DP",
		language_specific_data = {
			D = {base_addr=0x02107100,data_table_index=1,collision_check_addr=0x2056C76,catch_chance_addr=nil}, -- GERMAN
			E = {base_addr=0x02106FC0,data_table_index=1,collision_check_addr=0x2056C06,catch_chance_addr=0x223C1F4}, -- US/EU ENGLISH
			F = {base_addr=0x02107140,data_table_index=1,collision_check_addr=0x2056C76,catch_chance_addr=nil}, -- FRENCH
			I = {base_addr=0x021070A0,data_table_index=1,collision_check_addr=0x2056C76,catch_chance_addr=nil}, -- ITALIAN
			J = {base_addr=0x02108818,data_table_index=1,collision_check_addr=0x20593E0,catch_chance_addr=nil}, -- JAPANESE
			K = {base_addr=0x021045C0,data_table_index=2,collision_check_addr=0x20570DE,catch_chance_addr=nil}, -- KOREAN
			S = {base_addr=0x02107160,data_table_index=1,collision_check_addr=0x2056C76,catch_chance_addr=nil} -- SPANISH
		}
	},
	C = {
		game_name = "Pl",
		language_specific_data = {
			D = {base_addr=0x02101EE0,data_table_index=3,collision_check_addr=0x2060CC4,catch_chance_addr=nil}, -- GERMAN
			E = {base_addr=0x02101D40,data_table_index=3,collision_check_addr=0x2060C20,catch_chance_addr=0x224A75C}, -- US/EU ENGLISH
			F = {base_addr=0x02101F20,data_table_index=3,collision_check_addr=0x2060CC4,catch_chance_addr=nil}, -- FRENCH
			I = {base_addr=0x02101EA0,data_table_index=3,collision_check_addr=0x2060CC4,catch_chance_addr=nil}, -- ITALIAN
			J = {base_addr=0x02101140,data_table_index=3,collision_check_addr=0x20604E8,catch_chance_addr=nil}, -- JAPANESE
			K = {base_addr=0x02102C40,data_table_index=3,collision_check_addr=nil,catch_chance_addr=nil}, -- KOREAN
			S = {base_addr=0x02101F40,data_table_index=3,collision_check_addr=0x2060CC4,catch_chance_addr=nil} -- SPANISH
		}
	},
	I = {
		game_name = "HGSS",
		hgss = true,
		language_specific_data = {
			D = {base_addr = 0x02111860,data_table_index=4,collision_check_addr=0x205DB46,catch_chance_addr=nil}, -- GERMAN
			E = {base_addr = 0x02111880,data_table_index=4,collision_check_addr=0x205DAA2,catch_chance_addr=nil}, -- US/EU ENGLISH
			F = {base_addr = 0x021118A0,data_table_index=4,collision_check_addr=0x205DB46,catch_chance_addr=nil}, -- FRENCH
			I = {base_addr = 0x02111820,data_table_index=4,collision_check_addr=0x205DB46,catch_chance_addr=nil}, -- ITALIAN
			J = {base_addr = 0x02110DC0,data_table_index=4,collision_check_addr=0x205D36A,catch_chance_addr=nil}, -- JAPANESE
			K = {base_addr = 0x02112280,data_table_index=4,collision_check_addr=nil,catch_chance_addr=nil}, -- KOREAN
			S = {base_addr = 0x021118C0,data_table_index=4,collision_check_addr=0x205DB46,catch_chance_addr=nil} -- SPANISH
		}
	}

}

ver = memory.read_u32_le(0x023FFE0C)
if ver == 0 then
	ver = memory.read_u32_le(0x027FFE0C)
end

id = bit.band(ver, 0xFF)
game_id = string.char(id)

lang_ascii = bit.band(bit.rshift(ver, 24), 0xFF)
lang = string.char(lang_ascii)

game_data = game_specific_data[game_id]
lang_data = game_data["language_specific_data"][lang]

data_table = data_tables[lang_data["data_table_index"]]

-- base struct
base_struct = {
	player_name=0x278,
	money = 0x28C,
}

-- live player struct
start_live_struct = data_table["player_live_struct_offs"]

live_struct = {
	step_counter = data_table["step_counter_offs"],
	
	map_id_32 = start_live_struct + 0xC,
	unknown_32 = start_live_struct + 0x10,
	x_pos_32_r = start_live_struct + 0x14,
	z_pos_32_r = start_live_struct + 0x18,
	y_pos_32_r = start_live_struct + 0x1C,

	map_id_last_warp_32 = start_live_struct + 0x20,
	unknown_last_warp_32 = start_live_struct + 0x24,
	x_pos_last_warp_32 = start_live_struct + 0x28,
	z_pos_last_warp_32  = start_live_struct + 0x2C,
	y_pos_last_warp_32  = start_live_struct + 0x30,

	map_id_last_warp_32 = start_live_struct + 0x34,
	unknown_last_warp_32_2 = start_live_struct + 0x24,
	x_pos_last_warp_32_2 = start_live_struct + 0x3C,
	z_pos_last_warp_32_2  = start_live_struct + 0x40,
	y_pos_last_warp_32_2  = start_live_struct + 0x44,

	map_id_stored_warp_16 = start_live_struct + 0x4C,
	x_stored_warp_16 = start_live_struct + 0x50,
	z_stored_warp_16 = start_live_struct + 0x54,
	y_stored_warp_16 = start_live_struct + 0x58,

	map_id_last_warp_from_overworld_32 = start_live_struct + 0x5C,
	unknown_last_warp_from_overworld_32 = start_live_struct + 0x60,
	x_pos_last_warp_from_overworld_32 = start_live_struct + 0x64,
	z_pos_last_warp_from_overworld_32  = start_live_struct + 0x68,
	y_pos_last_warp_from_overworld_32  = start_live_struct + 0x6C,

	maps_entered_8 = start_live_struct + 0x78, -- counts every time player changes map position in ram (in overworld, even when id remains unchanged)

	x_map_overworld_live_8 = start_live_struct + 0x7C,
	z_map_overworld_live_8 = start_live_struct + 0x7D,

	x_map_overworld_entered_1_8 = start_live_struct + 0x7E, -- updates when maps_entered_8 is set to 1
	z_map_overworld_entered_1_8 = start_live_struct + 0x7F, -- updates when maps_entered_8 is set to 1
	direction_map_entered_1_8 = start_live_struct + 0x80, -- updates when maps_entered_8 is set to 1
	unknown_entered_1_8 = start_live_struct + 0x81, -- updates when maps_entered_8 is set to 1

	x_map_overworld_entered_2_8 = start_live_struct + 0x82, -- updates when maps_entered_8 is set to 2
	z_map_overworld_entered_2_8 = start_live_struct + 0x83, -- updates when maps_entered_8 is set to 2
	direction_map_entered_2_8 = start_live_struct + 0x84, -- updates when maps_entered_8 is set to 2
	unknown_entered_2_8 = start_live_struct + 0x85, -- updates when maps_entered_8 is set to 2

	x_map_overworld_entered_3_8 = start_live_struct + 0x86, -- updates when maps_entered_8 is set to 3
	z_map_overworld_entered_3_8 = start_live_struct + 0x87, -- updates when maps_entered_8 is set to 3
	direction_map_entered_3_8 = start_live_struct + 0x88, -- updates when maps_entered_8 is set to 3
	unknown_entered_3_8 = start_live_struct + 0x89, -- updates when maps_entered_8 is set to 3

	x_map_overworld_entered_4_8 = start_live_struct + 0x8A, -- updates when maps_entered_8 is set to 4
	z_map_overworld_entered_4_8 = start_live_struct + 0x8B, -- updates when maps_entered_8 is set to 4
	direction_map_entered_4_8 = start_live_struct + 0x8C, -- updates when maps_entered_8 is set to 4
	unknown_entered_4_8 = start_live_struct + 0x8D, -- updates when maps_entered_8 is set to 4

	x_map_overworld_entered_5_8 = start_live_struct + 0x8E, -- updates when maps_entered_8 is set to 5
	z_map_overworld_entered_5_8 = start_live_struct + 0x8F, -- updates when maps_entered_8 is set to 5
	direction_map_entered_5_8 = start_live_struct + 0x90, -- updates when maps_entered_8 is set to 5
	unknown_entered_5_8 = start_live_struct + 0x91, -- updates when maps_entered_8 is set to 5

	x_map_overworld_entered_0_8 = start_live_struct + 0x92, -- updates when maps_entered_8 is set to 0
	z_map_overworld_entered_0_8 = start_live_struct + 0x93, -- updates when maps_entered_8 is set to 0
	direction_map_entered_0_8 = start_live_struct + 0x94, -- updates when maps_entered_8 is set to 0
	unknown_entered_0_8 = start_live_struct + 0x95, -- updates when maps_entered_8 is set to 0

	bike_gear_16 = start_live_struct + 0x98, -- 1 is fast, everything else slow
	unknown_mode_16 = start_live_struct + 0x9A,
	movement_mode_32 = start_live_struct + 0x9C, -- walk=0,bike=1,surf=2
	step_counter_max4_8 = start_live_struct + 0xA0, -- %4 performed
}

-- player's npc struct 
start_player_struct = data_table["player_npc_struct_offs"] -- add memory_shift

player_struct = {
	general_npc_data_ptr = start_player_struct + 0x8,
	general_player_data_ptr = start_player_struct + 0xC,
	sprite_id_32 = start_player_struct + 0x30,
	movement_32 = start_player_struct + 0x48, --crashes after 0x10
	facing_dir_32 = start_player_struct + 0x4C,
	movement_32_r = start_player_struct + 0x50,
	last_facing_dir_32 = start_player_struct + 0x54,

	-- last warp coords
	last_warp_x_32 = start_player_struct + 0x6C,
	last_warp_z_32 = start_player_struct + 0x70,
	last_warp_y_32 = start_player_struct + 0x74,

	-- final coords (updated last)
	x_32_r = start_player_struct + 0x78,
	y_32_r = start_player_struct + 0x7C,
	z_32_r = start_player_struct + 0x80,

	-- coords for interacting with terain/collision + position in ram
	x_phys_32 = start_player_struct + 0x84,
	y_phys_32 = start_player_struct + 0x88, 
	z_phys_32 = start_player_struct + 0x8C,

	-- coords used for camera position
	-- has subpixel precision
	x_cam_subpixel_16 = start_player_struct + 0x90,
	x_cam_16 = start_player_struct + 0x92,
	y_cam_subpixel_16 = start_player_struct + 0x94,
	y_cam_16 = start_player_struct + 0x96,
	z_cam_subpixel_16 = start_player_struct + 0x98,
	z_cam_16 = start_player_struct + 0x9A,

	tile_type_16_1 = start_player_struct + 0xCC,
	tile_type_16_2 = start_player_struct + 0xCE,
	sprite_ptr = start_player_struct + 0x12C,
}

start_general_npc_struct = data_table["general_npc_struct_offs"]

general_npc_struct = {
	max_npc_count = start_general_npc_struct + 0x24,
	npc_count = start_general_npc_struct + 0x28,
}

start_npc_struct = data_table["npc_struct_offs"]

generic_npc_struct = { -- -0x10 everything bitch
	sprite_id_16 = start_npc_struct + 0x10,
	obj_code_16 = start_npc_struct + 0x12,
	move_code_16 = start_npc_struct + 0x14,
	event_type_16 = start_npc_struct + 0x16,
	event_flag_16 = start_npc_struct + 0x18,
	
	event_index_16 = start_npc_struct + 0x20,
	movement_32 = start_npc_struct + 0x24, --crashes after 0x10
	facing_dir_32 = start_npc_struct + 0x28,
	movement_32_r = start_npc_struct + 0x2C,
	last_facing_dir_32 = start_npc_struct + 0x30,

	-- spawn location (?)
	x_spawn_32 = start_npc_struct + 0x4C,
	y_spawn_32 = start_npc_struct + 0x50,
	z_spawn_32 = start_npc_struct + 0x54,

	-- final coords (updated last)
	x_32 = start_npc_struct + 0x58,
	y_32 = start_npc_struct + 0x5C,
	z_32 = start_npc_struct + 0x60,

	-- coords for noticing player/talking to npc/collision
	x_phys_32 = start_npc_struct + 0x64,
	y_phys_32 = start_npc_struct + 0x68,
	z_phys_32 = start_npc_struct + 0x6C,

	-- coords used for camera position
	-- has subpixel precision
	x_cam_subpixel_16 = start_npc_struct + 0x70,
	x_cam_16 = start_npc_struct + 0x72,
	y_cam_subpixel_16 = start_npc_struct + 0x74,
	y_cam_16 = start_npc_struct + 0x76,
	z_cam_subpixel_16 = start_npc_struct + 0x78,
	z_cam_16 = start_npc_struct + 0x7A,

	tile_type_16_1 = start_npc_struct + 0xCC,
	tile_type_16_2 = start_npc_struct + 0xCE,

}

start_object_struct = data_table["object_struct_offs"]

object_struct = {
	warp_ptr_offs = start_object_struct + 0x38,
	trigger_ptr_offs = start_object_struct + 0x3C,
	object_count = start_object_struct + 0x40,
	runtime_index_32 = start_object_struct + 0x44,
	x_phys_32 = start_object_struct + 0x48,
	z_phys_32 = start_object_struct + 0x4C,
	y_phys_32 = start_object_struct + 0x50,
	unknown_32 = start_object_struct + 0x54
}

warp_struct = {
	warp_count = -0x4,
	x_phys_16 = 0x0,
	z_phys_16 = 0x2,
	map_id_16 = 0x4,
	warp_index_at_map_id_16 = 0x6, -- the index of the warp you will get out of at the map you teleport to
	unknown_32 = 0x8
}

trigger_struct = {
	trigger_count = -0x4,
	unknown_16 = 0x0,
	x_phys_16 = 0x2,
	z_phys_16 = 0x4,
	vert_count_16 = 0x6,
	hor_count_16 = 0x8,
	unknown_2_16 = 0xA,
	flag_index_32 = 0xC, -- not 100% certain
}


chunk_struct = {
	pointer_32 = 0x0,
	buffer_1 = {},
	buffer_2 = {},
	buffer_3 = {},
	buffer_4 = {},
	
	chunk_pointer_offs = {0x90,0x94,0x98,0x9C},
	current_chunk_8 = 0xAC,
	current_subchunk_8 = 0xAD,
	x_target_subpixel_16 = 0xCC,
	x_target_16 = 0xCE,
	y_target_subpixel_16 = 0xD0,
	y_target_16 = 0xD2,
	z_target_subpixel_16 = 0xD4,
	z_target_16 = 0xD6,
	load_state = 0xE4,
	
	
}

chunk_buffer_struct = {

}
start_item_struct = data_table["item_struct_offs"]

item_pocket_struct = {
	{"items_pocket",start_item_struct, start_item_struct + 0x294},
	{"medicine_pocket",start_item_struct + 0x51C,start_item_struct + 0x5BC},
	{"balls_pocket",start_item_struct + 0x6BC,start_item_struct + 0x6F8},
	{"tms_hms_pocket",start_item_struct + 0x35C,start_item_struct + 0x4EC},	
	{"berries_pocket",start_item_struct + 0x5BC,start_item_struct + 0x6BC},
	{"mails_pocket",start_item_struct + 0x4EC, start_item_struct + 0x5BC},
	{"battle_items_pocket",start_item_struct + 0x6F8,start_item_struct + 0x9A1},
	{"key_items_pocket",start_item_struct + 0x294,start_item_struct + 0x35C}
}

selected_key_item = start_item_struct + 0xC25


item_struct = {
	item_id = 0x0,
	item_count = 0x4
}

start_ug_circle_struct = data_table["ug_revealing_circle_struct_offs"]

ug_circle_struct = {
	x_center_circle_32 = start_ug_circle_struct + 0x40,
	z_center_circle_32 = start_ug_circle_struct + 0x44,
	x_subpixel_center_circle_32 = start_ug_circle_struct + 0x48,
	z_subpixel_center_circle_32 = start_ug_circle_struct + 0x4C,
	anime_frame_count = start_ug_circle_struct + 0x50,

}

start_ug_gem_struct = data_table["ug_gem_struct_offs"]

ug_gem_struct = {
	x_phys_16 = start_ug_gem_struct,
	z_phys_16 = start_ug_gem_struct+0x2,
	unknown_16 = start_ug_gem_struct+0x4, -- something to do with interacting, crashes at 0xffff

}

start_ug_trap_struct = data_table["ug_trap_struct_offs"]

ug_trap_struct = {
	x_phys_16 = start_ug_trap_struct,
	z_phys_16 = start_ug_trap_struct+0x2,
	trap_type_id_8 = start_ug_trap_struct+0x4,
	trap_array_id_8 = start_ug_trap_struct+0x5, 
}

start_ug_excavation_minigame = data_table["ug_excavation_minigame_offs"]

ug_excavation_minigame_struct = {
	tiles_start = start_ug_excavation_minigame,
	play_state = start_ug_excavation_minigame + 0x82, -- playing=0x8,win/loss=0x0
	leftover_taps_8 = start_ug_excavation_minigame + 0x89,
	screen_offs_32 = start_ug_excavation_minigame + 0x8A, -- for the shaking effect when tapping
}

start_matrix_struct = data_table["matrix_struct_offs"]

matrix_struct = {
	matrix_width_8 = start_matrix_struct + 0x54,
	matrix_height_8 = start_matrix_struct + 0x55,
	matrix_center_16 = start_matrix_struct + 0x56,
}

start_mapdata_and_menu_struct = data_table["mapdata_and_menu_struct_offs"]

mapdata_and_menu_struct = {
	side_menu_state = start_mapdata_and_menu_struct + 0x78,
	menu_index = start_mapdata_and_menu_struct + 0xF4,
}

hovering_item_struct = {
	hovering_item_text_pointer = 0x358,
	hovering_item_id = 0x360,
	unknown_16 = 0x362,
	cursor_offset_16 = 0x364,
}

script_execution_struct = {
	opcode_pointer = data_table["opcode_pointer"]
}

start_hall_of_fame_struct = data_table["hall_of_fame_struct_offs"]
start_species_struct = 0x20

hall_of_fame_struct = {
	specie_struct = {
		species_id_16 = 0x4,
		level_16 = 0x6,
		pid_32 = 0x8,
		tid_16 = 0xC,
		sid_16 = 0xE,
		poke_name = 0x10,
		trainer_name = 0x26,
		move_1_16 = 0x36,
		move_2_16 = 0x38,
		move_3_16 = 0x3A,
		move_4_16 = 0x3C,
		dummy_16 = 0x3E
		},
	year_16 = 0x168,
	month_8 = 0x18A,
	day_8 = 0x18C
}

-- Toggles

map_editing =  false 

function toggle_map_editing()
	map_editing = not map_editing 
	temp_map_id = ""
end

-- Continue run based on toggles

function change_map_id()
	value = check_btn_ints()
	if value ~= nil then 
		temp_map_id = temp_map_id..value
		memory.write_u16_le(base + live_struct["map_id_32"],tonumber(temp_map_id))
		print(temp_map_id)
	end
	if (#temp_map_id > 4) or (key.enter) then
		temp_map_id = tonumber(temp_map_id)
		if temp_map_id > 65535 then
			temp_map_id = 65535
		end 
		mainmemory.write_u16_le(base + live_struct["map_id_32"] - 0x2000000,temp_map_id)
		map_editing = false
	end
end 



function get_memory_state()
	if memory.read_u32_le(base+data_table["memory_state_check_offs"]) == (base + data_table["memory_state_check_val"]) then -- check for ug/bt ptr
		if memory.read_s8(data_table["ug_init_addr"]) == data_table["ug_init_val"] then -- if 0x1f, is UG
			return "UG"
		end
		return "BT" 
	end 
	return "OW"
end


function fmt(arg,len)
    return string.format("%0"..len.."X", bit.band(4294967295, arg))
end

key = {}
last_key = {}
joy = {}
last_joy = {}
analog = {}
last_analog = {}

function get_keys()
	last_key = key
	key = input.get()
end

function check_keys(btns)
	pressed_key_count = 0
	not_prev_held = false
	for btn =1,#btns do
		if key[btns[btn]] then 	
				pressed_key_count = pressed_key_count + 1
		end 
		if not last_key[btns[btn]] then
			not_prev_held = true -- check if at least 1 button wasn't previously held
		end 
	end
	if not_prev_held then
		return pressed_key_count
	end 
end 

function check_any_key(btns)
	for i= 1,#btns do
		if check_key(btns[i]) then return btns[i] end 
	end  
	return nil
end 

function check_btn_ints()
	for i=0,9 do
		if check_key(""..i) or check_key("Number"..i) then return i end 
	end 
end

function check_key(btn)
	if key[btn] and not last_key[btn] then
		return true
	else
		return false
	end
end

function get_joy()
	last_joy = joy
	joy = joypad.get()
end 

function wait_frames(frames)
	current_frame = emu.framecount()
	target_frame = current_frame + frames
	while current_frame < target_frame do
		draw_main()
		emu.frameadvance()
		current_frame = emu.framecount()
		if current_frame == 0 then
		 	break
		end 
	end 
end

function press_button(btn,frames)
	frames = frames or 2
	current_frame = emu.framecount()
	target_frame = current_frame + frames
	while current_frame ~= target_frame do
		joy[btn] = true 
		joypad.set(joy)
		emu.frameadvance()
		current_frame = emu.framecount()
	end 
	joy[btn] = false
end 

function press_buttons(btns,frames)
	frames = frames or 2
	current_frame = emu.framecount()
	target_frame = current_frame + frames
	while current_frame < target_frame do
		for i = 1,#btns do
			joy[btns[i]] = true
		end 
		joypad.set(joy)
		emu.frameadvance()
		current_frame = emu.framecount()
	end 
	for btn = 1,#btns do
		joy[btn] = false
	end 
end 	

function mash_button(btn,frames)
	c_frame_mash = emu.framecount()
	target_frame_mash = c_frame_mash+ frames
	
	while c_frame_mash < target_frame_mash do
		press_button(btn)
		wait_frames(2)
		c_frame_mash = emu.framecount()
	end 
end

function tap_touch_screen(x_,y_,frames)
	current_frame = emu.framecount()
	target_frame = current_frame + frames
	while current_frame < target_frame do
		draw_main()
		analog.TouchX = x_
		analog.TouchY = y_
		joy.Touch = true
		joypad.set(joy)
		joypad.setanalog(analog)
		emu.frameadvance()
		current_frame = emu.framecount()
	end 
	joy.Touch = false
	joypad.set(joy)
end

-- MOVEMENT FUNCTIONS

collision_states = {
	[0x1000] = 0x1C20,
	[0x1C20] = 0x1000
}

function switch_wtw_state()
	current_collision_state = memory.read_u16_le(lang_data["collision_check_addr"])
	memory.write_u16_le(lang_data["collision_check_addr"],collision_states[current_collision_state])
end

function set_stepcounter(steps)
	step_addr = base+live_struct["step_counter"]
	memory.writ_u16_le(step_addr,0)
end 

function clear_stepcounter()
	tap_touch_screen(115,120,1)
end 

calc_x_start = 33
calc_y_start = 48

calc_x_pos = {["0"]=50,["1"]=50,["2"]=80,["3"]=110,["4"]=50,["5"]=80,["6"]=110,["7"]=50,["8"]=80,["9"]=110,["+"]=140,["-"]=170,["x"]=140,["*"]=140,["/"]=170,["C"]=150,["."]=110,["="]=160,}
calc_y_pos = {["0"]=160,["1"]=125,["2"]=125,["3"]=125,["4"]=90,["5"]=90,["6"]=90,["7"]=60,["8"]=60,["9"]=60,["+"]=90,["-"]=90,["x"]=125,["*"]=125,["/"]=125,["C"]=60,["."]=160,["="]=160,}

function write_calc_input(input_str) -- input in str form
	for i = 1,#input_str do 
		-- gui.text(50,10,"test "..string.sub(input_str,i,i),"red")
		tap_touch_screen(calc_x_pos[string.sub(input_str,i,i)],calc_y_pos[string.sub(input_str,i,i)],2)
		wait_frames(2)
	end 
	use_menu(8)

end 

function use_menu(menu_index)
	if memory.read_u16_le(base + mapdata_and_menu_struct["side_menu_state"]) == 0 then	
		press_button("X")
	end 
	
	current_menu_index = memory.read_u8(base + mapdata_and_menu_struct["menu_index"])

	if menu_index == current_menu_index then 
		wait_frames(4)
		press_button("A")
	elseif menu_index > current_menu_index then 
		btn = "down"
	else
		btn = "up"
	end 

	while menu_index ~= current_menu_index do
		press_button(btn)
		wait_frames(2)
		current_menu_index = memory.read_u8(base + mapdata_and_menu_struct["menu_index"])
	end 
	press_button("A")
end

function draw_inputs()
	ctr = 0
	for k,v in pairs(joy) do
		ctr = ctr+1
		-- sc_canvas.DrawText(5,20+ctr*12,"'"..k.."' :"..tostring(v),'black','')
		gui.text(5,20+ctr*14,"'"..k.."' :"..tostring(v))
	end 
end 

function check_bike_state()
	bike_state = 0
	if memory.read_u16_le(base+live_struct["movement_mode_32"]) == 1 then -- on bike
		bike_state = bike_state + 1
		if memory.read_u16_le(base+live_struct["bike_gear_16"]) == 1 then -- fast gear
			bike_state = 2
		end
	else 
		if memory.read_u16_le(base+live_struct["bike_gear_16"]) == 1 then -- fast gear, but walking
			bike_state = 4
		end	
	end 	
	return bike_state
end 

function get_on_bike(bike_gear,init_wait)
	init_wait = init_wait or 4
	bike_gear = bike_gear or 1
	init_wait = init_wait or 4
	wait_frames(init_wait)

	if check_bike_state() == 0 then -- walking, slow bike
		press_button("Y")
		wait_frames(8)
		if bike_gear == 1 then 
			press_button("B")
			wait_frames(8)
		end
		return
	end
	if check_bike_state() == 1 then -- on bike, slow bike
		if bike_gear == 1 then
			press_button("B")
		end 
		return
	end 
	if check_bike_state() == 2 then --on bike, fast bike
		if bike_gear == 0 then
			press_button("B")
		end 
		return
	end 
	if check_bike_state() == 4 then -- walking, fast bike
		press_button("Y")
		wait_frames(8)
		if bike_gear == 0 then 
			press_button("B")
			wait_frames(8)
		end
		return
	end
end

function move_player(pos,target,pos_offs,j_up,j_down,j_left,j_right)
	print(pos.." "..target)
	while pos ~= target do
		joy.Up = j_up
		joy.Down = j_down
		joy.Left = j_left
		joy.Right = j_right
		joypad.set(joy)
		joy = {}
		emu.frameadvance()
		pos = memory.read_u32_le(base + pos_offs)
	end
end 

function return_arg(input,other)
	if input == "false" then
			return false
		end
	return other
end


debug = true 

function debug_print(text)
	if debug then print(text) end 
end 

show_steps = true 

function up(steps,delay_before_reset,delay_after_reset,reset_stepcounter)
	if show_steps then debug_print(steps.." N") end
	delay_before_reset = delay_before_reset or 2
	delay_after_reset = delay_after_reset or 4
	reset_stepcounter = return_arg(reset_stepcounter,true)

	player_pos_y = memory.read_u32_le(base + live_struct["z_pos_32_r"])
	target = player_pos_y - steps

	-- account for bike momentum
	if check_bike_state() == 2 then
		if steps > 3 then 
			target = target + 2
		end
	end 

	if target < 0 then
		target = 4294967295 + target + 1
	end
	
	move_player(player_pos_y,target,live_struct["z_pos_32_r"],true)
	if reset_stepcounter then
		wait_frames(delay_before_reset*30)
		clear_stepcounter()
	end 
	wait_frames(delay_after_reset*30)
end

function left(steps,delay_before_reset,delay_after_reset,reset_stepcounter)
	if show_steps then debug_print(steps.." W") end
	delay_before_reset = delay_before_reset or 2
	delay_after_reset = delay_after_reset or 4
	reset_stepcounter = return_arg(reset_stepcounter,true)

	player_pos_x = memory.read_u32_le(base + live_struct["x_pos_32_r"])
	target = player_pos_x - steps

	-- account for bike momentum
	if check_bike_state() == 2 then
		if steps > 3 then 
			target = target + 2
		end
	end 

	if target < 0 then
		target = 4294967295 + target + 1
	end 

	move_player(pos,target,live_struct["x_pos_32_r"],false,false,true)
	
	if reset_stepcounter then
		wait_frames(delay_before_reset*30)
		clear_stepcounter()
	end 
	wait_frames(delay_after_reset*30)
end

function down(steps,delay_before_reset,delay_after_reset,reset_stepcounter)
	if show_steps then debug_print(steps.." S") end
	delay_before_reset = delay_before_reset or 2
	delay_after_reset = delay_after_reset or 4
	reset_stepcounter = return_arg(reset_stepcounter,true)

	player_pos_y = memory.read_u32_le(base + live_struct["z_pos_32_r"])
	target = (player_pos_y + steps)%4294967296

	-- account for bike momentum
	if check_bike_state() == 2 then
		if steps > 3 then 
			target = target - 2	
		end 
	end
	move_player(pos,target,live_struct["z_pos_32_r"],false,true)
	if reset_stepcounter then
		wait_frames(delay_before_reset*30)
		clear_stepcounter()
	end 
	wait_frames(delay_after_reset*30)
end

function right(steps,delay_before_reset,delay_after_reset,reset_stepcounter)
	if show_steps then debug_print(steps.." E") end
	delay_before_reset = delay_before_reset or 2
	delay_after_reset = delay_after_reset or 4
	reset_stepcounter = return_arg(reset_stepcounter,true)

	player_pos_x = memory.read_u32_le(base + live_struct["x_pos_32_r"])
	target = (player_pos_x + steps)%4294967296

	-- account for bike momentum
	if check_bike_state() == 2 then
		if steps > 3 then 
			target = target - 2
		end 
	end 

	move_player(pos,target,live_struct["x_pos_32_r"],false,false,false,true)
	if reset_stepcounter then
		wait_frames(delay_before_reset*30)
		clear_stepcounter()
	end 
	wait_frames(delay_after_reset*30)
end

function auto_movement()
	-- get_on_bike()
	up(20)
end 

function auto_calculate()
	write_calc_input("C8271346336*17498968=")
	write_calc_input("7484379116*799185216=") 
	write_calc_input("567939497461504x1=")    
	write_calc_input("5188714710245050112x1=")
	write_calc_input("567939531015936x1=")
	write_calc_input("5116657116240676608x1=")
	write_calc_input("649086285905921792x1=")
	write_calc_input("567939581347584x1=")
	write_calc_input("567939598124800x1=")
	write_calc_input("144683127690757888x1=")
	write_calc_input("216740721745463040x1=")
	write_calc_input("2450526136938006272x1=")
	write_calc_input("649086286006585088x1=")
	write_calc_input("5404887492526606080x1=")
	write_calc_input("2234353354874554112x1=")
	write_calc_input("2378468542967187200x1=")
	write_calc_input("1874065384718468864x1=")
	write_calc_input("9223939976603895552x1=")
	write_calc_input("9223939976620672768x1=")
	write_calc_input("2522583731110151936x1=")
	write_calc_input("9223939976654227200x1=")
	write_calc_input("2450526137105778432x1=")
	write_calc_input("15781181034139223808x1=")
	write_calc_input("288798316001494784x1=")
	write_calc_input("10520976669404038912x1=")
	write_calc_input("144683127959193344x1=")
	write_calc_input("1874065384886241024x1=")
	write_calc_input("6918096967557973760x1=")
	write_calc_input("567939933669120x1=")
	write_calc_input("2450526137239996160x1=")
	write_calc_input("360855910156863232x1=")
	write_calc_input("5404887492828595968x1=")
	write_calc_input("1874065384986904320x1=")
	write_calc_input("8071018472265484032x1=")
	write_calc_input("14988547499923343104x1=")
	write_calc_input("2450526137340659456x1=")
	write_calc_input("360855910257526528x1=")
	write_calc_input("5404887492929259264x1=")
	write_calc_input("15132662688066307840x1=")
	write_calc_input("288798316269930240x1=")
	write_calc_input("1802007791083194112x1=")
	write_calc_input("9223939977006548736x1=")
	write_calc_input("144683128244406016x1=")
	write_calc_input("4251965988423075584x1=")
	write_calc_input("10593034263777511168x1=")
	write_calc_input("4756369146722125568x1=")
	write_calc_input("18087024043755570944x1=")
	write_calc_input("15060605094179374848x1=")
	write_calc_input("18303196825902909184x1=")
	write_calc_input("16645872163047343872x1=")
	write_calc_input("288798316454479616x1=")
	write_calc_input("216740722433328896x1=")
	write_calc_input("567940336322304x1=")
	write_calc_input("288798316504811264x1=")
	write_calc_input("4612253958797264640x1=")
	write_calc_input("144683128462509824x1=")
	write_calc_input("567940403431168x1=")
	write_calc_input("288798316571920128x1=")
	write_calc_input("567940436985600x1=")
	write_calc_input("9223939977308538624x1=")
	write_calc_input("9295997571363243776x1=")
	write_calc_input("432913504714884864x1=")
	write_calc_input("147968x1=")
	print("done")
end 

tp_amount = 31

function teleport_up()
	z_phys_32 = memory.read_u32_le(base + player_struct["z_phys_32"] + memory_shift)
	memory.write_u32_le(base + player_struct["z_phys_32"] + memory_shift,z_phys_32 - tp_amount) 
	z_cam_16 = memory.read_u16_le(base + player_struct["z_cam_16"] + memory_shift)
	memory.write_u16_le(base + player_struct["z_cam_16"] + memory_shift,z_cam_16 - tp_amount) 
end

function teleport_left()
	x_phys_32 = memory.read_u32_le(base + player_struct["x_phys_32"] + memory_shift)
	memory.write_u32_le(base + player_struct["x_phys_32"] + memory_shift,x_phys_32 - tp_amount) 
	x_cam_16 = memory.read_u16_le(base + player_struct["x_cam_16"] + memory_shift)
	memory.write_u16_le(base + player_struct["x_cam_16"] + memory_shift,x_cam_16 - tp_amount) 
end

function teleport_right()
	x_phys_32 = memory.read_u32_le(base + player_struct["x_phys_32"] + memory_shift)
	memory.write_u32_le(base + player_struct["x_phys_32"] + memory_shift,x_phys_32 + tp_amount) 
	x_cam_16 = memory.read_u16_le(base + player_struct["x_cam_16"] + memory_shift)
	memory.write_u16_le(base + player_struct["x_cam_16"] + memory_shift,x_cam_16 + tp_amount)
end

function teleport_down()
	z_phys_32 = memory.read_u32_le(base + player_struct["z_phys_32"] + memory_shift)
	memory.write_u32_le(base + player_struct["z_phys_32"] + memory_shift,z_phys_32 + tp_amount) 
	z_cam_16 = memory.read_u16_le(base + player_struct["z_cam_16"] + memory_shift)
	memory.write_u16_le(base + player_struct["z_cam_16"] + memory_shift,z_cam_16 + tp_amount) 
end

key_configuration = {
	-- switch_wtw_state = {"W"},
	switch_wtw_state = {"Z"},
	toggle_map_editing = {"M"},
	toggle_map_editing = {"Semicolon"},
	auto_movement = {"Shift","M"},
	auto_movement = {"Shift","Semicolon"},
	auto_calculate = {"Shift","C"},
	teleport_up = {"Shift","Up"},
	teleport_left = {"Shift","Left"},
	teleport_down = {"Shift","Down"},
	teleport_right = {"Shift","Right"},
}

function run_functions_on_keypress()
	for funct,config_keys in pairs(key_configuration) do
		if check_keys(config_keys) == #config_keys then
			loadstring(funct.."()")()
		end 
	end
end

function run_functions()
	if map_editing then change_map_id() end 
end 


function main()
	emu.frameadvance()
	base = memory.read_u32_le(lang_data["base_addr"]) -- check base every loop in case of reset
	memory_state = get_memory_state() -- check for underground,battletower or overworld state (add: intro?)
	memory_shift = data_table["memory_shift"][memory_state] -- get memory shift based on state


	get_keys()
	get_joy()
	draw_main()
	run_functions_on_keypress()
	run_functions()
end 

function draw_main()
	gui.text(5,10,fmt(base,8))
	draw_inputs()
end

while true do main() end


