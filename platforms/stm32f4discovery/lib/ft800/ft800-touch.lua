--
-- Created by IntelliJ IDEA.
-- User: vmware
-- Date: 11/13/13
-- Time: 4:49 PM
-- To change this template use File | Settings | File Templates.
--
--wystarczy tylko zczytywac rejestry

function getRawTouch()
    return rd32(F.REG_TOUCH_RAW_XY)
end

function IsTouched()

end