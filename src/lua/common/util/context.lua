local vmath = require("common/util/vector_math")
local mmath = require("common/util/matrix_math")
local helpers = require("common/util/helpers")

local X_OFF = 256/2 - 1
local Y_OFF = 192/2 - 1
local Y_MAX = 191
local X_MAX = 255

local Context = {}
function Context:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    if (_G["__void_form_id"] ~= nil) then
        forms.destroy(_G["__void_form_id"])
    end

    o.line = 0

    -- _G["__void_form_id"] = forms.newform()
    -- _G["__void_picture_id"] = forms.pictureBox(_G["__void_form_id"])

    return o
end

--=== UTIL FUNCS ===--

function Context:log(text, x, color)
    gui.text(x or 0, self.line, text, color)
    self.line = self.line + 10
end

function Context:transform2(x, y, z)
    local camera = self.fsys.camera

    if camera.view == 1 then
        -- TODO: Switch to orthographic projection
    end

    local camPos = camera.lookat.camPos  -- camera position {xyz}
    local target = camera.lookat.target  -- position we're focused on {xyz}
    local forward = vmath.unit(vmath.sub(target, camPos))
    local right = vmath.unit(vmath.cross(forward, camera.lookat.camUp))
    local up = vmath.unit(vmath.cross(right, forward))
    local p = vmath.sub(vmath.vec(x, y, z), camPos)

    local aspect = camera.persp.aspect  -- aspect ratio
    local tanFov = camera.persp.fovysin / camera.persp.fovycos

    local IR3 = vmath.dot(forward, p)

    local IR1 = vmath.dot(right, p)
    local SX = X_OFF - (IR1/(-IR3 * aspect * tanFov)) * X_OFF

    local IR2 = vmath.dot(up, p)
    local SY = Y_OFF + (IR2 /(-IR3 * tanFov)) * Y_OFF
    return {SX, SY, IR3}  -- Screen X/Y
end

--[[
    Convert world coordinates at (x, lookat.y, z) to screen coordinates
    lop left (0, 0)
    bottom right (255, 191)
]]--
function Context:transform(x, z)
    local camera = self.fsys.camera
    local fov = math.acos(camera.persp.fovycos)
    local farClip = camera.persp.farClip
    local nearClip = camera.persp.nearClip
    local target = camera.lookat.target  -- Vector {xyz}
    local aspectRatio = camera.persp.aspect
    local isOrthogonal = camera.view == 1
    --local fovy = math.acos(camera.persp.fovycos)
    --local fovx = camera.persp.aspect * fovy
    --local f = camera.persp.farClip
    --local n = camera.persp.nearClip
    --local target = camera.lookat.target
    --
    --local m
    --if camera.view == 1 then
    --    local S = 1 / (math.tan(fovy * math.pi / 360))
    --
    --    m = mmath.mat(4, 4, {
    --        S, 0, 0, 0,
    --        0, S, 0, 0,
    --        0, 0, -(f / (f-n)), -1,
    --        0, 0, -(f*n / (f - n)), 0
    --    })
    --else
    --    local l = 0
    --    local r = 256
    --    local t = 0
    --    local b = 192
    --    m = mmath.mat(4, 4, {
    --        2 / (r-l), 0, 0, -(r+l) / (r-l),
    --        0, 2 / (t-b), 0, -(t+b) / (t-b),
    --        0, 0, -2 / (f-n), -(f+n) / (f-n),
    --        0, 0, 0, 1
    --    })
    --end
    --
    --local res = mmath.apply(m, vmath.vec4(x, target.y, z, 1))
    --
    --local SX = math.min(255, (res.x + 1) / 2 * 256)
    --local SY = math.min(191, (1 - (res.y + 1) / 2) * 192)
    --
    --print(SX, SY)
    --
    --return {SX, SY}

    local camPos = camera.lookat.camPos  -- camera position {xyz}
    local target = camera.lookat.target  -- position we're focused on {xyz}
    local forward = vmath.unit(vmath.sub(target, camPos))
    local right = vmath.unit(vmath.cross(forward, camera.lookat.camUp))
    local up = vmath.unit(vmath.cross(right, forward))
    local p = vmath.sub(vmath.vec(x, target.y, z), camPos)

    local aspect = camera.persp.aspect  -- aspect ratio
    local tanFov = camera.persp.fovysin / camera.persp.fovycos

    local IR3 = vmath.dot(forward, p)

    local IR1 = vmath.dot(right, p)
    local SX = X_OFF - (IR1/(-IR3 * aspect * tanFov)) * X_OFF

    local IR2 = vmath.dot(up, p)
    local SY = Y_OFF + (IR2 /(-IR3 * tanFov)) * Y_OFF
    return {SX, SY}  -- Screen X/Y
end

--[[
    Convert screen coordinates to world coordinates at y = lookat.y
    lop left (0, 0)
    bottom right (255, 191)
]]--
function Context:transformInverse(sx, sy)
    local camera = self.fsys.camera
    local fov = math.acos(camera.persp.fovycos)
    local farClip = camera.persp.farClip
    local nearClip = camera.persp.nearClip
    local target = camera.lookat.target  -- Vector {xyz}
    local aspectRatio = camera.persp.aspect
    local isOrthogonal = camera.view == 1
    --local fovy = math.acos(camera.persp.fovycos)
    --local fovx = camera.persp.aspect * fovy
    --local f = camera.persp.farClip
    --local n = camera.persp.nearClip
    --local target = camera.lookat.target
    --
    --local m
    --if camera.view == 1 then
    --    local S = 1 / (math.tan(fovy * math.pi / 360))
    --
    --    m = mmath.mat(4, 4, {
    --        S, 0, 0, 0,
    --        0, S, 0, 0,
    --        0, 0, -(f / (f-n)), -1,
    --        0, 0, -(f*n / (f - n)), 0
    --    })
    --else
    --    local l = 0
    --    local r = 256
    --    local t = 0
    --    local b = 192
    --    m = mmath.mat(4, 4, {
    --        2 / (r-l), 0, 0, -(r+l) / (r-l),
    --        0, 2 / (t-b), 0, -(t+b) / (t-b),
    --        0, 0, -2 / (f-n), -(f+n) / (f-n),
    --        0, 0, 0, 1
    --    })
    --end
    --
    --local res = mmath.apply(m, vmath.vec4(sx, target.y, sy, 1))
    --print(res)
    --
    --if true then return {res.x, res.y} end

    local camPos = camera.lookat.camPos
    local target = camera.lookat.target
    local forward = vmath.unit(vmath.sub(target, camPos))
    local right = vmath.unit(vmath.cross(forward, camera.lookat.camUp))
    local up = vmath.unit(vmath.cross(right, forward))

    local fovy = math.acos(camera.persp.fovycos)
    local fovx = camera.persp.aspect * fovy

    local x = (2*sx/256 - 1) * math.tan(fovx)
    local y = (1 - 2*sy/192) * math.tan(fovy)

    local v = vmath.add(vmath.add(vmath.mul(right, x), vmath.mul(up, y)), forward)
    local a = -((camPos.y - target.y) / v.y)

    local xPlane = a * v.x + camPos.x
    local yPlane = a * v.z + camPos.z
    return {xPlane, yPlane}
end


function Context:drawGameLine(startx, starty, endx, endy, color)
    if self.fsys.ctrl.mainproc == nil or self.fsys.ctrl.mainproc.data.overlay_id ~= 0xffffffff then return end

    -- Transform
    local transStart = self:transform(startx, starty)
    local transEnd = self:transform(endx, endy)

    if transEnd[2] > Y_MAX then
        if transStart[2] > Y_MAX then return end
        transEnd[1] = transStart[1] + ((transEnd[1] - transStart[1]) / (transEnd[2] - transStart[2])) * (Y_MAX - transStart[2])
        transEnd[2] = Y_MAX
    end

    gui.drawLine(transStart[1], transStart[2], transEnd[1], transEnd[2], color)
end

function Context:drawGameQuad(startx, starty, endx, endy, color, fill)
    if self.fsys.ctrl.mainproc == nil or self.fsys.ctrl.mainproc.data.overlay_id ~= 0xffffffff then return end

    -- Transform
    local transStart = self:transform(startx, starty)
    local transEnd = self:transform(endx, endy)

    if transEnd[2] > Y_MAX then
        if transEnd[2] == transStart[2] then return end
        transEnd[1] = helpers.round(transStart[1] + (transEnd[1] - transStart[1]) / (transEnd[2] - transStart[2]) * Y_MAX)
        transEnd[2] = Y_MAX
    end

    gui.drawLine({transStart, {transStart[1], transEnd[2]},
                  transEnd, {transEnd[1], transStart[2]}}, 0, 0, color, fill)
end

return Context
