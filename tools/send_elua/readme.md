###cross-compile many elua sources into one bytecode file and send it through xmodem to elua shell on your STM32F4

## requirements
1. run as superuser
1. ensure elua tools are located under ~/elua
1. goto elua folder
1. execute "lua cross-lua.lua" to generate toolchain for enable cross compilation lua bytecode on your pc
1. if you want to send elua bytecode you must provide a file containig list of relative paths of files you want to merge in order of occurence

### ex