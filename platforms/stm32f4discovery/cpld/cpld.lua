sid = 1
clock = spi.setup(sid, spi.MASTER, 100000, 0, 0, 8)
print(clock)

pio.pin.setdir(pio.OUTPUT, pio.PB_11)

pio.pin.sethigh(pio.PB_11)
tmr.delay(0, 1000)

dict = {65, 66, 67, 68}

for i = 1, 30 do
  pio.pin.setlow(pio.PB_11)
  for j = 1, 4 do
    result = spi.write(sid, j)
    result = spi.write(sid, dict[j])

    dict[j] = dict[j] + 1
  end
  pio.pin.sethigh(pio.PB_11)

  tmr.delay(0, 500000)
end
