ScrCmd = {

}

function ScrCmd:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ScrCmd:disassembleScriptData()

end

function ScrCmd:display()

end