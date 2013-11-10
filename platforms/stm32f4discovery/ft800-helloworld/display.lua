print("display.lua example")

function e(ratio) -- values from 0 to 1 in looping shape
    ratio = ratio * 2 * math.pi
    return (math.sin(ratio) + 1) / 2
end


ft800_setup(SMALL_LCD) -- all things to get LCD display ready for drawing
c = 0
while handle_interrupt() do
    fps = measureFPS()
    --        lastTmr = tmr.read(0)
    --
    eas1 = e(c * 3 + 0.0)
    eas2 = e(c * 3 + .2)
    eas3 = e(c * 3 + .4)
    eas4 = e(c * 3 + .6)
    eas5 = e(c * 3 + .8)
    reset((0x000000)) --8 bytes


    --        tmr.delay(0, c * 50000)

    draw(begin(2)); -- Start the point draw


    draw(color_rgb3(eas2 * 0xcc, eas3 * 0xcc, eas4 * 0xcc))
    draw(point_size(300 * eas2 + 200)); -- Set size to 320 / 16 = 20 pixels
    draw(vertex2ii(eas1 * 400 + 30, 40, 0, 0))

    draw(color_rgb3(eas3 * 0xcc, eas4 * 0xcc, eas1 * 0xcc))
    draw(point_size(300 * eas3 + 200)); -- Set size to 320 / 16 = 20 pixels
    draw(vertex2ii(eas2 * 400 + 30, 80, 0, 0))

    draw(color_rgb3(eas4 * 0xcc, eas1 * 0xcc, eas2 * 0xcc))
    draw(point_size(300 * eas4 + 200)); -- Set size to 320 / 16 = 20 pixels
    draw(vertex2ii(eas3 * 400 + 30, 120, 0, 0))

    draw(color_rgb3(eas1 * 0xcc, eas2 * 0xcc, eas3 * 0xcc))
    draw(point_size(300 * eas5 + 200)); -- Set size to 320 / 16 = 20 pixels
    draw(vertex2ii(eas4 * 400 + 30, 180, 0, 0))

    draw(color_rgb3(eas2 * 0xcc, eas3 * 0xcc, eas4 * 0xcc))
    draw(point_size(200 * eas1 + 300)); -- Set size to 320 / 16 = 20 pixels
    draw(vertex2ii(eas5 * 400 + 30, 240, 0, 0))

    draw(d_end())

    draw(begin(1)) -- now we draw text
    local x1, x2, y1, y2, dy = 10, 20, 10, 40, 17
    local f1, f2 = 31, 20


    makeText(math.floor(fps) .. "FPS", 410, 3, 0x333333, 23, 13)

    makeText("DAC SYSTEM ", x1, y1, 0xF57910, f1, 26)
    makeText("A. BOROWSKI", x1 + x2, y2 + dy, 0x444444, f2, 10)
    makeText("P. CIEPLY", x1 + x2, y2 + 2 * dy, 0x444444, f2, 10)
    makeText("T. LASSAUD", x1 + x2, y2 + 3 * dy, 0x444444, f2, 10)
    makeText("M. RZYMSKI", x1 + x2, y2 + 4 * dy, 0x444444, f2, 10)
    makeText("APLIKACJE SYSTEMOW WBUDOWANYCH 2013", x1 + x2, 250, 0xff3300, 22, 12)
    --
    draw(d_end())

    commit()
    c = c + 0.001
end


print("end of display.lua execution")