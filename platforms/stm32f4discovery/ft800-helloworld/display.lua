print("display.lua example")

function e(ratio) -- values from 0 to 1 in looping shape
    ratio = ratio * 2 * math.pi
    return (math.sin(ratio) + 1) / 2
end


function ball(x, y, s, c1, c2, c3) --s  = depth phase
    shape.circle(16 * (x * 400 + 30), y * 16 * 50+575, 300 * e(c + s + 0.25) + 200,
        rgb(c1 * 0xcc, c2 * 0xcc, c3 * 0xcc), e(c + s + 0.25) * 0xcc + 0x33)
end

ft800_setup(SMALL_LCD) -- all things to get LCD display ready for drawing
c = 0
brightness = 0
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
    --        lastTmr = tmr.read(0)
    --

    reset((0x000000)) --8 bytes - param background color


    --        tmr.delay(0, c * 50000)
    local x1, x2, y1, y2, dy = 10, 20, 10, 40, 17
    local f1, f2 = 31, 20


    drawText(math.floor(fps) .. "FPS", 410, 3, 0x333333, 255, 23, 13)

    drawText("DAC SYSTEM ", x1, y1, 0xF57910, 255, f1, 26)
    drawText("A. BOROWSKI", x1 + x2, y2 + dy, 0x444444, 255, f2, 10)
    drawText("P. CIEPLY", x1 + x2, y2 + 2 * dy, 0x444444, 255, f2, 10)
    drawText("T. LASSAUD", x1 + x2, y2 + 3 * dy, 0x444444, 255, f2, 10)
    drawText("M. RZYMSKI", x1 + x2, y2 + 4 * dy, 0x444444, 255, f2, 10)
    drawText("APLIKACJE SYSTEMOW WBUDOWANYCH 2013", x1 + x2, 250, 0xff3300, 255, 22, 12)
    --
    eas1 = e(c + 0.0)
    eas2 = e(c + .2)
    eas3 = e(c + .4)
    eas4 = e(c + .6)
    eas5 = e(c + .8)

    ball(eas1, 0, 0, eas2, eas3, eas4)
    ball(eas2, 1, 0.2, eas3, eas4, eas5)
    ball(eas3, 2, 0.4, eas4, eas5, eas1)
    ball(eas4, 3, 0.6, eas5, eas1, eas2)
    ball(eas5, 4, 0.8, eas1, eas2, eas3)




    drawText(getNumCommands() .. "#", 431, 31, 0x774422, 255, 21, 10)
    commit()

    c = c + 0.008
end


print("end of display.lua execution")