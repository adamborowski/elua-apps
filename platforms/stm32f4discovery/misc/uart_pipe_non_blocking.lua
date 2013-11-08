-- trzeba słać na UART 4 linię \r\n a program odpowie echem

local uart1=4
local uart2=0xB0
function send(msg, uid)
  uart.write(uid, msg)
end
function sendLine(msg, uid)
	send(msg.."", uid)
end
function readLine(uid)
	return uart.read( uid, 1024, 0)
end

uart.setup(uart1, 115200, 8, uart.PAR_NONE, uart.STOP_1)
uart.set_buffer(uart1, 1024)
uart.set_buffer(uart2, 1024)
sendLine("siemka", uart1)

local input
while true do 
	--sendLine("hej", uart1)
	--sendLine("hej", uart2)
	input = readLine(uart1)
	if input~="" then
		sendLine(input, uart2)
	end
	input = readLine(uart2)
	if input~="" then
		sendLine(input, uart1)
	end
	tmr.delay( 0, 5000 )
end


print("koniec")