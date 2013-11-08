-- trzeba słać na UART 4 linię \r\n a program odpowie echem

local uid=4
function send(msg)
  uart.write(uid, msg)
  uart.write(0xB0, msg)
end
function sendLine(msg)
	send(msg.."\r\n")
end
function readLine()
	return uart.read( uid, "*l", uart.INF_TIMEOUT)
end

uart.setup(uid, 115200, 8, uart.PAR_NONE, uart.STOP_1)
sendLine("siemka")

local input
while true do 
	input = readLine()
	if input=="!!!" then break end 
	send("dostalem: "..input)
end


print("koniec")