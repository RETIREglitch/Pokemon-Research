local helpers = require("util/helpers")

local module = {}

local cacheref = {
    cache = {}
}

local function sizeof(t)
    if (t == 0) then
        return 4
    elseif (t == 1) then
        return 1
    elseif (t == 2) then
        return 1
    elseif (t == 3) then
        return 2
    elseif (t == 4) then
        return 2
    elseif (t == 5) then
        return 4
    elseif (t == 6) then
        return 4
    elseif (t == 7) then
        return 4
    elseif (t == 8) then
        return 4
    else
        -- check array, struct
        if t.is_ptr then
            return 4
        elseif t.is_arr then
            return t.length * sizeof(t.struct)
        elseif t.__name ~= nil then
            local i = 0
            for j, k in ipairs(t) do
                i = i + sizeof(k)
            end
        end
    end

    return 0
end

local function do_write(val, ptr)
    print("TODO: Write " .. tostring(val) .. " to " .. helpers.hex_8(ptr))
end

local function instance(typ, ptr)
    local x = cacheref.cache[ptr]
    if x ~= nil then
        return x
    end

    if (typ == 0) then
        x = (memory.read_u32_le(ptr) == 1)
    elseif (typ == 1) then
        x = memory.read_u8(ptr)
    elseif (typ == 2) then
        x = memory.read_s8(ptr)
    elseif (typ == 3) then
        x = memory.read_u16_le(ptr)
    elseif (typ == 4) then
        x = memory.read_s16_le(ptr)
    elseif (typ == 5) then
        x = memory.read_u32_le(ptr)
    elseif (typ == 6) then
        x = memory.read_s32_le(ptr)
    elseif (typ == 7) then
        x = helpers.tofloat(memory.read_s32_le(ptr))
    elseif (typ == 8) then
        x = helpers.tofixed(memory.read_u32_le(ptr))
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
            for k, v in pairs(typ) do
                o[k] = i
                t[k] = v
                i = i + sizeof(v)
            end
            local meta = {}

            function meta:__index(key)
                print(rawget(t, key), ptr, key, o[key])  -- error here
                return instance(rawget(t, key), ptr + o[key])
            end

            function meta:__newindex(key, value)
                if (type(t[key]) ~= "number") then
                    do_write(value, ptr + o[key])
                end
            end

            x = setmetatable({__addr = ptr, __name = typ.__name}, meta)
        end
    end

    cacheref.cache[ptr] = x
    return x
end

function module.struct(t)
    local meta = t.__meta or {}

    -- instantiate
    function meta:__call(addr)
        return instance(t, addr)
    end

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

return module