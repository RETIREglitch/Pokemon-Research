Utility = {}

function Utility:format(val,len)
    return string.format("%0"..len.."X", bit.band(4294967295, val))
end
