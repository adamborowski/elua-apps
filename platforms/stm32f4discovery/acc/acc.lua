-----------------
-- common func --
-----------------

function wr(raw_data)
	pio.pin.setlow(csPin)
	spi.write(SPI.sid, raw_data)
	pio.pin.sethigh(csPin)
end

function send(data)
	local ret=spi.readwrite(SPI.sid, data)
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
	spi.write(SPI.sid, data, 0x00, 0x00)
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
	spi.readwrite(SPI.sid, addr1, addr2, addr3, data1, data2)
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
	spi.readwrite(SPI.sid, addr1, addr2, addr3, data1, data2, data3, data4)
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
	spi.readwrite(SPI.sid, addr1, addr2, addr3, data)
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
	local ret=spi.readwrite(SPI.sid,addr1, addr2, addr3, 0x00, 0x00) -- dummy byte and one byte for answer
	print("readwrite byte[1]"..ret[1])
	print("readwrite byte[2]"..ret[2])
	print("readwrite byte[3]"..ret[3])
	print("readwrite byte[4]"..ret[4])
	print("readwrite byte[5]"..ret[5])
	csclose()
	return ret[5]
end

---------------
-- constants --
---------------
C = {}

-------------
-- program --
-------------

-- setting SPI communication
SPI = {
  sid = 0,
  mode = spi.MASTER,
  clock = 100000,
  cpol = 1, -- high polarity
  cpha = 0,
  word = 8
}

PIN = { -- pins for SPI #0
  clk = pio.PA_5,
  mosi = pio.PA_7,
  cs = pio.PE_3,
  miso = pio.PA_6
}

clock = spi.setup(SPI.sid, SPI.mode, SPI.clock, SPI.cpol, SPI.cpha, SPI.word)
io.write('clock: ')
io.write(clock)
io.write("\n")

pio.pin.setdir(pio.OUTPUT, PIN.cs)
pio.pin.sethigh(PIN.cs)

--pio.pin.setlow(PIN.cs)
-- write/read
--pio.pin.sethigh(PIN.cs)

--tmr.delay(0, 500000)

-------------------
-- http://www.lxtronic.com/index.php/basic-spi-simple-read-write
-------------------
---------------
----- init
---------------
--GPIO_InitTypeDefStruct.GPIO_Pin = GPIO_Pin_5 | GPIO_Pin_7 | GPIO_Pin_6;
--GPIO_InitTypeDefStruct.GPIO_Mode = GPIO_Mode_AF;
--GPIO_InitTypeDefStruct.GPIO_Speed = GPIO_Speed_50MHz;
--GPIO_InitTypeDefStruct.GPIO_OType = GPIO_OType_PP;
--GPIO_InitTypeDefStruct.GPIO_PuPd = GPIO_PuPd_NOPULL;
--GPIO_Init(GPIOA, &GPIO_InitTypeDefStruct);
--
--GPIO_InitTypeDefStruct.GPIO_Pin = GPIO_Pin_3;
--GPIO_InitTypeDefStruct.GPIO_Mode = GPIO_Mode_OUT;
--GPIO_InitTypeDefStruct.GPIO_Speed = GPIO_Speed_50MHz;
--GPIO_InitTypeDefStruct.GPIO_PuPd = GPIO_PuPd_UP;
--GPIO_InitTypeDefStruct.GPIO_OType = GPIO_OType_PP;
--GPIO_Init(GPIOE, &GPIO_InitTypeDefStruct);
--
--GPIO_PinAFConfig(GPIOA, GPIO_PinSource5, GPIO_AF_SPI1);
--GPIO_PinAFConfig(GPIOA, GPIO_PinSource6, GPIO_AF_SPI1);
--GPIO_PinAFConfig(GPIOA, GPIO_PinSource7, GPIO_AF_SPI1);
--
--GPIO_SetBits(GPIOE, GPIO_Pin_3);


--------------
--- sendData
--------------
--void mySPI_SendData(uint8_t adress, uint8_t data){
--
--GPIO_ResetBits(GPIOE, GPIO_Pin_3);
--
--while(!SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_TXE));
--SPI_I2S_SendData(SPI1, adress);
--while(!SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_RXNE));
--SPI_I2S_ReceiveData(SPI1);
--
--while(!SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_TXE));
--SPI_I2S_SendData(SPI1, data);
--while(!SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_RXNE));
--SPI_I2S_ReceiveData(SPI1);
--
--GPIO_SetBits(GPIOE, GPIO_Pin_3);
--}

--------------
----- getData
--------------
--uint8_t mySPI_GetData(uint8_t adress){
--
--GPIO_ResetBits(GPIOE, GPIO_Pin_3);
--
--adress = 0x80 | adress;
--
--while(!SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_TXE));
--SPI_I2S_SendData(SPI1, adress);
--while(!SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_RXNE));
--SPI_I2S_ReceiveData(SPI1); //Clear RXNE bit
--
--while(!SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_TXE));
--SPI_I2S_SendData(SPI1, 0x00); //Dummy byte to generate clock
--while(!SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_RXNE));
--
--GPIO_SetBits(GPIOE, GPIO_Pin_3);
--
--return  SPI_I2S_ReceiveData(SPI1);
--}
