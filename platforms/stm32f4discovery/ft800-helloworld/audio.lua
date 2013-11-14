--
-- Created by IntelliJ IDEA.
-- User: vmware
-- Date: 11/13/13
-- Time: 12:32 PM
-- To change this template use File | Settings | File Templates.
--

print("audio.lua example")


ft800_setup(SMALL_LCD) -- all things to get LCD display ready for drawing


pio.pin.setdir(pio.INPUT, pio.PA_0)


    --- BRIGHTNESS FADE IN ---

    --    if brightness < 110 then
    --        if c > 0.06 then
    --            brightness = brightness + 1
    --        end
    --        setBrightness(brightness)
    --    end

    -----------------------------

    reset((0x000000)) --8 bytes - param background color

    local x1, x2, y1, y2, dy, sp = 20, 20, 180, 10, 20, 15
    local f1, f2 = 31, 20
    local clr = 0x666633


    --shape.rectangle(x2 * 16 - 8 * 16, y2 * 16 - 5 * 16, 167 * 16, 82 * 16, 7 * 16, 0x001300, 255)



    --drawText("A. BOROWSKI", x2, y2, clr, 255, f2, sp)
    --drawText("P. CIEPLY", x2, y2 + 1 * dy, clr, 255, f2, sp)
    --drawText("T. LASSAUD", x2, y2 + 2 * dy, clr, 255, f2, sp)
    --drawText("M. RZYMSKI", x2, y2 + 3 * dy, clr, 255, f2, sp)
    --drawText("APLIKACJE SYSTEMOW WBUDOWANYCH 2013", x1 + x2, 250, 0xff3300, 255, 22, 12)

    --=================================--
   -- commit()
    --C4 sound, max volume, organ
    play_sound(0x3C,0xFF,0x44)
    --print("sound status: ", sound_status())

    --tmr.delay( 0, 800000 )
    print("---debug\n sound regs")
    print(" reg_vol_sound: ", rd8(F.REG_VOL_SOUND))
    print(" reg_sound: byte1: ", bat(rd16(F.REG_SOUND),2), " byte0: ", bat(rd16(F.REG_SOUND),1))
    print(" reg_play: ", rd8(F.REG_PLAY))
    print("sound status: ", sound_status())
    print("---debug")

print("end of audio.lua execution")
