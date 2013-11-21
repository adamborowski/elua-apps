print('lua commands example')
ft800_setup(SMALL_LCD)

while handle_interrupt() do
    -- komenda czterobajtowa pokazująca logo przez 3 sekundy

    appendCommand(0x31)
    appendCommand(0xff)
    appendCommand(0xff)
    appendCommand(0xff)
    flush()
    tmr.delay(0, 1000000)
end