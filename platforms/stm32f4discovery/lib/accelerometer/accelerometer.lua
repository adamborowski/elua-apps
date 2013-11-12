-----------------
-- common func --
-----------------

---------------
-- constants --
---------------
local C = {
    CTRL_REG1 = 0x20,
    CTRL_REG2 = 0x21,
    CTRL_REG3 = 0x22,
    STATUS_REG = 0x27,
    OUT_X = 0x29,
    OUT_Y = 0x2B,
    OUT_Z = 0x2D,
    WHO_I_AM = 0x0F
}

-------------
-- program --
-------------
local function convertLSbToG(lsb)
    --
    -- 1 LSb = 4.6 g / 256 (Table 3, 8)
    --
    return lsb / 256 * 4.6
end

-- setting SPI communication
local SPI = {
    sid = 0,
    mode = spi.MASTER,
    clock = 100000000,
    cpol = 0,
    cpha = 0,
    word = 8
}

local PIN = {
    -- pins for SPI #0
    clk = pio.PA_5,
    mosi = pio.PA_7,
    cs = pio.PE_3,
    miso = pio.PA_6
}
local clock, xAddress, statusAddress, status, xG, yG, zG, xOut, yOut, zOut
accelerometer = {}
function accelerometer.init()
    clock = spi.setup(SPI.sid, SPI.mode, SPI.clock, SPI.cpol, SPI.cpha, SPI.word)
    io.write("\n")
    io.write('clock: ')
    io.write(clock)
    io.write("\n")
    io.flush()

    pio.pin.setdir(pio.OUTPUT, PIN.cs)
    pio.pin.sethigh(PIN.cs)

    --
    --- - initializing acc
    --
    -- CTRL_REG1 0100 0111 (100kHZ/active/fullscale/selftest-p||selftest-m/z/y/x)
    local ctrl1 = 0x47
    -- ctrl2 = 0x00 -- default
    --ctrl3 = 0x00 -- default

    pio.pin.setlow(PIN.cs)
    spi.write(SPI.sid, C.CTRL_REG1, ctrl1)
    pio.pin.sethigh(PIN.cs)

    -- wait 1ms
    tmr.delay(0, 1000)

    --
    --- - talking with acc
    --
    for i = 1, 3 do -- test WHO_I_AM
        local address = bit.set(C.WHO_I_AM, 7)
        pio.pin.setlow(PIN.cs)
        local ret = spi.readwrite(SPI.sid, address, 0x00)
        pio.pin.sethigh(PIN.cs)

        print(ret[2]) -- should print 0x3b (59)

        tmr.delay(0, 500)
    end

    -- read ZYX axis
    statusAddress = bit.set(C.STATUS_REG, 7) -- address |= 0x80
    xAddress = bit.set(C.OUT_X, 7)
    xAddress = bit.set(xAddress, 6) -- increment address
end

function accelerometer.get()

    pio.pin.setlow(PIN.cs)
    local ret = spi.readwrite(SPI.sid, statusAddress, 0x00)
    pio.pin.sethigh(PIN.cs)

    status = ret[2]

    if bit.isset(status, 3) then -- check ZYXDA is 1
        pio.pin.setlow(PIN.cs)
        ret = spi.readwrite(SPI.sid, xAddress, 0x00, 0x00, 0x00, 0x00, 0x00)
        pio.pin.sethigh(PIN.cs)

        xOut = ret[2]
        yOut = ret[4]
        zOut = ret[6]
        if xOut > 100 then xOut = xOut - 255 end
        if yOut > 100 then yOut = yOut - 255 end
        if zOut > 100 then zOut = zOut - 255 end

        -- todo: conversion LSb to G
        -- steps:
        -- -- find offset for each axis
        -- -- be smart on edge (near 0 and 255)
        -- -- check +/- values of G
        -- -- gdzie jest poziom 0, 0 LSb czy 127 LSb, jak to wpływa na wyniki
        -- --  i konwersję?
        xG = convertLSbToG(xOut - 1) -- where 1 is probably 0g-offset
        yG = convertLSbToG(yOut - 1)
        zG = convertLSbToG(zOut - 1)

--        io.write(string.format("%3d, %3d, %3d [%+2.6f, %+2.6f, %+2.6f]\n",
--            xOut, yOut, zOut, xG, yG, zG))
    end

    return xG, yG, zG
end

