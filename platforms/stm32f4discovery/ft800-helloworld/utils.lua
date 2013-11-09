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


print ("UTILS MODULE FILE LOADED.")


