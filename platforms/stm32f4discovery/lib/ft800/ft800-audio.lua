--
-- Created by IntelliJ IDEA.
-- User: vmware
-- Date: 11/13/13
-- Time: 12:31 PM
-- To change this template use File | Settings | File Templates.
--

--play sound
function play_sound(sound, volume_level, instrument)
    wr8(F.REG_VOL_SOUND, volume_level)  --  set the volume to maximum
    wr16(F.REG_SOUND, bor(lsh(sound,8), instrument))  -- C8 MIDI note on xylophone
    wr8(F.REG_PLAY, 1)       -- play the sound
end
--wr8(REG_VOL_SOUND,0xFF);
--wr16(REG_SOUND,(0x6C<<8)|0x41);
--wr8(REG_PLAY,1);


--check sound status
-- 1 - play is going on, 0 - play has finished
function sound_status()
    return rd8(F.REG_PLAY)
end