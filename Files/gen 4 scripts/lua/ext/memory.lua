

function memory.read_string_size(address, size)
    local res = ""

    for i = 1, size do
        res = res .. string.char(memory.read_u8(address + i - 1))
    end

    return res
end

function memory.read_string(address)
    local res = ""
    local i = 0

    while true do
        local b = memory.read_u8(address + i)
        if b == 0 then break end
        res = res .. string.char(b)
        i = i + 1
    end

    return res
end