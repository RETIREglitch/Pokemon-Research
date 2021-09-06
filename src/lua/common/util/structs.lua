require("common/util/basic_types")
local helpers = require("common/util/helpers")

local module = {}

local cacheref = {
    cache = {}
}

local function sizeof(t)
    if (t == BOOL) then
        return 4
    elseif (t == u8) then
        return 1
    elseif (t == s8) then
        return 1
    elseif (t == u16) then
        return 2
    elseif (t == s16) then
        return 2
    elseif (t == u32) then
        return 4
    elseif (t == s32) then
        return 4
    elseif (t == fx32) then
        return 4
    elseif (t == voidp) then
        return 4
    else
        -- check array, struct
        if t.is_ptr then
            return 4
        elseif t.is_arr then
            return t.length * sizeof(t.struct)
        elseif t.__name ~= nil then
            local i = 0
            for j, k in pairs(t.__indices) do
                i = i + sizeof(t[k])
            end
            return i
        end
    end

    return 0
end

local function do_write(val, ptr)
    print("TODO: Write " .. tostring(val) .. " to " .. helpers.hex_8(ptr))
end

local function instance(typ, ptr)
    if typ == nil then return nil end
    if ptr == 0 then return nil end

    local x
    --local x = cacheref.cache[ptr]
    --if x ~= nil and x[typ] ~= nil then
    --    return x[typ]
    --end
    --
    --if x == nil then
    --    cacheref.cache[ptr] = {}
    --end

    if (typ == BOOL) then
        x = (memory.read_u32_le(ptr) == 1)
    elseif (typ == u8) then
        x = memory.read_u8(ptr)
    elseif (typ == s8) then
        x = memory.read_s8(ptr)
    elseif (typ == u16) then
        x = memory.read_u16_le(ptr)
    elseif (typ == s16) then
        x = memory.read_s16_le(ptr)
    elseif (typ == u32) then
        x = memory.read_u32_le(ptr)
    elseif (typ == s32) then
        x = memory.read_s32_le(ptr)
    elseif (typ == fx32) then
        x = helpers.tofloat(memory.read_s32_le(ptr))
    elseif (typ == voidp) then
        x = helpers.hex_8(memory.read_u32_le(ptr))
    else
        -- check array, struct
        if typ.is_ptr then
            local a = memory.read_u32_le(ptr)
            if a == 0 then return nil end
            x = instance(typ.struct, a)
        elseif typ.is_arr then
            local size = sizeof(typ.struct)
            local meta = {}

            function meta:__index(key)
                if (key == "__addr") then return ptr end
                return instance(typ.struct, ptr + key * size)
            end

            if (type(typ.struct) ~= "number") then
                function meta:__newindex(key, value)
                    do_write(value, ptr + key * size)
                end
            end

            x = setmetatable({__addr = ptr}, meta)
        elseif typ.__name ~= nil then
            local o = {}
            local t = {}
            local i = 0
            for j = 0, #typ.__indices do
                local k = typ.__indices[j]
                local v = typ[k]
                o[k] = i
                t[k] = v
                local s = sizeof(v)
                i = i + s
            end
            local meta = {}

            function meta:__index(key)
                local obj = instance(t[key], ptr + o[key])
                rawset(self, key, obj)
                return obj
            end

            function meta:__newindex(key, value)
                if (type(t[key]) == "number") then
                    rawset(self, key, value)
                    do_write(value, ptr + o[key])
                end
            end

            x = setmetatable({__addr = ptr, __name = typ.__name, __indices = typ.__indices}, meta)
        end
    end

    --cacheref.cache[ptr][typ] = x
    return x
end

local function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function module.struct(t)
    local meta = t.__meta or {}

    -- instantiate
    function meta:__call(addr)
        return instance(t, addr)
    end

    function meta:__newindex(k, v)
        t.__indices[tablelength(t.__indices)] = k
        rawset(self, k, v)
    end

    t.__indices = {}
    t = setmetatable(t, meta)
    return t
end


function module.ptr(struct_)
    return {is_ptr = true, struct = struct_}
end

function module.arr(data, length)
    return {is_arr = true, length = length, struct = data}
end

function module.clear_cache()
    cacheref.cache = {}
end

function module.dump(obj)
    local o = {}
    for i, k in pairs(obj.__indices) do
        local v = obj[k]
        if type(v) == "table" and v.__name then
            v = module.dump(v)
        end
        o[k] = v
    end
    return o
end

return module