###cross-compile multiple elua sources into one bytecode file and send it through xmodem to elua shell on your STM32F4

## requirements
1. tclsh8.6 (ealier versions not tested) installed
1. elua tools installed and configured
1. run as superuser
1. ensure elua tools are located under ~/elua
1. goto elua folder
1. execute "lua cross-lua.lua" to generate toolchain for enable cross compilation lua bytecode on your pc
1. if you want to send elua bytecode you must provide a file containig list of relative paths of files you want to merge in order of occurence
1. elua shell accessible as first device from /deb/ttyACM*

### example usage
$ elua-apps/tools/send_elua/send_elua.tcl elua-apps/platforms/stm32f4discovery/ft800-helloworld/display.modules

or if you want to exclude debugging information (less size but no file and line information when error occures)

$ elua-apps/tools/send_elua/send_elua.tcl elua-apps/platforms/stm32f4discovery/ft800-helloworld/display.modules **-s**

### lines of file display.modules 
* constants.lua
* utils.lua
* spi.lua
* ft800.lua
* ft800-drawing.lua
* display.lua
