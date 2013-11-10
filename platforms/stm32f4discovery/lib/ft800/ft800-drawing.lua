function clear_color_rgb3(r, g, b)
    return 0x02000000 + lsh(r, 16) + lsh(g, 8) + b
end

function clear_color_rgb1(rgb)
    return 0x02000000 + rgb
end

function clear(c, s, t)
    return 0x26000000 + lsh(c, 2) + lsh(s, 1) + t
end

local state = {
    lineWidth = 0,
    pointSize = 16,
    alpha = 255,
    color = 0xffffff,
    primitive = PRIM.POINTS
}

function finishDrawing()
    if state.primitive ~= nil then
        draw(0x21000000) -- end primitive drawing if already drawing
        state.primitive = nil
    end
end

function startDrawing() -- some bug fixes
    state={} -- forget about all cached state bacause new display list starts from FT800 default state
end

--[[
Start the operation of graphics primitive at the specified coordinates. The handle and cell
parameters will be ignored unless the graphics primitive is specified as bitmap by
command BEGIN, prior to this command.
 ]]
local x800000 = lsh(2, 30) --  0x80000000 == -2147483648 why?
function drawVertex2ii(x, y, handle, cell)
    draw(x800000 + lsh(x, 21) + lsh(y, 12) + lsh(handle, 7) + cell)
end

--[[
Start the operation of graphics primitives at the specified screen coordinate, in 1/16th
pixel precision.
 ]]
function drawVertex2f(x, y)
    draw(0x40000000 + lsh(x, 15) + y)
end

--#define BEGIN(prim) ((31UL<<24)|(((prim)&15UL)<<0))

function setPrimitive(prim)
    if state.primitive ~= prim then
        draw(0x21000000) -- END commend must be sent before begin
        draw(0x1f000000 + prim)
        state.primitive = prim
    end
end
function setColor_rgb3(r, g, b)
    local val = b + lsh(g, 8) + lsh(r, 16)
    if state.color ~= val then
        draw(0x04000000 + val)
        state.color = val
    end
end
function setColor_rgb1(val)
    if state.color ~= val then
        draw(0x04000000 + val)
        state.color = val
    end
end
-- value from 0 to 255
function setAlpha(val)
    if state.alpha ~= val then
        draw(0x10000000 + val)
        state.alpha = val
    end
end
--[[
Sets the size of drawn points. The width is the distance from the center of the point
to the outermost drawn pixel, in units of 1/16 pixels. The valid range is from 16 to
8191 with respect to 1/16th pixel unit.
 ]]
function setPointSize(size)
    if state.pointSize ~= size then
        draw(0x0d000000 + size)
        state.pointSize = size
    end
end
-- @width 1=1/6px, from 16 to 4095 pp
local x0e000000 = lsh(14, 24)
function setLineWidth(val)
    if state.lineWidth ~= val then
        draw(x0e000000 + val)
        state.lineWidth = val
    end
end