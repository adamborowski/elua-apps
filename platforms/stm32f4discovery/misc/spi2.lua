clock = spi.setup(1, spi.MASTER, 9000000, 0, 0, 8)
print(clock)

--pio.pin.setdir(pio.OUTPUT, pio.PA_5)
--pio.pin.setdir(pio.OUTPUT, pio.PA_7)
pio.pin.setdir(pio.OUTPUT, pio.PB_11)

--pio.pin.setlow(pio.PE_3)

data = 0xf1

for i=1,1000 do
  pio.pin.setlow(pio.PB_11)
  result = spi.write(1, 'ala ma kota')
  pio.pin.sethigh(pio.PB_11)
end

print("zakonczono")