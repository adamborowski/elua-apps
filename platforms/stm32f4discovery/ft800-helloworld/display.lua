band = bit.band
bor = bit.bor
lsh = bit.lshift
rsh = bit.rshift


print("display.lua example")
F = {
    DLSWAP_FRAME = 2,
    RAM_CMD = 1081344,
    RAM_DL = 1048576,
    RAM_G = 0,
    RAM_PAL = 1056768,
    RAM_REG = 1057792,
    REG_CSPREAD = 1057892,
    REG_DATESTAMP = 1058108,
    REG_GPIO = 1057936,
    REG_GPIO_DIR = 1057932,
    REG_HCYCLE = 1057832,
    REG_HOFFSET = 1057836,
    REG_HSIZE = 1057840,
    REG_HSYNC0 = 1057844,
    REG_HSYNC1 = 1057848,
    REG_ID = 1057792,
    REG_INT_EN = 1057948,
    REG_INT_FLAGS = 1057944,
    REG_OUTBITS = 1057880,
    REG_PCLK = 1057900,
    REG_PCLK_POL = 1057896,
    REG_PWM_DUTY = 1057988,
    REG_PWM_HZ = 1057984,
    REG_SWIZZLE = 1057888,
    REG_TRACKER = 1085440,
    REG_VCYCLE = 1057852,
    REG_VOFFSET = 1057856,
    REG_VOL_PB = 1057916,
    REG_VOL_SOUND = 1057920,
    REG_VSIZE = 1057860,
    REG_VSYNC0 = 1057864,
    REG_VSYNC1 = 1057868,
    REG_DLSWAP = 1057872,
}

csPin = pio.PB_11
pdPin = pio.PA_2
lowPins = { pio.PA_10, pio.PC_11, pdPin, csPin }
local sid = 1
function wr(raw_data)
    pio.pin.setlow(csPin)
    spi.write(sid, raw_data)
    pio.pin.sethigh(csPin)
end

function send(data)
    local ret = spi.readwrite(sid, data)
    if ret == nil then
        print("\n--" .. data .. "--> ?? NIL")
    else
        print("\n--" .. data .. "--> ?? " .. ret[1])
    end
end

function csopen()
    pio.pin.setlow(csPin)
end

function csclose()
    pio.pin.sethigh(csPin)
end

function cmd(data)
    csopen()
    spi.write(sid, data, 0x00, 0x00)
    csclose()
    tmr.delay(0, 10000)
end

--[[
@param address 22 bit adress
@param data 2 bytes data
--]]
function wr16(address, data)
    csopen()
    local addr1 = rsh(address, 16) + 128
    local addr2 = band(rsh(address, 8), 0xff)
    local addr3 = band(address, 0xff)
    local data1 = band(data, 0xff)
    local data2 = band(rsh(data, 8), 0xff)
    spi.readwrite(sid, addr1, addr2, addr3, data1, data2)
    csclose()
end

--[[
@param address 22 bit adress
@param data 4 bytes data
--]]
function wr32(address, data)
    csopen()
    local addr1 = rsh(address, 16) + 128
    local addr2 = band(rsh(address, 8), 0xff)
    local addr3 = band(address, 0xff)
    local data1 = band(data, 0xff)
    local data2 = band(rsh(data, 8), 0xff)
    local data3 = band(rsh(data, 16), 0xff)
    local data4 = band(rsh(data, 24), 0xff)
    spi.readwrite(sid, addr1, addr2, addr3, data1, data2, data3, data4)
    csclose()
end

--[[
@param address 22 bit adress
@param data 1 byte data
--]]
function wr8(address, data)
    csopen()
    local addr1 = rsh(address, 16) + 128
    local addr2 = band(rsh(address, 8), 0xff)
    local addr3 = band(address, 0xff)
    spi.readwrite(sid, addr1, addr2, addr3, data)
    csclose()
end

--[[
@param address 22 bit adress
--]]
function rd8(address)
    csopen()
    local addr1 = rsh(address, 16) + 0
    local addr2 = band(rsh(address, 8), 0xff)
    local addr3 = band(address, 0xff)
    local ret = spi.readwrite(sid, addr1, addr2, addr3, 0x00, 0x00) -- dummy byte and one byte for answer
    csclose()
    return ret[5]
end

--#define CLEAR_COLOR_RGB(red,green,blue) ((2UL<<24)|(((red)&255UL)<<16)|(((green)&255UL)<<8)|(((blue)&255UL)<<0))
function clear_color_rgb(r, g, b)
    local result = lsh(2, 24)
    result = result + lsh(band(b, 0xff), 16)
    result = result + lsh(band(g, 0xff), 8)
    result = result + band(r, 0xff)
    return result
end


--#define CLEAR_COLOR_RGB(red,green,blue) ((2UL<<24)|(((red)&255UL)<<16)|(((green)&255UL)<<8)|(((blue)&255UL)<<0))
--#define COLOR_RGB(red,green,blue)       ((4UL<<24)|(((red)&255UL)<<16)|(((green)&255UL)<<8)|(((blue)&255UL)<<0))
function color_rgb(r, g, b)
    local result = lsh(4, 24)
    result = result + lsh(band(b, 0xff), 16)
    result = result + lsh(band(g, 0xff), 8)
    result = result + band(r, 0xff)
    return result
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

function v800_init()
    --    1) Reset the FT800
    --      -  Drive PD_N low
    pio.pin.setlow(pdPin)
    --      -  Wait 20ms
    tmr.delay(0, 25000)
    --      - back to high state
    pio.pin.sethigh(pio.PA_2)
    --      -  Wait for 20 ms
    tmr.delay(0, 25000)
    --    2) Issue the Wake - up command
    --      -  Write 0x00 , 0x00 , 0x00
    cmd(0x00) -- wake up <<< at this time lcd emits white light !
    --    3) If using an external crystal or clock source on the FT800, issue the external clock
    --    command
    --      -  Write 0x44 , 0x00 , 0x00
    cmd(0x44) -- external clock
    --    4) Set the FT800 internal clock speed to 48 MHz
    --      -  Write 0x62 , 0x00 , 0x00
    cmd(0x62) -- 48 MHz
    --    5) At this point, the Host MCU SPI Master can change the SPI clock up to 30 MHz
    --not yet
    --    6) Read the Device ID register
    --      -  Read one byte from location 0x102400
    --      -  Check for the value 0x7C
    local dev_id
    while true do
        dev_id = rd8(F.REG_ID)
        if dev_id == 0x7c then break end
    end
    print("DEVICE IS READY")
    --    7) Set bit 7 of REG_GPIO to 0 to turn off the LCD DISP signal
    --      -  Write 0x80 to location 0x102490 << 0x80 = 1<<7
    --?????????????????????????????????????????????????????????????
    wr8(F.REG_GPIO, bor(0x80, rd8(F.REG_GPIO))) --;//enable display bit
end

function v800_display_config()

    -- configuration for QVGA --
    --   1) Set REG_PCLK to zero - This disables the pixel clock output while the LCD and other system parameters are configured
    wr8(F.REG_PCLK, 0)
    --[[ 2) Set the following registers with values for the chosen display .Typical WQVGA and QVGA values are shown :
    ---------------------------------------------------------------------------
    --   REGISTER         DESCRIPTION                             WQVGA   QVGA
    ---------------------------------------------------------------------------
    --  REG_PCLK_POL  Pixel Clock Polarity                         1       0
    --  REG_HSIZE     Image width in pixels                        480     320
    --  REG_HCYCLE    Total number of clocks per line              548     408
    --  REG_HOFFSET   Horizontal image start (pixels from left)    43      70
    --  REG_HSYNC0    Start of HSYNC pulse(falling edge)           0       0
    --  REG_HSYNC1    End of HSYNC pulse(rising edge)              41      10
    --  REG_VSIZE     Image height in pixels                       272     240
    --  REG_VCYCLE    Total number of lines per screen             292     263
    --  REG_VOFFSET   Vertical image start (lines from top)        12      13
    --  REG_VSYNC0    Start of VSYNC pulse(falling edge)           0       0
    --  REG_VSYNC1    End of VSYNC pulse(rising edge)              10      2
    --]]

    --    wr8(F.REG_PCLK_POL, 0)
    --    wr16(F.REG_HSIZE, 320)
    --    wr16(F.REG_HCYCLE, 408)
    --    wr16(F.REG_HOFFSET, 70)
    --    wr16(F.REG_HSYNC0, 0)
    --    wr16(F.REG_HSYNC1, 10)
    --
    --    wr16(F.REG_VSIZE, 240)
    --    wr16(F.REG_VCYCLE, 263)
    --    wr16(F.REG_VOFFSET, 13)
    --    wr16(F.REG_VSYNC0, 0)
    --    wr16(F.REG_VSYNC1, 2)


    wr8(F.REG_PCLK_POL, 1)
    wr16(F.REG_HSIZE, 480)
    wr16(F.REG_HCYCLE, 548)
    wr16(F.REG_HOFFSET, 43)
    wr16(F.REG_HSYNC0, 0)
    wr16(F.REG_HSYNC1, 41)

    wr16(F.REG_VSIZE, 272)
    wr16(F.REG_VCYCLE, 292)
    wr16(F.REG_VOFFSET, 12)
    wr16(F.REG_VSYNC0, 0)
    wr16(F.REG_VSYNC1, 10)



    --[[ 3) Enable or disable REG_CSPREAD with a value of 01h or 00h, respectively.
    -- Enabling REG_CSPREAD will offset the R, G and B output bits so all they do not all change at the same time
     ]]
    --wr8(F.REG_SWIZZLE, 0)
    wr8(F.REG_CSPREAD, 1)
end

function vm800_display_start()
    wr32(F.RAM_DL + 0, clear_color_rgb(0, 0, 0))
    wr32(F.RAM_DL + 4, clear(1, 1, 1))
    wr32(F.RAM_DL + 8, cmdAddress, 0); --DISPLAY()
    wr8(F.REG_DLSWAP, F.DLSWAP_FRAME) --//display list swap

    --Up until this point, no output has been generated on the LCD interface. With the configuration and
    --initial display list in place, the LCD DISP signal , backlight and pixel clock can now be turned on:
    wr8(F.REG_GPIO_DIR, 0x80)
    wr8(F.REG_GPIO, 0x80)
    wr8(F.REG_PWM_HZ, 0xfa)
    wr8(F.REG_PWM_DUTY, 0x80)
    wr8(F.REG_PCLK, 0x08) --;//after this display is visible on the LCD
end

cmdAddress = F.RAM_DL
function reset()
    cmdAddress = F.RAM_DL
    draw(clear_color_rgb(0xff, 0xff, 0xff))
    draw(clear(1, 1, 1))
end

function draw(data)
    wr32(cmdAddress, data)
    cmdAddress = cmdAddress + 4
end

function commit()
    wr32(cmdAddress, 0); --DISPLAY()
    wr8(F.REG_DLSWAP, F.DLSWAP_FRAME) --//display list swap

    --wr8(F.REG_GPIO_DIR, bor(0x80, rd8(F.REG_GPIO_DIR)))
    --    wr8(F.REG_GPIO_DIR, 0x80)
    --    wr8(F.REG_GPIO, 0x80)
end

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

for i, iPin in ipairs(lowPins) do
    --	print (iPin.." - "..i)
    pio.pin.setdir(pio.OUTPUT, iPin)
    pio.pin.setlow(iPin)
end


--SPI--

spi.setup(sid, spi.MASTER, 1e7, 0, 0, 8)
v800_init()
--    5) At this point, the Host MCU SPI Master can change the SPI clock up to 30 MHzZ
spi.setup(sid, spi.MASTER, 3e7, 0, 0, 8)
v800_display_config()
print("after display list")
vm800_display_start()
c = 0
dir = 1
while true do
    --    tmr.delay(0, 1000)
    reset()

    draw(color_rgb(0xff, c, 0xff - c / 2))
    draw(point_size(c * 9 + 48)); -- Set size to 320 / 16 = 20 pixels
    draw(begin(2)); -- Start the point draw
    draw(vertex2ii(c, 133, 0, 0));
    draw(d_end())
    commit()

    c = c + dir * 1
    if c < 0 or c > 255 then
        dir = -dir;
    end
end

--
--





--- -/* write first display list */

--

-- wr8(F.REG_GPIO, bor(0x80, rd8(F.REG_GPIO))) --;//enable display bit

----------------------

print("zapisandddddo")
