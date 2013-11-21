print("ft800.lua raw coding example")
local buttonPressed = false
function pause()
    while true do
        buttonDown = pio.pin.getval(pio.PA_0) == 1
        if buttonPressed and not buttonDown then
            buttonPressed = false
        elseif not buttonPressed and buttonDown then
            buttonPressed = true
            return
        end
    end
end

-------- WAKE UP FTDI ----------


ft800_setup(SMALL_LCD)


------- WRITE TO REGISTER EXAMPLE: BRIGHTNESS------

wr32(F.REG_PWM_HZ, 2)
wr32(F.REG_PWM_DUTY, 10)
pause()
wr32(F.REG_PWM_HZ, 2)
wr32(F.REG_PWM_DUTY, 85)
pause()
wr32(F.REG_PWM_HZ, 300)
wr32(F.REG_PWM_DUTY, 40)
pause()
wr32(F.REG_PWM_HZ, 300)
wr32(F.REG_PWM_DUTY, 128)
pause()
------ DISPLAY LIST

local dl = F.RAM_DL
------ display list commands -----
local background=0xffcc99
wr32(dl+0, 0x02000000 + background)
wr32(dl+4, 0x26000007) -- set backround color command


local color = 0xff0000
wr32(dl + 8, 0x04000000 + color) -- change color command

local size = 20 * 16
wr32(dl + 12, 0x0d000000 + size) -- change line size command

local primitiveType = 2 -- 2 = POINTS
wr32(dl + 16, 0x1f000000 + primitiveType) -- begin drawing points command

local x, y = 200 * 16, 100 * 16
wr32(dl + 20, 0x40000000 + lsh(x, 15) + y) -- add point at x and y command

wr32(dl + 24, 0x21000000) -- end drawing points command

wr32(dl + 28, 0x00000000) -- the end of display list command

-------- SWAP display lists ---------

wr8(F.REG_DLSWAP, F.DLSWAP_FRAME) --//display list swap


