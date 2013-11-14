--[[
    fullness = (REG_CMD_WRITE -REG_CMD_READ) mod 4096
    freespace = (4096 - 4) -fullness;
 ]]
local regCmdWrite, regCmdRead, freeSpace = 0, 0, 0
local function updateBufferState()
    regCmdWrite = rd16(F.REG_CMD_WRITE)
    regCmdRead = rd16(F.REG_CMD_READ)
    freeSpace = 4092 - ((regCmdWrite - regCmdRead) % 4096)

end

local commands, numBytes={}, 0
function appendCommand(cmd) --please don't sent more than 1000 commands between flush
    numBytes = numBytes + 1
    commands[numBytes] = cmd
end


function flush()
    updateBufferState()
    --    while freeSpace < commandsSize do
    --        updateBufferState()
    --        tmr.delay(0, 500)
    --    end

    wrn(F.RAM_CMD + regCmdWrite, commands)
    --now tell the ft800 that there is more data in a buffer
    print("read: " .. regCmdRead .. " write: " .. regCmdWrite .. " free: " .. freeSpace)
    wr32(F.REG_CMD_WRITE, (regCmdWrite + numBytes) % 4096)
    commands = {}
    numBytes= 0
end