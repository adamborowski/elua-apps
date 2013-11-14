print('lua commands example')
ft800_setup(SMALL_LCD)
msc = 0

function cmd_number(x, y, font, opts, n)
    appendCommand(0x2e) -- +0
    appendCommand(0xff)
    appendCommand(0xff)
    appendCommand(0xff)


    appendCommand(x) -- +4
    appendCommand(0)

    appendCommand(y) -- +6
    appendCommand(0)

    appendCommand(font)
    appendCommand(0)

    appendCommand(opts)
    appendCommand(0)

    appendCommand(n)
    appendCommand(0)
    appendCommand(0)
    appendCommand(0)
end

function dial(x, y, r, o, val)
    --    + 0 CMD_DIAL(0xffffff2d)
    appendCommand(0x2d)
    appendCommand(0)
    appendCommand(0)
    appendCommand(0)
    --    + 4 X
    appendCommand(x)
    appendCommand(0)
    --    + 6 Y
    appendCommand(y)
    appendCommand(0)
    --    + 8 r
    appendCommand(r)
    appendCommand(0)
    --    + 10 options
    appendCommand(o)
    appendCommand(0)
    --    + 12 val
    appendCommand(val)
    appendCommand(0)
    appendCommand(0)
    appendCommand(0)
end

while handle_interrupt() do

    --    reset(0x000000)
    --    local x1, y1,x2, y2 = 10, 10, 10, 10
    --    shape.rectangle(x2 * 16 - 8 * 16, y2 * 16 - 5 * 16, 167 * 16, 82 * 16, 17 * 16, 0xffcc33, 144)
    --    commit()
    --[[
    +0 CMD_CLOCK(0xffffff14)
    +4 X
    +6 Y
    +8 R
    +10 Options
    +12 H
    +14 M
    +16 S
+18 Ms
     ]]
    --    appendCommand(0xffffff14)
    --    appendCommand(80)
    --    appendCommand(60)
    --    appendCommand(50)
    --    appendCommand(0)
    --    appendCommand(8)
    --    appendCommand(56)
    --    appendCommand((msc / 1000) % 60)
    --    appendCommand(0)
    --    tmr.delay(0, 1000000)
    --    msc = msc + 1000
    --    print((msc / 1000) % 60)
    --    flush()
    --    appendCommand(0x31)
    --    appendCommand(0xff)
    --    appendCommand(0xff)
    --    appendCommand(0xff)
    --    cmd_number(20, 60, 31, 0, 42)
    dial(80, 60, 55, 0, 0x0000);
    flush()
    tmr.delay(0, 1000000)
end