local red, green, blue, orange = pio.PD_14, pio.PD_12, pio.PD_15, pio.PD_13
local leds = { green, orange, red, blue }
pio.pin.setdir(pio.OUTPUT, unpack(leds))
print('Autorun script executing.')
for i = 1, 15 do
    pio.pin.sethigh(unpack(leds))
    tmr.delay(0, 20000)
    pio.pin.setlow(unpack(leds))
    tmr.delay(0, 20000)
end
print('DONE...')