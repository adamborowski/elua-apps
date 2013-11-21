function handle_finish()
    if uart.read(0xb0, 1, 0) ~= "" then
        return false
    end
    return true --this allows to continue looping
end

pio.pin.setdir(pio.OUTPUT, unpack(leds))

while handle_finish() do
    --------- ACCESS MODULES ------
    doGreen()
    doBlue()
    doRed()
    doOrange()
    -------- WAIT SOME TIME -------
    tmr.delay(0, 400000)
    pio.pin.setlow(unpack(leds))
    tmr.delay(0, 400000)
end
