band = bit.band
bor = bit.bor
lsh = bit.lshift
rsh = bit.rshift


-- Press any key to end the main loop implementation:
function handle_interrupt()
    if uart.read(0xb0, 1, 0) ~= "" then
        makeAnyErrorToExit() -- this will exit elua execution
    end
    return true --this allows to continue looping
end
--return byte at position LSB
function bat(number, position)
    return band(rsh(number, position*8), 0xff)
end

function table_slice(values, i1, i2)
    local res = {}
    local n = #values
    -- default values for range
    i1 = i1 or 1
    i2 = i2 or n
    if i2 < 0 then
        i2 = n + i2 + 1
    elseif i2 > n then
        i2 = n
    end
    if i1 < 1 or i1 > n then
        return {}
    end
    local k = 1
    for i = i1, i2 do
        res[k] = values[i]
        k = k + 1
    end
    return res
end


---- MEASURE FPS ---------

local fpsmsr_lastTmr = tmr.read(1)
local fpsmsr_fps = 0
tmr.start(1)
local fpsmsr_buffer = {}
local fpsmsr_bufferSize = 33
for i = 1, fpsmsr_bufferSize do
    fpsmsr_buffer[i] = 0
end
local fpsmsr_sum = 0
function measureFPS()
    fpsmsr_bufferum = 0
    fpsmsr_fpscnt = 0
    fpsmsr_buffer[fpsmsr_bufferSize + 1] = 1000000 / tmr.getdiffnow(1, fpsmsr_lastTmr) -- excess item to move left
    for i = 1, fpsmsr_bufferSize do
        fpsmsr_buffer[i] = fpsmsr_buffer[i + 1]
        if fpsmsr_buffer[i] ~= 0 and i ~= 1 then -- prevent prebuffering increasing fps
            fpsmsr_bufferum = fpsmsr_bufferum + fpsmsr_buffer[i]
            fpsmsr_fpscnt = fpsmsr_fpscnt + 1
        end
    end
    tmr.start(1)
    fpsmsr_lastTmr = tmr.read(1)
    return fpsmsr_bufferum / fpsmsr_fpscnt
end
------------------------------

print ("UTILS MODULE FILE LOADED.")


