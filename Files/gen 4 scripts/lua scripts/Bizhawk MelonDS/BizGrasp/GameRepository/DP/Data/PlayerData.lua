PlayerData = {

}

function PlayerData:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PlayerData:update()
    self.startNPCstruct = MemoryState.base + 0x24A14 + MemoryState.memoryOffset

    self.NPCstruct = {
        general_npc_data_ptr = memory.read_u32_le(self.startNPCstruct + 0x8),
        general_player_data_ptr = memory.read_u32_le(self.startNPCstruct + 0xC),
        sprite_id_32 = memory.read_u32_le(self.startNPCstruct + 0x30),
        movement_32 = memory.read_u32_le(self.startNPCstruct + 0x48), --crashes after 0x10
        facing_dir_32 = memory.read_u32_le(self.startNPCstruct + 0x4C),
        movement_32_r = memory.read_u32_le(self.startNPCstruct + 0x50),
        last_facing_dir_32 = memory.read_u32_le(self.startNPCstruct + 0x54),
    
        -- last warp coords
        last_warp_x_32 = memory.read_u32_le(self.startNPCstruct + 0x6C),
        last_warp_z_32 = memory.read_u32_le(self.startNPCstruct + 0x70),
        last_warp_y_32 = memory.read_u32_le(self.startNPCstruct + 0x74),
    
        -- final coords (updated last)
        x_32_r = memory.read_u32_le(self.startNPCstruct + 0x78),
        y_32_r = memory.read_u32_le(self.startNPCstruct + 0x7C),
        z_32_r = memory.read_u32_le(self.startNPCstruct + 0x80),
    
        -- coords for interacting with terain/collision + position in ram
        x_phys_32 = memory.read_u32_le(self.startNPCstruct + 0x84),
        y_phys_32 = memory.read_u32_le(self.startNPCstruct + 0x88),
        z_phys_32 = memory.read_u32_le(self.startNPCstruct + 0x8C),
    
        -- coords used for camera position
        -- has subpixel precision
        x_cam_subpixel_16 = memory.read_u16_le(self.startNPCstruct + 0x90),
        x_cam_16 = memory.read_u16_le(self.startNPCstruct + 0x92),
        y_cam_subpixel_16 = memory.read_u16_le(self.startNPCstruct + 0x94),
        y_cam_16 = memory.read_u16_le(self.startNPCstruct + 0x96),
        z_cam_subpixel_16 = memory.read_u16_le(self.startNPCstruct + 0x98),
        z_cam_16 = memory.read_u16_le(self.startNPCstruct + 0x9A),
    
        tile_type_16_1 = memory.read_u16_le(self.startNPCstruct + 0xCC),
        tile_type_16_2 = memory.read_u16_le(self.startNPCstruct + 0xCE),
        sprite_ptr = memory.read_u32_le(self.startNPCstruct + 0x12C)
    }
end