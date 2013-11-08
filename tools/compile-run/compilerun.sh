#! /bin/bash
cd ~/elua
if [ -f elua_lua_stm32f4discovery.elf ] ; then
rm elua_lua_stm32f4discovery.elf
fi
if [ -f elua_lua_stm32f4discovery.bin ] ; then
rm elua_lua_stm32f4discovery.bin
fi
./build_elua.lua board=stm32f4discovery
arm-none-eabi-objcopy -O binary elua_lua_stm32f4discovery.elf elua_lua_stm32f4discovery.bin

 openocd    -f /usr/share/openocd/scripts/board/stm32f4discovery.cfg \
 -c "init"\
 -c "reset halt"\
 -c "sleep 100"\
 -c "wait_halt 2"\
 -c "echo \"--- Writing elua_lua_stm32f4discovery.bin\""\
 -c "flash write_image erase elua_lua_stm32f4discovery.bin 0x08000000"\
 -c "sleep 100"\
 -c "echo \"--- Verifying\""\
 -c "verify_image elua_lua_stm32f4discovery.bin 0x08000000"\
 -c "sleep 100"\
 -c "echo \"--- Done\""\
 -c "resume"\
 -c "shutdown"\
