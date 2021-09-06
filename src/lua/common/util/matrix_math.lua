local vmath = require("common/util/vector_math")

local mmath = {}

function mmath.mat(x, y, t)
    return {x = x, y = y, values = t}
end

function mmath.apply(mat, vec4)
    local x,y,z,e
    x = mat.values[1] * vec4.x + mat.values[5] * vec4.y + mat.values[9] * vec4.z + mat.values[13] * vec4.e
    y = mat.values[2] * vec4.x + mat.values[6] * vec4.y + mat.values[10] * vec4.z + mat.values[14] * vec4.e
    z = mat.values[3] * vec4.x + mat.values[7] * vec4.y + mat.values[11] * vec4.z + mat.values[15] * vec4.e
    e = mat.values[4] * vec4.x + mat.values[8] * vec4.y + mat.values[12] * vec4.z + mat.values[16] * vec4.e

    --return vmath.vec4(x, y, z, e)
    return vmath.vec(x / e, y / e, z / e)
end

return mmath
