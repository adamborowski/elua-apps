print("display.lua example")
F = {
	DLSWAP_FRAME = 2,
	RAM_CMD = 1081344,
	RAM_DL = 1048576,
	RAM_G = 0,
	RAM_PAL = 1056768,
	RAM_REG = 1057792,
	REG_CSPREAD = 1057892,
	REG_DATESTAMP = 1058108,
	REG_GPIO = 1057936,
	REG_GPIO_DIR = 1057932,
	REG_HCYCLE = 1057832,
	REG_HOFFSET = 1057836,
	REG_HSIZE = 1057840,
	REG_HSYNC0 = 1057844,
	REG_HSYNC1 = 1057848,
	REG_ID = 1057792,
	REG_INT_EN = 1057948,
	REG_INT_FLAGS = 1057944,
	REG_OUTBITS = 1057880,
	REG_PCLK = 1057900,
	REG_PCLK_POL = 1057896,
	REG_SWIZZLE = 1057888,
	REG_TRACKER = 1085440,
	REG_VCYCLE = 1057852,
	REG_VOFFSET = 1057856,
	REG_VOL_PB = 1057916,
	REG_VOL_SOUND = 1057920,
	REG_VSIZE = 1057860,
	REG_VSYNC0 = 1057864,
	REG_VSYNC1 = 1057868,
	REG_DLSWAP = 1057872,
}

lowPins= {pio.PA_10, pio.PC_11, pio.PA_2, pio.PB_11}
csPin=lowPins[4]
local sid=1
function wr(raw_data)
	pio.pin.setlow(csPin)
	spi.write(sid, raw_data)
	pio.pin.sethigh(csPin)
end
function send(data)
	local ret=spi.readwrite(sid, data)
	if ret==nil then 
		print( "\n--"..data.."--> ?? NIL")
	else
		print( "\n--"..data.."--> ?? "..ret[1])
	end
end
function csopen()
	pio.pin.setlow(csPin)
end
function csclose()
	pio.pin.sethigh(csPin)
end
function cmd(data)
	csopen()
	spi.write(sid, data, 0x00, 0x00)
	csclose()
	tmr.delay(0, 10000)
end
--[[
@param address 22 bit adress
@param data 2 bytes data
--]]
function wr16(address, data)
	csopen()
	local addr1=bit.rshift(address, 16)+128
	local addr2=bit.band(bit.rshift(address, 8), 0xff)
	local addr3=bit.band(address, 0xff)
	local data1=bit.band(data, 0xff)
	local data2=bit.band(bit.rshift(data, 8), 0xff)
	spi.readwrite(sid, addr1, addr2, addr3, data1, data2)
	csclose()
end
--[[
@param address 22 bit adress
@param data 4 bytes data
--]]
function wr32(address, data)
	csopen()
	local addr1=bit.rshift(address, 16)+128
	local addr2=bit.band(bit.rshift(address, 8), 0xff)
	local addr3=bit.band(address, 0xff)
	local data1=bit.band(data, 0xff)
	local data2=bit.band(bit.rshift(data, 8), 0xff)
	local data3=bit.band(bit.rshift(data, 16), 0xff)
	local data4=bit.band(bit.rshift(data, 24), 0xff)
	spi.readwrite(sid, addr1, addr2, addr3, data1, data2, data3, data4)
	csclose()
end
--[[
@param address 22 bit adress
@param data 1 byte data
--]]
function wr8(address, data)
	csopen()
	local addr1=bit.rshift(address, 16)+128
	local addr2=bit.band(bit.rshift(address, 8), 0xff)
	local addr3=bit.band(address, 0xff)
	spi.readwrite(sid, addr1, addr2, addr3, data)
	csclose()
end

--[[
@param address 22 bit adress
--]]
function rd8(address)
	csopen()
	local addr1=bit.rshift(address, 16)+0
	local addr2=bit.band(bit.rshift(address, 8), 0xff)
	local addr3=bit.band(address, 0xff)
	local ret=spi.readwrite(sid,addr1, addr2, addr3, 0x00, 0x00) -- dummy byte and one byte for answer
	print("readwrite byte[1]"..ret[1])
	print("readwrite byte[2]"..ret[2])
	print("readwrite byte[3]"..ret[3])
	print("readwrite byte[4]"..ret[4])
	print("readwrite byte[5]"..ret[5])
	csclose()
	return ret[5]
end

--#define CLEAR_COLOR_RGB(red,green,blue) ((2UL<<24)|(((red)&255UL)<<16)|(((green)&255UL)<<8)|(((blue)&255UL)<<0))
function clear_color_rgb(r, g, b)
	local result = bit.lshift(2, 24)
	result = result + bit.lshift(bit.band(r, 0xff), 16)
	result = result + bit.lshift(bit.band(g, 0xff), 8)
	result = result + bit.band(b, 0xff)
	return result
end

--#define CLEAR(c,s,t) ((38UL<<24)|(((c)&1UL)<<2)|(((s)&1UL)<<1)|(((t)&1UL)<<0))
function clear(c, s, t)
	local result = bit.lshift(38, 24)
	result = result + bit.lshift(bit.band(c, 0x01), 2)
	result = result + bit.lshift(bit.band(s, 0x01), 1)
	result = result + bit.band(t, 0x01)
	
	return result
end


---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

for i, iPin in ipairs(lowPins) do
--	print (iPin.." - "..i)
	pio.pin.setdir(pio.OUTPUT, iPin)
	pio.pin.setlow(iPin)
end


--SPI--

spi.setup(sid, spi.MASTER, 4000, 0, 0, 8)

--WRITE CMD--
csclose()



pio.pin.setlow(pio.PA_2)
tmr.delay(0, 25000)
pio.pin.sethigh(pio.PA_2)
tmr.delay(0, 25000)

cmd(0x00) -- wake up
cmd(0x44) -- external clock
cmd(0x62) -- 48 MHz
cmd(0x68) --core reset

--print("read chiip id: ".. rd8(0x0C0000))
--print("read chiip id: ".. rd8(0x0C0001))
--print("read chiip id: ".. rd8(0x0C0002))
--print("read chiip id: ".. rd8(0x0C0003))

tmr.delay(0, 10000)


local dev_id=rd8(0x102400)
print("dev_id: "..dev_id)
numWaits=1000
while numWaits>0 do
	numWaits=numWaits-1
	print("waiting\n")
	regid=rd8(F.REG_ID)
	if regid ==0x7C then
		print( "READY!!")	
		break
	end
	tmr.delay(0, 10000)
end
print("REG_ID: "..rd8(F.REG_ID))
print("REG_PCLK: "..rd8(F.REG_PCLK))

wr16(F.REG_HCYCLE, 548)
wr16(F.REG_HOFFSET, 43)
wr16(F.REG_HSYNC0, 0)
wr16(F.REG_HSYNC1, 41)
wr16(F.REG_VCYCLE, 292)
wr16(F.REG_VOFFSET, 12)
wr16(F.REG_VSYNC0, 0)
wr16(F.REG_VSYNC1, 10)
wr8(F.REG_SWIZZLE, 0)
wr8(F.REG_PCLK_POL, 1)
wr8(F.REG_CSPREAD, 1)
wr16(F.REG_HSIZE, 480)
wr16(F.REG_VSIZE, 272)

--/* write first display list */
wr32(F.RAM_DL+0, clear_color_rgb(0,0,0));
wr32(F.RAM_DL+4, clear(1,1,1));
wr32(F.RAM_DL+8, 0); --DISPLAY()

wr8(F.REG_DLSWAP, F.DLSWAP_FRAME) --//display list swap
wr8(F.REG_GPIO_DIR, bit.bor(0x80, rd8(F.REG_GPIO_DIR)))
wr8(F.REG_GPIO, bit.bor(0x80, rd8(F.REG_GPIO))) --;//enable display bit
wr8(F.REG_PCLK, 5) --;//after this display is visible on the LCD

----------------------

print("zapisandddddo")
