local p=pio.PB_10
pio.pin.setdir(pio.OUTPUT, p )
while 1 do
	
	tmr.delay( 0, 200000 )
	pio.pin.sethigh(p)
	print('set high\n')
	tmr.delay( 0, 200000 )
	pio.pin.setlow(p)
	print('set low\n')
end