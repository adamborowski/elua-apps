function handle_finish()
    if uart.read(0xb0, 1, 0) ~= "" then
        return false
    end
    return true --this allows to continue looping
end

function wait(msc)
    tmr.delay(0, msc * 1000*0.2)
end

local red, green, blue, orange = pio.PD_14, pio.PD_12, pio.PD_15, pio.PD_13
local leds = { green, orange, red, blue }
pio.pin.setdir(pio.OUTPUT, unpack(leds))


---------------------------------------------
while handle_finish() do
    pio.pin.sethigh(green)
    wait(60)
    pio.pin.sethigh(orange)
    wait(80)
    pio.pin.sethigh(red)
    wait(100)
    pio.pin.sethigh(blue)
    wait(300)
    -----------------
    pio.pin.setlow(blue)
    wait(100)
    pio.pin.setlow(red)
    wait(100)
    pio.pin.setlow(orange)
    wait(100)
    pio.pin.setlow(green)
    wait(150)
end
