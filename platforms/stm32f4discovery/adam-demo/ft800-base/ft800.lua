print("display.lua example")


ft800_setup(SMALL_LCD) -- all things to get LCD display ready for drawing


while handle_interrupt() do
    commit()
    c = c + speed
end


print("end of display.lua execution")
