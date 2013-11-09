csPin = pio.PB_11
pdPin = pio.PE_6
lowPins = { pio.PA_10, pio.PC_11, pdPin, csPin }
sid = 1

function send(data)
    local ret = spi.readwrite(sid, data)
    if ret == nil then
        print("\n--" .. data .. "--> ?? NIL")
    else
        print("\n--" .. data .. "--> ?? " .. ret[1])
    end
end

function csopen()
    pio.pin.setlow(csPin)
end

function csclose()
    pio.pin.sethigh(csPin)
end


for i, iPin in ipairs(lowPins) do
    --	print (iPin.." - "..i)
    pio.pin.setdir(pio.OUTPUT, iPin)
    pio.pin.setlow(iPin)
end

