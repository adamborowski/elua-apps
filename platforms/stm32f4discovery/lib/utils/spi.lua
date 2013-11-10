csPin = pio.PB_11
pio.pin.setdir(pio.OUTPUT, csPin)
sid = 1

function send(data)
    local ret = spi.readwrite(sid, data)
    if ret == nil then
        print("\n--" .. data .. "--> ?? NIL")
    else
        print("\n--" .. data .. "--> ?? " .. ret[1])
    end
end
-- chip select low
function csopen()
    pio.pin.setlow(csPin)
end

-- chip select high
function csclose()
    pio.pin.sethigh(csPin)
end

