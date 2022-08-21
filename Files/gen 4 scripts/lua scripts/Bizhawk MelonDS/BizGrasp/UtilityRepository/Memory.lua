Memory = {}

function Memory:readascii(addr,length)
    length = length or 2
    text = ""
    for i=0, length-1 do
        text = text .. self:readchar(memory.read_u8(addr+i))
    end
    return text
end 

function Memory:readchar(ascii)
    if ascii == 0 then return " " end 
    return string.char(ascii) 
end

function Memory:read_8(addr,signed)
    if signed then return mainmemory.read_s8(addr) end
    return mainmemory.read_u8(addr)
end

function Memory:getSigned(signed)
    if signed then return "_s" end
    return "_u"
end

function Memory:getEndian(bigEndian)
    if bigEndian then return "_be" end
    return "_le"
end

function Memory:read(addr,bits,signed,bigEndian)
    signed = signed or false 
    bigEndian = bigEndian or false
    if bits == 8 then return Memory:read_8(addr,signed) end
    read = "return mainmemory.read" .. Memory:getSigned() .. bits .. Memory:getEndian(bigEndian) .. "(" .. (addr - 0x2000000) .. ")"
    return loadstring(read)()
end 