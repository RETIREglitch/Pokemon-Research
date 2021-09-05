local vmath = require("util/vector_math")
local helpers = require("util/helpers")

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
    gui.drawText(x or 0, self.line, text, color)
    self.line = self.line + 10
end

function Context:transform(x, z)
    local camera = self.fsys.camera

    -- TODO: use Ortho Indoors

    local camPos = camera.lookat.camPos
    local target = camera.lookat.target
    local forward = vmath.unit(vmath.sub(target, camPos))
    local right = vmath.unit(vmath.cross(forward, camera.lookat.camUp))
    local up = vmath.unit(vmath.cross(right, forward))
    local p = vmath.sub(vmath.vec(x, target.y, z), camPos)

    local aspect = camera.persp.aspect
    local tanFov = camera.persp.fovysin / camera.persp.fovycos

    local IR3 = vmath.dot(forward, p)

    local IR1 = vmath.dot(right, p)
    local SX = X_OFF - (IR1/(-IR3 * aspect * tanFov)) * X_OFF

    local IR2 = vmath.dot(up, p)
    local SY = Y_OFF + (IR2 /(-IR3 * tanFov)) * Y_OFF
    return {SX, SY}
end

function Context:transformInverse(sx, sy)
    local camera = self.fsys.camera
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
