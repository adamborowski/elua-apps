print("display.lua example")

function e(ratio) -- values from 0 to 1 in looping shape
    ratio = ratio * 2 * math.pi
    return (math.sin(ratio) + 1) / 2
end

local ballStartY = 450
function ball(s) --s  = depth phase
    shape.circle(16 * (e(c + s) * 400 + 30), 5 * s * 16 * 50 + ballStartY, 300 * e(c + s + 0.25) + 200,
        rgb(e(c + s + 0) * 0xcc, e(c + s + 0.3) * 0xcc, e(c + s + 0.6) * 0xcc), e(c + s + 0.25) * 0xcc + 0x33)
end

ft800_setup(SMALL_LCD) -- all things to get LCD display ready for drawing
c = 0
brightness = 0
local direction = 1
directionChar = ">"
local pressed = false
local speed = 0.004
pio.pin.setdir(pio.INPUT, pio.PA_0)
while handle_interrupt() do
    --- BRIGHTNESS FADE IN ---

    if brightness < 110 then
        if c > 0.06 then
            brightness = brightness + 1
        end
        setBrightness(brightness)
    end


    -----------------------------
    fps = measureFPS()

    reset((0x000000)) --8 bytes - param background color

    local x1, x2, y1, y2, dy, sp = 20, 20, 180, 10, 20, 15
    local f1, f2 = 31, 20
    local clr = 0x666633


    shape.rectangle(x2 * 16 - 8 * 16, y2 * 16 - 5 * 16, 167 * 16, 82 * 16, 7 * 16, 0x001300, 255)

    drawText(math.floor(fps) .. "FPS", 410, 3, 0x333333, 255, 23, 13)

    drawText("A. BOROWSKI", x2, y2, clr, 255, f2, sp)
    drawText("P. CIEPLY", x2, y2 + 1 * dy, clr, 255, f2, sp)
    drawText("T. LASSAUD", x2, y2 + 2 * dy, clr, 255, f2, sp)
    drawText("M. RZYMSKI", x2, y2 + 3 * dy, clr, 255, f2, sp)
    drawText("APLIKACJE SYSTEMOW WBUDOWANYCH 2013", x1 + x2, 250, 0xff3300, 255, 22, 12)

    --=================================--

    for i = 0, 6 / 7, 1 / 7 do
        ball(i)
    end

    shape.rectangle(x1 * 16 - 8 * 16, y1 * 16 - 3 * 16, 286 * 16, 52 * 16, 7 * 16, 0x031212, 200)
    drawText("DAC SYSTEM ", x1, y1, 0xF57910, 255, f1, 26)


    new_pressed = pio.pin.getval(pio.PA_0) == 1

    if new_pressed and not pressed then
        direction = -direction
        directionChar = direction > 0 and ">" or "<"
    end
    pressed = new_pressed
    --
    if pressed then
        speed = speed + 0.0005 * direction
    end

    shape.rectangle(448 * 16, 58 * 16, 22 * 16, 22 * 16, 3 * 16, (pressed and 0xcc00cc or 0x450045), 200)
    drawText(directionChar, 453, 53, 0x000000, 255, 29, 10)
    drawText(getNumCommands() .. "#", 431, 31, 0x774422, 255, 21, 10)
    commit()
    c = c + speed
end


print("end of display.lua execution")