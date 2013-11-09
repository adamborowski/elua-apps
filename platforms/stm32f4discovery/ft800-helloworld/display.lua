


print("display.lua example")




---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
print(1.78 / 7.5)
print(0xffffffff)
print(123456.8)
function frameLoop()
    c = 0
    dir = 1
    while handle_interrupt() do
        reset((0x000000))

        draw(color_rgb3(0xff, c, 0xff - c / 2))
        --        draw(point_size(c * 9 + 48)); -- Set size to 320 / 16 = 20 pixels
        draw(point_size(400)); -- Set size to 320 / 16 = 20 pixels
        draw(begin(2)); -- Start the point draw
        draw(vertex2ii(c, 220, 0, 0));
        draw(d_end())


        local x1, x2, y1, y2, dy = 10, 20, 10, 40, 17
        local f1, f2 = 31, 20
        makeText("DAC SYSTEM", x1, y1, 0xF57910, f1, 26)
        makeText("ADAM   BOROWSKI", x1 + x2, y2 + dy, 0x444444, f2, 10)
        makeText("PAWEL  CIEPLY", x1 + x2, y2 + 2 * dy, 0x444444, f2, 10)
        makeText("TOMASZ LASSAUD", x1 + x2, y2 + 3 * dy, 0x444444, f2, 10)
        makeText("MACIEJ RZYMSKI", x1 + x2, y2 + 4 * dy, 0x444444, f2, 10)

        makeText("APLIKACJE SYSTEMOW WBUDOWANYCH 2013", x1 + x2, 250, 0xff3300, 22, 12)











        -- do tego momenrtu dzialalo

        --        -- a tu probujemy zrobic tekst
        --        draw(color_rgb(0xff, 0x00, 0x00))
        --        draw(0xffffff0c)
        --        draw_small(10)  -- x
        --        draw_small(10)  -- y
        --        draw_small(31) --font type
        --        draw_small(0) -- options
        --        draw_small(0x41)
        --      --  draw_small(0) -- string end
        --        draw(d_end())
        --        -------

        commit()

        c = c + dir * 1
        if c < 0 or c > 255 then
            dir = -dir;
        end
    end
end


--SPI--

spi.setup(sid, spi.MASTER, 1e7, 0, 0, 8)
v800_init()
--    5) At this point, the Host MCU SPI Master can change the SPI clock up to 30 MHzZ
spi.setup(sid, spi.MASTER, 30000000, 0, 0, 8)
v800_display_config()
print("after display list")
vm800_display_start()

print("odczyt: " .. rd8(0x0C0000) .. " / " .. rd8(0x0C0001) .. " / " .. rd8(0x0C0002) .. " / " .. rd8(0x0C0003))

frameLoop()


--
--





--- -/* write first display list */

--

-- wr8(F.REG_GPIO, bor(0x80, rd8(F.REG_GPIO))) --;//enable display bit

----------------------

print("zapisandddddo")
