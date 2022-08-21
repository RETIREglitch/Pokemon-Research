MemoryState = {
    base,
    gameplayState,
    memoryOffset,
    staticAddresses = {
        ug_init_addr = 0x2250E86
    },
    offsets = {
        memorystate_check = 0x22A00,
        
    },
    values = {
        ug_init_val = 0x1F,
        memorystate_check_value = 0x2C9EC
    }
}

function MemoryState:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function MemoryState:setMemoryState(base)
	if memory.read_u32_le(base + self.offsets["memorystate_check"]) == (base + self.values["memorystate_check_value"]) then -- check for ug/bt ptr
		if memory.read_s8(self.staticAddresses["ug_init_addr"]) == self.values["ug_init_val"] then
            self.gameplayState = "Underground"
            self.memoryOffset = 0x8124
			return
		end
        self.gameplayState = "Battle Tower" 
        self.memoryOffset = 0x8124
		return 
	end 
    self.gameplayState = "Overworld"
    self.memoryOffset = 0
	return 
end

function MemoryState:update()
    self.base = memory.read_u32_le(memory.read_u32_le(0x2002848)-4)
    self:setMemoryState(self.base)
end

function MemoryState:display()
    gui.text(0,18,"Base: 0x" .. Utility:format(self.base,8) .. " - " .. self.gameplayState)
end