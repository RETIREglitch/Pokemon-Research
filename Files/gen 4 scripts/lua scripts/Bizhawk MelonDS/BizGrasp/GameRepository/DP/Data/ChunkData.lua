ChunkData = {
    tileData = {
        grass = {
            color = 0x80FF20,
            ids = {0x2,0x7B}
        },
        default = {
            color = 0x666666,
            ids = {0xFF,0x0}
        },
        warps = {
            color = 0xFF0000,
            ids ={0x5E,0x5f,0x62,0x63,0x69,0x65,0x6f,0x6D,0x6A,0x6C,0x6E}
        },
        cave = {
            color = 0xBB7410,
            ids = {0x6,0x8,0xC}
        },
        water = {
            color = 0x4888F0,
            ids = {0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x19,0x22,0x2A,0x7C}
        },
        sand = {
            color = 0xE3C000,
            ids = {0x21,0x21}
        },
        deep_snow1 = {
            color = 0x8DA9CB,
            ids = {0xA1}
        },
        deep_snow2 = {
            color = 0x6483A7,
            ids = {0xA2}
        },
        deep_snow3 = {
            color = 0x52749D,
            ids = {0xA3}
        },
        mud = {
            color = 0x928970,
            ids = {0xA4}
        },
        mud_block = {
            color = 0x927040,
            ids = {0xA5}
        },
        mud_grass = {
            color = 0x409000,
            ids = {0xA6}
        },
        mud_grass_block = {
            color = 0x559060,
            ids = {0xA7}
        },
        snow = {
            color = 0xB9D0EB,
            ids = {0xA8}
        },
        tall_grass = {
            color = 0x2AA615,
            ids = {0x3}		
        },
        misc_obj = {
            color = 0xFFFFFF,
            ids = {0xE5,0X8E,0X8f}
        },
        spin_tile = {
            color = 0xFFD000,
            ids = {0x40,0x41,0x42,0x43}
        },
        ice = {
            color = 0x56B3E0,
            ids = {0x20,0x20}
        },
        ice_stair = {
            color = 0xFFD000,
            ids = {0x49,0x4A}
        },
        circle_warp = {
            color = 0xA0A000,
            ids = {0x67}
        },
        model_fl = {
            color = 0xAFB000,
           ids = {0x56,0x57,0x58,} 
        },
        model_floor = {
            color = 0xA090F0,
           ids = {0x59}
        },
        special_collision = {
            color = 0xA090F0,
           ids = {0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37}
        },
        bike_stall = {
            color = 0x0690A0,
           ids = {0xDB}
        },
        counter = {
            color = 0xf7A00,
            ids = {0x80}
        },
        pc = {
           color = 0x0690B0,
           ids = {0x83}
        },
        map = {
           color = 0x00EEE0,
           ids = {0x85}
        },
        tv = {
           color = 0x4290E0,
           ids = {0x86}
        },
        bookcases = {
            color = 0x0DDD70,
            ids = {0x88,0xE1,0xE0,0xE2}
        },
        bin = {
            color = 0x06B040,
           ids = {0xE4}
        },
        haunted_house = {
            color = 0xA292BC,
            ids = {0xB}
        },
        ledge = {
            color = 0xD3A000,
            ids = {0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F}
        },
        rock_climb = {
            color = 0xC76000,
            ids = {0x4B,0x4C}
        },
        bridge = {
            color = 0xC79000,
            ids = {0x71,0x72,0x73,0x74,0x75}
        },
        start_bridge = {
            color= 0xC7B000, 
            ids = {0x70}
        },
        bike_bridge = {
            color = 0xC7A55,
            ids = {0x76,0x77,0x78,0x79,0x7A,0x7D}
            -- 0x7C moves to water, 0x7B moved to grass
        },
        soil = {
            color = 0xB27030,
            ids = {0xA0}
        },
        bike_ramp = {
            color = 0xB89000,
            ids = {0xD7,0xD8}
        },
        quick_sand = {
            color = 0xA88000,
            ids = {0xD9,0xDA}
        },
    },

    tileIds = {}
}

function ChunkData:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ChunkData:update()
    if MemoryState.gameplayState == not "Overworld" then return end
    self.startChunkData = memory.read_u32_le(MemoryState.base + 0x229F0)

    self.startChunks = {
        memory.read_u32_le(self.startChunkData +0x90),
        memory.read_u32_le(self.startChunkData +0x94),
        memory.read_u32_le(self.startChunkData +0x98),
        memory.read_u32_le(self.startChunkData +0x9C)
    }
    self.currentChunk = memory.read_u8(self.startChunkData + 0xAC)
    self.currentSubChunk = memory.read_u8(self.startChunkData + 0xAD)
    self.loadedXPosSubpixel = memory.read_u16_le(self.startChunkData + 0xCC)
    self.loadedXPos = memory.read_u16_le(self.startChunkData + 0xCE)
    self.loadedYPosSubpixel = memory.read_u16_le(self.startChunkData + 0xD0)
    self.loadedYPos = memory.read_u16_le(self.startChunkData + 0xD2)
    self.loadedZosSubpixel = memory.read_u16_le(self.startChunkData + 0xD4)
    self.loadedZPos = memory.read_u16_le(self.startChunkData + 0xD6)

    self.isChunkLoading = ({[0] = true,[1] = false})[memory.read_u8(self.startChunkData + 0xE4)]

    for k,v in pairs(self.tileData) do
        for i=1,#self.tileData[k]['ids'] do
            self.tileIds[self.tileData[k]['ids'][i]] = self.tileData[k]['color']
        end
    end
end