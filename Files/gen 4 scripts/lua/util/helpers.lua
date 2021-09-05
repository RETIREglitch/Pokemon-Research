local helpers = {}

function helpers.hex_2(num)
    return string.format("0x%02X", num)
end

function helpers.hex_4(num)
    return string.format("0x%04X", num)
end

function helpers.hex_8(num)
    return string.format("0x%08X", num)
end

function helpers.round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function helpers.tofloat(fx32)  -- s19.12
    local v = helpers.round(fx32 / 0x1000, 12)
    return v
end

function helpers.tofixed(fl32)
    return bit.band(fl32 * 0x1000, 0xFFFFFFFF)
end

return helpers