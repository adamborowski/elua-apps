--
-- Created by IntelliJ IDEA.
-- User: adam
-- Date: 09.11.13
-- Time: 11:24
-- To change this template use File | Settings | File Templates.
--


--#define CLEAR_COLOR_RGB(red,green,blue) ((2UL<<24)|(((red)&255UL)<<16)|(((green)&255UL)<<8)|(((blue)&255UL)<<0))
function clear_color_rgb3(r, g, b)
    local result = lsh(2, 24)
    result = result + lsh(band(b, 0xff), 16)
    result = result + lsh(band(g, 0xff), 8)
    result = result + band(r, 0xff)
    return result
end

function clear_color_rgb1(rgb)
    return bor(0x02000000, rgb)
end

--#define CLEAR_COLOR_RGB(red,green,blue) ((2UL<<24)|(((red)&255UL)<<16)|(((green)&255UL)<<8)|(((blue)&255UL)<<0))
--#define COLOR_RGB(red,green,blue)       ((4UL<<24)|(((red)&255UL)<<16)|(((green)&255UL)<<8)|(((blue)&255UL)<<0))
function color_rgb3(r, g, b)
    local result = lsh(4, 24)
    result = result + lsh(band(b, 0xff), 16)
    result = result + lsh(band(g, 0xff), 8)
    result = result + band(r, 0xff)
    return result
end

function color_rgb1(rgb)
    return bor(0x04000000, rgb)
end



--#define CLEAR(c,s,t) ((38UL<<24)|(((c)&1UL)<<2)|(((s)&1UL)<<1)|(((t)&1UL)<<0))
function clear(c, s, t)
    local result = lsh(38, 24)
    result = result + lsh(band(c, 0x01), 2)
    result = result + lsh(band(s, 0x01), 1)
    result = result + band(t, 0x01)

    return result
end

--#define POINT_SIZE(size) ((13UL<<24)|(((size)&8191UL)<<0))
function point_size(size)
    return bor(lsh(13, 24), band(size, 8191))
end

--#define BEGIN(prim) ((31UL<<24)|(((prim)&15UL)<<0))
function begin(prim)
    return bor(lsh(31, 24), band(prim, 15))
end

--# define VERTEX2II (x, y, handle, cell)
-- ((2 UL < < 30) | (((x) & 511 UL) < < 21) | (((y) & 511 UL) < < 12) | (((handle) & 31 UL) < < 7) | (((cell) & 127 UL) < < 0))
function vertex2ii(x, y, handle, cell)
    return bor(lsh(2, 30), lsh(band(x, 511), 21), lsh(band(y, 511), 12), lsh(band(handle, 31), 7), band(cell, 127))
end

function d_end()
    return 0x21000000
end


cmdAddress = F.RAM_DL
function reset(color)
    cmdAddress = F.RAM_DL
    draw(clear_color_rgb1(color))
    draw(clear(1, 1, 1))
end

function draw(data)
    wr32(cmdAddress, data)
    cmdAddress = cmdAddress + 4
end

function draw_small(data)
    wr16(cmdAddress, data)
    cmdAddress = cmdAddress + 2
end

function commit()
    wr32(cmdAddress, 0); --DISPLAY()
    wr8(F.REG_DLSWAP, F.DLSWAP_FRAME) --//display list swap

    --wr8(F.REG_GPIO_DIR, bor(0x80, rd8(F.REG_GPIO_DIR)))
    --    wr8(F.REG_GPIO_DIR, 0x80)
    --    wr8(F.REG_GPIO, 0x80)
end

function makeText(str, x, y, color, font, letterspacing)
    draw(color_rgb1(color))
    draw(begin(1))
    for i = 1, string.len(str) do
        draw(vertex2ii(x + (i - 1) * letterspacing, y, font, string.byte(str, i))) --; / / ascii t
    end
    draw(d_end())
end
