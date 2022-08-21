PlayerData = {

}

function PlayerData:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PlayerData:update()
    self.startPlayerNPCstruct = MemoryState.base + 0x24A14

    self.playerNPCstruct = {
        general_npc_data_ptr = memory.read_u32_le(self.startPlayerNPCstruct + 0x8),
        general_player_data_ptr = memory.read_u32_le(self.startPlayerNPCstruct + 0xC),
        sprite_id_32 = memory.read_u32_le(self.startPlayerNPCstruct + 0x30),
        movement_32 = memory.read_u32_le(self.startPlayerNPCstruct + 0x48), --crashes after 0x10
        facing_dir_32 = memory.read_u32_le(self.startPlayerNPCstruct + 0x4C),
        movement_32_r = memory.read_u32_le(self.startPlayerNPCstruct + 0x50),
        last_facing_dir_32 = memory.read_u32_le(self.startPlayerNPCstruct + 0x54),
    
        -- last warp coords
        last_warp_x_32 = memory.read_u32_le(self.startPlayerNPCstruct + 0x6C),
        last_warp_z_32 = memory.read_u32_le(self.startPlayerNPCstruct + 0x70),
        last_warp_y_32 = memory.read_u32_le(self.startPlayerNPCstruct + 0x74),
    
        -- final coords (updated last)
        x_32_r = memory.read_u32_le(self.startPlayerNPCstruct + 0x78),
        y_32_r = memory.read_u32_le(self.startPlayerNPCstruct + 0x7C),
        z_32_r = memory.read_u32_le(self.startPlayerNPCstruct + 0x80),
    
        -- coords for interacting with terain/collision + position in ram
        x_phys_32 = memory.read_u32_le(self.startPlayerNPCstruct + 0x84),
        y_phys_32 = memory.read_u32_le(self.startPlayerNPCstruct + 0x88),
        z_phys_32 = memory.read_u32_le(self.startPlayerNPCstruct + 0x8C),
    
        -- coords used for camera position
        -- has subpixel precision
        x_cam_subpixel_16 = memory.read_u16_le(self.startPlayerNPCstruct + 0x90),
        x_cam_16 = memory.read_u16_le(self.startPlayerNPCstruct + 0x92),
        y_cam_subpixel_16 = memory.read_u16_le(self.startPlayerNPCstruct + 0x94),
        y_cam_16 = memory.read_u16_le(self.startPlayerNPCstruct + 0x96),
        z_cam_subpixel_16 = memory.read_u16_le(self.startPlayerNPCstruct + 0x98),
        z_cam_16 = memory.read_u16_le(self.startPlayerNPCstruct + 0x9A),
    
        tile_type_16_1 = memory.read_u16_le(self.startPlayerNPCstruct + 0xCC),
        tile_type_16_2 = memory.read_u16_le(self.startPlayerNPCstruct + 0xCE),
        sprite_ptr = memory.read_u32_le(self.startPlayerNPCstruct + 0x12C)
    }
end

-- PlayerData = {
--     startPlayerNPCStruct = 0x24A14,

--     playerNPCStruct = {
--         general_npc_data_ptr = {0x8,32},
--         general_player_data_ptr = {0xC,32},
--         sprite_id_32 = {0x30,32},
--         movement_32 = {0x48,32}, --crashes after 0x10
--         facing_dir_32 = {0x4C,32},
--         movement_32_r = {0x50,32},
--         last_facing_dir_32 = {0x54,32},
    
--         -- last warp coords
--         last_warp_x_32 = {0x6C,32},
--         last_warp_z_32 = {0x70,32},
--         last_warp_y_32 = {0x74,32},
    
--         -- final coords (updated last)
--         x_32_r = {0x78,32},
--         y_32_r = {0x7C,32},
--         z_32_r = {0x80,32},
    
--         -- coords for interacting with terain/collision + position in ram
--         x_phys_32 = {0x84,32},
--         y_phys_32 = {0x88,32},
--         z_phys_32 = {0x8C,32},
    
--         -- coords used for camera position
--         -- has subpixel precision
--         x_cam_subpixel_16 = {0x90,16},
--         x_cam_16 = {0x92,16},
--         y_cam_subpixel_16 = {0x94,16},
--         y_cam_16 = {0x96,16},
--         z_cam_subpixel_16 = {0x98,16},
--         z_cam_16 = {0x9A,16},
    
--         tile_type_16_1 = {0xCC,16},
--         tile_type_16_2 = {0xCE,16},
--         sprite_ptr = {0x12C,32},
--     }

--     startplayerStruct = 0x1440

--     playerStruct = {
--         map_id_32 = {0xC,32}
--         unknown_32 = {0x10,32}
--         x_pos_32_r = {0x14,32}
--         z_pos_32_r = {0x18,32}
--         y_pos_32_r = {0x1C,32}
    
--         map_id_last_warp_32 = {0x20,32}
--         unknown_last_warp_32 = {0x24,32}
--         x_pos_last_warp_32 = {0x28,32}
--         z_pos_last_warp_32  = {0x2C,32}
--         y_pos_last_warp_32  = {0x30,32}
    
--         map_id_last_warp_32 = {0x34,32}
--         unknown_last_warp_32_2 = {0x24,32}
--         x_pos_last_warp_32_2 = {0x3C,32}
--         z_pos_last_warp_32_2  = {0x40,32}
--         y_pos_last_warp_32_2  = {0x44,32}
    
--         map_id_stored_warp_16 = {0x4C,16}
--         x_stored_warp_16 = {0x50,16}
--         z_stored_warp_16 = {0x54,16}
--         y_stored_warp_16 = {0x58,16}
    
--         map_id_last_warp_from_overworld_32 = {0x5C,32}
--         unknown_last_warp_from_overworld_32 = {0x60,32}
--         x_pos_last_warp_from_overworld_32 = {0x64,32}
--         z_pos_last_warp_from_overworld_32  = {0x68,32}
--         y_pos_last_warp_from_overworld_32  = {0x6C,32}
    
--         maps_entered_8 = {0x78,8} -- counts every time player changes map position in ram (in overworld, even when id remains unchanged)
    
--         x_map_overworld_live_8 = {0x7C,8}
--         z_map_overworld_live_8 = {0x7D,8}
    
--         x_map_overworld_entered_1_8 = {0x7E,8} -- updates when maps_entered_8 is set to 1
--         z_map_overworld_entered_1_8 = {0x7F,8} -- updates when maps_entered_8 is set to 1
--         direction_map_entered_1_8 = {0x80,8} -- updates when maps_entered_8 is set to 1
--         unknown_entered_1_8 = {0x81,8} -- updates when maps_entered_8 is set to 1
    
--         x_map_overworld_entered_2_8 = {0x82,8} -- updates when maps_entered_8 is set to 2
--         z_map_overworld_entered_2_8 = {0x83,8} -- updates when maps_entered_8 is set to 2
--         direction_map_entered_2_8 = {0x84,8} -- updates when maps_entered_8 is set to 2
--         unknown_entered_2_8 = {0x85,8} -- updates when maps_entered_8 is set to 2
    
--         x_map_overworld_entered_3_8 = {0x86,8} -- updates when maps_entered_8 is set to 3
--         z_map_overworld_entered_3_8 = {0x87,8} -- updates when maps_entered_8 is set to 3
--         direction_map_entered_3_8 = {0x88,8} -- updates when maps_entered_8 is set to 3
--         unknown_entered_3_8 = {0x89,8} -- updates when maps_entered_8 is set to 3
    
--         x_map_overworld_entered_4_8 = {0x8A,8} -- updates when maps_entered_8 is set to 4
--         z_map_overworld_entered_4_8 = {0x8B,8} -- updates when maps_entered_8 is set to 4
--         direction_map_entered_4_8 = {0x8C,8} -- updates when maps_entered_8 is set to 4
--         unknown_entered_4_8 = {0x8D,8} -- updates when maps_entered_8 is set to 4
    
--         x_map_overworld_entered_5_8 = {0x8E,8} -- updates when maps_entered_8 is set to 5
--         z_map_overworld_entered_5_8 = {0x8F,8} -- updates when maps_entered_8 is set to 5
--         direction_map_entered_5_8 = {0x90,8} -- updates when maps_entered_8 is set to 5
--         unknown_entered_5_8 = {0x91,8} -- updates when maps_entered_8 is set to 5
    
--         x_map_overworld_entered_0_8 = {0x92,8} -- updates when maps_entered_8 is set to 0
--         z_map_overworld_entered_0_8 = {0x93,8} -- updates when maps_entered_8 is set to 0
--         direction_map_entered_0_8 = {0x94,8} -- updates when maps_entered_8 is set to 0
--         unknown_entered_0_8 = {0x95,8} -- updates when maps_entered_8 is set to 0
    
--         bike_gear_16 = {0x98,16} -- 1 is fast, everything else slow
--         unknown_mode_16 = {0x9A,16}
--         movement_mode_32 = {0x9C,16} -- walk=0,bike=1,surf=2
--         step_counter_max4_8 = {0xA0,16} -- %4 performed
--     }
-- }
