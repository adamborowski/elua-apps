function cmd(data)
    csopen()
    spi.write(sid, data, 0x00, 0x00)
    csclose()
    tmr.delay(0, 10000)
end

local addr1, addr2, addr3, data1, data2, data3, data4
--[[
@param address 22 bit adress
@param data 2 bytes data
--]]
function wr16(address, data)
    csopen()
    addr1 = rsh(address, 16) + 128
    addr2 = band(rsh(address, 8), 0xff)
    addr3 = band(address, 0xff)
    data1 = band(data, 0xff)
    data2 = band(rsh(data, 8), 0xff)
    spi.write(sid, addr1, addr2, addr3, data1, data2)
    csclose()
end

--[[
@param address 22 bit adress
@param data 4 bytes data
--]]
function wr32(address, data)
    csopen()
    addr1 = rsh(address, 16) + 128
    addr2 = band(rsh(address, 8), 0xff)
    addr3 = band(address, 0xff)
    data1 = band(data, 0xff)
    data2 = band(rsh(data, 8), 0xff)
    data3 = band(rsh(data, 16), 0xff)
    data4 = band(rsh(data, 24), 0xff)
    spi.write(sid, addr1, addr2, addr3, data1, data2, data3, data4)
    csclose()
end

--[[
@param address 22 bit adress
@param data 1 byte data
--]]
function wr8(address, data)
    csopen()
    addr1 = rsh(address, 16) + 128
    addr2 = band(rsh(address, 8), 0xff)
    addr3 = band(address, 0xff)
    spi.write(sid, addr1, addr2, addr3, data)
    csclose()
end

--[[
@param address 22 bit adress
@ param data array of bytes
 ]]
function wrn(address, bytes)
    csopen()
    addr1 = rsh(address, 16) + 128
    addr2 = band(rsh(address, 8), 0xff)
    addr3 = band(address, 0xff)
--    spi.write(sid, addr1, addr2, addr3, unpack(table_slice(bytes, 1, howMuch)))
    spi.write(sid, addr1, addr2, addr3, unpack(bytes))
    csclose()
end

--[[
@param address 22 bit adress
--]]
function rd8(address)
    csopen()
    addr1 = rsh(address, 16) + 0
    addr2 = band(rsh(address, 8), 0xff)
    addr3 = band(address, 0xff)
    local ret = spi.readwrite(sid, addr1, addr2, addr3, 0x00, 0x00) -- dummy byte and one byte for answer
    csclose()
    return ret[5]
end

--[[
@param address 22 bit adress
--]]
function rd16(address)
    csopen()
    addr1 = rsh(address, 16) + 0
    addr2 = band(rsh(address, 8), 0xff)
    addr3 = band(address, 0xff)
    local ret = spi.readwrite(sid, addr1, addr2, addr3, 0x00, 0x00, 0x00) -- dummy byte and two bytes for answer
    csclose()
    return bor(ret[5], lsh(ret[6], 8))
end


--[[
@param address 22 bit adress
--]]
function rd32(address)
    csopen()
    addr1 = rsh(address, 16) + 0
    addr2 = band(rsh(address, 8), 0xff)
    addr3 = band(address, 0xff)
    local ret = spi.readwrite(sid, addr1, addr2, addr3, 0x00, 0x00, 0x00, 0x00, 0x00) -- dummy byte and four bytes for answer
    csclose()
    return bor(ret[5], lsh(ret[6], 8), lsh(ret[7], 16), lsh(ret[8], 24))
end



function ft800_init()
    pdPin = pio.PE_6
    pio.pin.setdir(pio.OUTPUT, pdPin)
    --    1) Reset the FT800
    --      -  Drive PD_N low
--    print("pin low")
    pio.pin.setlow(pdPin)
--    print("pin low set")
    --      -  Wait 20ms
    tmr.delay(0, 20000)
    --      - back to high state
--    print("pin high")
    pio.pin.sethigh(pdPin)
--    print("pin high set")
    --      -  Wait for 20 ms
    tmr.delay(0, 20000)
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

function ft800_display_config(SMALL_LCD)

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



    if SMALL_LCD then
        wr8(F.REG_PCLK_POL, 0)
        wr16(F.REG_HSIZE, 320)
        wr16(F.REG_HCYCLE, 408)
        wr16(F.REG_HOFFSET, 70)
        wr16(F.REG_HSYNC0, 0)
        wr16(F.REG_HSYNC1, 10)

        wr16(F.REG_VSIZE, 240)
        wr16(F.REG_VCYCLE, 263)
        wr16(F.REG_VOFFSET, 13)
        wr16(F.REG_VSYNC0, 0)
        wr16(F.REG_VSYNC1, 2)
    else
        wr8(F.REG_PCLK_POL, 1)
        wr16(F.REG_HSIZE, 480)
        wr16(F.REG_HCYCLE, 548)
        wr16(F.REG_HOFFSET, 43)
        wr16(F.REG_HSYNC0, 0)
        wr16(F.REG_HSYNC1, 41) --
        wr16(F.REG_VSIZE, 272)
        wr16(F.REG_VCYCLE, 292)
        wr16(F.REG_VOFFSET, 12)
        wr16(F.REG_VSYNC0, 0)
        wr16(F.REG_VSYNC1, 10)
    end


    --[[ 3) Enable or disable REG_CSPREAD with a value of 01h or 00h, respectively.
    -- Enabling REG_CSPREAD will offset the R, G and B output bits so all they do not all change at the same time
     ]]
    --    wr8(F.REG_SWIZZLE, 0)
    wr8(F.REG_CSPREAD, 0)
end

function ft800_display_start()
    wr32(F.RAM_DL + 0, clear_color_rgb3(0, 0, 0))
    wr32(F.RAM_DL + 4, clear(1, 1, 1))
    wr32(F.RAM_DL + 8, 0); --DISPLAY()
    wr8(F.REG_DLSWAP, F.DLSWAP_FRAME) --//display list swap

    --Up until this point, no output has been generated on the LCD interface. With the configuration and
    --initial display list in place, the LCD DISP signal , backlight and pixel clock can now be turned on:
    wr8(F.REG_GPIO_DIR, 0x80)
    wr8(F.REG_GPIO, 0x80)
    wr8(F.REG_PWM_DUTY, 100) -- brightness, max 128
    wr32(F.REG_PWM_HZ, 300) -- blinking from 250 to 10000 (10 is seen as light pulsing, 250 is not able to see pulsing)
    wr8(F.REG_PCLK, 0x08) --;//after this display is visible on the LCD
end

function ft800_setup(SMALL_LCD)
    spi.setup(sid, spi.MASTER, 1e7, 0, 0, 8)
    ft800_init()
    --    5) At this point, the Host MCU SPI Master can change the SPI clock up to 30 MHzZ
    spi.setup(sid, spi.MASTER, 30000000, 0, 0, 8)
    ft800_display_config(SMALL_LCD) -- true is small lcs
    ft800_display_start()
end


--[[
-- DISPLAY LIST MANAGEMENT
 ]]

local drawCommands = {} -- growing table but reused
local drawCommandCounter = 0
function getNumCommands()
    return drawCommandCounter/4
end
function reset(color)
    drawCommandCounter = 0
    --FIXME now it is faster to not create new table but now it sends possibly unused commands when next displaylist is smaller
    --drawCommands={}
    draw(clear_color_rgb1(color))
    draw(clear(1, 1, 1))
end

function draw(data)
    --indexing from 1, so first is +1 not +0
    drawCommands[drawCommandCounter + 1] = bat(data, 0)
    drawCommands[drawCommandCounter + 2] = bat(data, 1)
    drawCommands[drawCommandCounter + 3] = bat(data, 2)
    drawCommands[drawCommandCounter + 4] = bat(data, 3)
    drawCommandCounter = drawCommandCounter + 4
end


function commit()
    finishDrawing() --- ft800-drawing must do some finish job
    draw(0) -- end()
    wrn(F.RAM_DL, drawCommands) --flush all cached commands in one spi transaction
    wr8(F.REG_DLSWAP, F.DLSWAP_FRAME) --//display list swap
end
--[[
 @value from 0 to 128
 ]]
function setBrightness(value)
    wr8(F.REG_PWM_DUTY, value)
end
