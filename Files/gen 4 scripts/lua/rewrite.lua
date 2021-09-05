local json = require("lib/json")
local moses = require("lib/moses")
local helpers = require("util/helpers")
local struct_tools = require("util/structs")
local structs = require("game_structs")
local Context = require("util/context")
require("ext/memory")  -- More funcs on memory

local LOAD_LINE = 16
local CHUNK_BORDER = 0

--=== LOGIC ===--

function Context:initSettings()
    self.settings = {
        gridView = true,
        loadLineView = true,
        subChunkView = true,

        cheatWTW = true,
        cheatRepel = true
    }
end

function Context:drawGrid()
    if not self.settings.gridView then return end

    local camPos = self.fsys.camera.lookat.target
    self:log(camPos.x)

    local c1 = self:transformInverse(0, 0)
    local c2 = self:transformInverse(255, 0)
    local c3 = self:transformInverse(255, 191)
    local c4 = self:transformInverse(0, 191)
    local xvals = { c1[1], c2[1], c3[1], c4[1] }
    local yvals = { c1[2], c2[2], c3[2], c4[2] }
    local min_x = moses.min(xvals)
    local min_y = moses.min(yvals)
    local max_x = moses.max(xvals)
    local max_y = moses.max(yvals)

    local xstart = min_x - (min_x % 16)
    local xend = max_x - (max_x % 16) + 16
    local ystart = min_y - (min_y % 16)
    local yend = max_y - (max_y % 16) + 16

    local color

    for x = xstart, xend, 16 do
        if self.settings.loadLineView and (x/16) % 32 == LOAD_LINE then color = "red" elseif self.settings.subChunkView and (x/16)%32 == CHUNK_BORDER then color = "lightblue" else color = "blue" end
        self:drawGameLine(x, ystart, x, yend, color)
    end
    for y = ystart, yend, 16 do
        if self.settings.loadLineView and (y/16) % 32 == LOAD_LINE then color = "red" elseif self.settings.subChunkView and (y/16)%32 == CHUNK_BORDER then color = "lightblue" else color = "blue" end
        self:drawGameLine(xstart, y, xend, y, color)
    end
end

--=== Tick ===--

function Context:init()
    -- Run once
    self:initSettings()
end

function Context:tickStart()
    struct_tools.clear_cache()
    -- Load all data
    local fsys_ptr = memory.read_u32_le(0x021c5a08) -- US
    self.fsys = structs.FIELDSYS_WORK(fsys_ptr)
    self.line = 0

    -- memory.write_u32_le(self.fsys.camera.__addr + 8, helpers.tofixed(16/9))
    -- memory.write_u32_le(self.fsys.camera.__addr + 20, helpers.tofixed(self.fsys.camera.lookat.camPos.x + 0.1))
    -- memory.write_u32_le(self.fsys.camera.__addr + 24, helpers.tofixed(self.fsys.camera.lookat.camPos.y + 0.1))
end

function Context:tickEnd()
    if self.fsys.__addr == 0 then
        return  -- Not initialized yet
    end

    self:drawGrid()
    -- self:log(memory.read_string(0x02000B8D))

    -- Use data
end

--=== Register functions ===--

do
    event.unregisterbyname("void_start")
    event.unregisterbyname("void_end")
    local ctx = Context:new()
    ctx:init()
    event.onframestart(function() ctx:tickStart() end, "void_start")
    event.onframeend(function() ctx:tickEnd() end, "void_end")
end