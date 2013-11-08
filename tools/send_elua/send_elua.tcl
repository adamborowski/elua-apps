#!/opt/adam/bin/tclsh8.6
set comPort /dev/ttyACM
set fileName $argv
if { $fileName eq ""} {
    set fileName "./romfs/pwmled.lua"
}
set num 0

while {1} {
    if {[catch {
            puts "próba wysyłania pliku: $fileName do portu $comPort$num"
            set fh [open "$comPort$num" RDWR]
            fconfigure $fh \
                -mode 115200,n,8,1 \
                -buffering none \
                -blocking 0 \
                -translation binary
            
            fileevent $fh readable {
                set income [read $fh]
                if {[regexp {CC} $income]} {
                    exec sx\
                    $fileName \
                    < $comPort$num > $comPort$num &
                } elseif {[regexp {eLua#} $income]} {
                    after 300 {exit 0}
                    #exit 0
                }
                
                puts "\x1b\[34m$income\x1b\[0m"
            }
            fileevent stdin readable {
                if {[gets stdin line] >= 0} {
                    #puts -nonewline "Read data: "
                    #sputs $line
                    puts $fh "$line\r\n"
                }
            }
            puts $fh "\x18"
            flush $fh
            puts $fh "recv\r\n"
            flush $fh
            
        } err]} {
        #puts "\x1b\[32m----------------Błąd: $err\x1b\[0m"
        catch {close "$comPort$num"}
        incr num
        if {$num == 15 } {
            break
        }
        continue
    }
    break
}
vwait forever