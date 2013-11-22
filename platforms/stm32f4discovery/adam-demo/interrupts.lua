leds = { pio.PD_12, pio.PD_13, pio.PD_14, pio.PD_15 }
pio.pin.setdir(pio.OUTPUT, unpack(leds))

local function interruptHandler(resourceID)

    for i = 1, 6 do
        pio.pin.sethigh(unpack(leds))
        tmr.delay(0, 30000)
        pio.pin.setlow(unpack(leds))
        tmr.delay(0, 30000)
    end
    if prev_handler then prev_handler(resourceID) end
end

prev_handler = cpu.set_int_handler(cpu.INT_GPIO_POSEDGE, interruptHandler)
cpu.sei(cpu.INT_GPIO_POSEDGE, pio.PA_0)

----------------------------------------------------------

state = 0
while true do
    pio.pin.setlow(leds[state + 1])
    pio.pin.sethigh(leds[(state + 1) % 4 + 1])
    state = (state + 1) % 4
    tmr.delay(0, 300000)
end
