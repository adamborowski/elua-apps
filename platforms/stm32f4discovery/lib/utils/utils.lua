band = bit.band
bor = bit.bor
lsh = bit.lshift
function rsh(value, shift)
    v=bit.rshift(value, shift)
--    print  ('rsh: '..((value> 2147483647) and "wiekszy" or "niestety"))
    if value > 2147483647 then -- bug: bit.isset(0xffffffff, 31) must be 1 not 0
--        print (' KOKOKOKOKOKO ')
        v=bit.set(v, 31-shift)
    end
    return v
end


-- Press any key to end the main loop implementation:
function handle_interrupt()
    if uart.read(0xb0, 1, 0) ~= "" then
        makeAnyErrorToExit() -- this will exit elua execution
    end
    return true --this allows to continue looping
end

--return byte at position LSB
function bat(number, position)
    return band(rsh(number, position * 8), 0xff)
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


--- - MEASURE FPS ---------

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

function rgb(r, g, b)
    return b + lsh(g, 8) + lsh(r, 16)
end

------------------------------ buffer with AVG aggregation
utils = {}
utils.buffer = {}
function utils.buffer.new(size)
    local obj = {}
    local data = {}
    local sum=0
    local count = 0
    obj.put = function(val)
        if count < size then -- as long as buffer increasing we can increase sum and return sum/count
            count = count + 1
            data[count] = val
            sum = sum + val
            return sum / count
        end
        -- buffer do not increase - recalculate avg
        sum = 0
        data[count + 1] = val -- this external value will be moved in loop below
        for i = 1, size do
            data[i] = data[i + 1]
            sum = sum + data[i]
        end

        return sum / count
    end
    obj.size=size
    return obj
end

print("UTILS MODULE FILE LOADED.")