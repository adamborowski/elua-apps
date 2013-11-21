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

local commands, numBytes = {}, 0
function appendCommand(cmd) --please don't sent more than 1000 commands between flush
    numBytes = numBytes + 1
    commands[numBytes] = cmd
end


function flush()
    updateBufferState()
    print("read: " .. regCmdRead .. " write: " .. regCmdWrite .. " free: " .. freeSpace)
    --    while freeSpace < commandsSize do
    --        updateBufferState()
    --        tmr.delay(0, 500)
    --    end

    wrn(F.RAM_CMD + regCmdWrite, commands)
    --now tell the ft800 that there is more data in a buffer
    wr32(F.REG_CMD_WRITE, (regCmdWrite + numBytes) % 4096)
    commands = {}
    numBytes = 0
end
local co_write =0
function costart()
    co_write = rd32(F.REG_CMD_WRITE)
    wrstart(F.RAM_CMD+co_write)
end
function cobyte(byte)
    wrbyte(byte)
    co_write = co_write +1
end
function coend()
    wrend()
    wr32(F.REG_CMD_WRITE, co_write)
    co_read=rd32(F.REG_CMD_READ)
    print(string.format("REG_CMD_WRITE: %d REG_CMD_READ: %d", co_write, co_read))
end
