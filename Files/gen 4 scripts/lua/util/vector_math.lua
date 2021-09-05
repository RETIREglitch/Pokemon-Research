local vmath = {}

function vmath.vec(x, y, z)
    return {x = x, y = y, z = z}
end

function vmath.unit(v)
    local size = math.sqrt(v.x*v.x + v.y*v.y +v.z*v.z)
    if (size == 0) then return vmath.vec(1, 1, 1) end
    return vmath.vec(v.x/size, v.y/size, v.z/size)
end

function vmath.dot(v1, v2)
    return v1.x * v2.x + v1.y*v2.y + v1.z * v2.z
end

function vmath.sub(v1, v2)
    return vmath.vec(v1.x - v2.x, v1.y-v2.y, v1.z-v2.z)
end

function vmath.neg(v)
    return vmath.vec(-v.x, -v.y, -v.z)
end

function vmath.mul(vec, x)
    return vmath.vec(vec.x * x, vec.y * x, vec.z * x)
end

function vmath.add(v1, v2)
    return vmath.vec(v1.x+v2.x, v1.y+v2.y, v1.z+v2.z)
end

function vmath.cross(a, b)
    local cp = vmath.vec(0,0,0);
    cp.x = a.y*b.z - a.z*b.y;
    cp.y = a.z*b.x - a.x*b.z;
    cp.z = a.x*b.y - a.y*b.x;
    return cp;
end

return vmath
