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

local lastTmr = tmr.read(1)
local fps = 0
tmr.start(1)
local fpss = {}
local fpsBufSize = 33
for i = 1, fpsBufSize do
    fpss[i] = 0
end
local fpssum = 0
function measureFPS()
    fpssum = 0
    fpscnt = 0
    fpss[fpsBufSize + 1] = 1000000 / tmr.getdiffnow(1, lastTmr) -- excess item to move left
    for i = 1, fpsBufSize do
        fpss[i] = fpss[i + 1]
        if fpss[i] ~= 0 and i ~= 1 then -- prevent prebuffering increasing fps
            fpssum = fpssum + fpss[i]
            fpscnt = fpscnt + 1
        end
    end
    fps = fpssum / fpscnt
    tmr.start(1)
    lastTmr = tmr.read(1)
    return fps
end
------------------------------

print ("UTILS MODULE FILE LOADED.")


