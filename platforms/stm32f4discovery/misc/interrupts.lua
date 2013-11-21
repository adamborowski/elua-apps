function handle_finish()
    if uart.read(0xb0, 1, 0) ~= "" then
        return false
    end
    return true --this allows to continue looping
end
leds = { pio.PD_12, pio.PD_13, pio.PD_14, pio.PD_15 }
interInput = pio.PA_2
interOutput = pio.PA_6
button = pio.PA_0

pio.pin.setdir(pio.OUTPUT, unpack(leds))
pio.pin.setdir(pio.OUTPUT, interOutput)
pio.pin.setdir(pio.INPUT, interInput, button)

local function interruptHandler(source)
    print(source)
    if source == button then
        print('button pressed')
        -- indicate press button
        for i = 1, 6 do
            pio.
            pio.pin.sethigh(unpack(leds))
            tmr.delay(0, 30000)
            pio.pin.setlow(unpack(leds))
            tmr.delay(0, 30000)
        end
        for i = 1, 1 do -- i = 1, 4
            pio.pin.setlow(interOutput)
            pio.pin.sethigh(interOutput)
            pio.pin.setlow(interOutput)
            tmr.delay(0, 1000000)
        end

    elseif source == interInput then
        print('external interrupt occured')
        pio.pin.sethigh(unpack(leds))
        tmr.delay(0, 1000000)
        pio.pin.setlow(unpack(leds))
    end

    if prev_gpio then prev_gpio(source) end
end

--POSEDGE
prev_gpio = cpu.set_int_handler(cpu.INT_GPIO_POSEDGE, interruptHandler)
cpu.sei(cpu.INT_GPIO_POSEDGE, interInput, button)

----------------------------------------------------------

state = 0
while handle_finish() do
    pio.pin.setlow(leds[state + 1])
    pio.pin.sethigh(leds[(state + 1) % 4 + 1])
    state = (state + 1) % 4
    tmr.delay(0, 85000)
end
pio.pin.setlow(unpack(leds))
print("THE END!")