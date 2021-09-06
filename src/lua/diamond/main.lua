if not string.find(package.path, ";\.\./?\.lua") then
    package.path = package.path .. ";../?.lua"
end

--=== Libraries ===--
local json = require("common/lib/json")
local moses = require("common/lib/moses")
local helpers = require("common/util/helpers")
local struct_tools = require("common/util/structs")
local Context = require("common/util/context")
require("common/ext/memory")  -- More funcs on memory

-- Local required files --
local structs = require("data/game_structs")

--=== LOGIC ===--

function Context:initSettings()
    self.settings = {
        gridView = true,
        loadLineView = true,
        subChunkView = true,

        wideScreen = false,
    }

    self.draw = 0
    self.tiles = require("data/tiles")
end

function Context:drawGrid()
    if not self.settings.gridView then return end

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
    local LOAD_LINE = 16
    local CHUNK_BORDER = 0

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

    if self.settings.wideScreen then
        memory.write_u32_le(self.fsys.camera.persp.__addr + 8, helpers.tofixed(16/9))

        if (self.info == nil) then
            self.info = 1
            print(json.encode(struct_tools.dump(self.fsys.camera)))
        end

        -- DEBUG FOR CAM MOVEMENT
        -- memory.write_u32_le(self.fsys.camera.lookat.camPos.__addr, helpers.tofixed(3100))
        -- memory.write_u32_le(self.fsys.camera.lookat.camPos.__addr + 4, helpers.tofixed(350))
        -- memory.write_u32_le(self.fsys.camera.lookat.camPos.__addr + 8, helpers.tofixed(13000))
        -- memory.write_u32_le(self.fsys.camera.persp.__addr + 12, helpers.tofixed(-10000))
        -- memory.write_u32_le(self.fsys.camera.persp.__addr + 16, helpers.tofixed(500))
    end
end

function Context:tickEnd()
    if self.fsys.__addr == 0 then
        return  -- Not initialized yet
    end

    self.draw = (self.draw + 1) % 3
    if self.draw == 0 then
        self:drawGrid()
    end
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