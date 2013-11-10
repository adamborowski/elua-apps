--#define CLEAR_COLOR_RGB(red,green,blue) ((2UL<<24)|(((red)&255UL)<<16)|(((green)&255UL)<<8)|(((blue)&255UL)<<0))
function clear_color_rgb3(r, g, b)
    return 0x02000000 + lsh(r, 16) + lsh(g, 8) + b
--    local result = lsh(2, 24)
--    result = result + lsh(band(b, 0xff), 16)
--    result = result + lsh(band(g, 0xff), 8)
--    result = result + band(r, 0xff)
--    return result
end

function clear_color_rgb1(rgb)
    return 0x02000000 + rgb
end

--#define CLEAR_COLOR_RGB(red,green,blue) ((2UL<<24)|(((red)&255UL)<<16)|(((green)&255UL)<<8)|(((blue)&255UL)<<0))
--#define COLOR_RGB(red,green,blue)       ((4UL<<24)|(((red)&255UL)<<16)|(((green)&255UL)<<8)|(((blue)&255UL)<<0))
function color_rgb3(r, g, b)
    return 0x04000000 + lsh(r, 16) + lsh(g, 8) + b
    --    local result = lsh(4, 24)
    --    result = result + lsh(band(b, 0xff), 16)
    --    result = result + lsh(band(g, 0xff), 8)
    --    result = result + band(r, 0xff)
    --    return result
end

function color_rgb1(rgb)
    return 0x04000000 + rgb
end

--#DEDFINE COLOR_A(alpha) ((16UL<<24)|(((alpha)&255UL)<<0))
-- value from 0 to 255
function alpha(value)
    return 0x10000000 + value
end


--#define CLEAR(c,s,t) ((38UL<<24)|(((c)&1UL)<<2)|(((s)&1UL)<<1)|(((t)&1UL)<<0))
function clear(c, s, t)
    return 0x26000000 + lsh(c, 2) + lsh(s, 1) + t
    --    local result = lsh(38, 24)
    --    result = result + lsh(band(c, 0x01), 2)
    --    result = result + lsh(band(s, 0x01), 1)
    --    result = result + band(t, 0x01)
    --
    --    return result
end

--[[
Sets the size of drawn points. The width is the distance from the center of the point
to the outermost drawn pixel, in units of 1/16 pixels. The valid range is from 16 to
8191 with respect to 1/16th pixel unit.
 ]]
function point_size(size)
    return 0x0d000000 + size
end

-- @width 1=1/6px, from 16 to 4095 pp
function line_width(width)
    return 0x06 + width
end

--#define BEGIN(prim) ((31UL<<24)|(((prim)&15UL)<<0))
function begin(prim)
    return 0x1f000000 + prim
end

--[[
Start the operation of graphics primitive at the specified coordinates. The handle and cell
parameters will be ignored unless the graphics primitive is specified as bitmap by
command BEGIN, prior to this command.
 ]]
function vertex2ii(x, y, handle, cell) -- - 2147483648 == 0x80000000 why?
    return -2147483648 + lsh(x, 21) + lsh(y, 12) + lsh(handle, 7) + cell
    --    return bor(lsh(2, 30), lsh(band(x, 511), 21), lsh(band(y, 511), 12), lsh(band(handle, 31), 7), band(cell, 127))
end

function d_end() -- begin(PRIMITIVE) cmd cmd cmd ... end()
    return 0x21000000
end

