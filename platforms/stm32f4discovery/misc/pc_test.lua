--#define CLEAR_COLOR_RGB(red,green,blue) ((2UL<<24)|(((red)&255UL)<<16)|(((green)&255UL)<<8)|(((blue)&255UL)<<0))
function clear_color_rgb(r, g, b)
	local result = bit.lshift(2, 24)
	result = result + bit.lshift(bit.band(r, 0xff), 16)
	result = result + bit.lshift(bit.band(g, 0xff), 8)
	result = result + bit.band(b, 0xff)
	
	return result
end
print(clear_color_rgb(0,0,0))