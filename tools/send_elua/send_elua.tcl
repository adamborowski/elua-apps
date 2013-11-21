#!/usr/bin/tclsh8.6
proc color {{color 34} content} {
return \x1b\[${color}m$content\x1b\[0m
}

set header {
                                                    
    eLua Script compiler and loader for STM32F4     
                                                    
}
set lines [split $header "\n"]
foreach line $lines {
  puts  "   [color {1;37;40} $line]"
}


puts "    visit: [color {1;5;36} http://github.com/adamborowski/elua-apps/]"

set fileName [file normalize [lindex $argv 0]]
set luacOpt [lindex $argv 1]

#regexp {(.*)\.[^.]+$} $fileName res result
#set outName $result.out
set outName /tmp/send_elua.out
if { $fileName eq ""} {
    puts "no modules file found"
    exit
}
set modulesFolder [file dirname $fileName]
set inputExtension [file extension $fileName]
if {$inputExtension == ".lua" } {
  lappend modules [file join $modulesFolder $fileName]
} else {
  set modulesHandle [open $fileName r]
  while {[scan [gets $modulesHandle] %s item] >0} {
    lappend modules [file join $modulesFolder $item]
  }
}
#



puts "\n Following modules will be included for compilation in order as occured on the following list:\n"
set listChars "  \xbb "
puts [color {1;32} "$listChars[join $modules \n$listChars]"]
puts "\n Output file:\n [color {1;38} $outName]"



#


set port [file join /dev [lindex [split [exec ls /dev | grep ttyACM] \n] 0]]

puts " Destination port:\n [color {1;38} $port]"

set fh [open $port RDWR]
fconfigure $fh \
    -mode 115200,n,8,1 \
    -buffering none \
    -blocking 0 \
    -translation binary
puts $fh "\x1A"
flush $fh
fileevent $fh readable {
    set income [read $fh]
    if {[regexp {CC} $income]} {
	file delete -force $outName
	set cmd "~/elua/luac.cross $luacOpt -cci 32 -ccn float 64 -cce little $luacOpt -o $outName $modules"
	set cmd [regexp -inline -all -- {\S+} $cmd]
	exec {*}[split $cmd " "]
	# file compression info
	set totalSize 0
	foreach file $modules {
	  set totalSize [expr "$totalSize + [file size $file]"]
	}
	set outputSize [file size $outName]
	set ratio [format "%.2f" [expr "double($outputSize) / double($totalSize) * 100"]]
	puts " Source total size : [color {1;34} [list $totalSize B]]"
	puts " Output file  size : [color {1;35} [list $outputSize B]]"
	puts " Output ratio      : [color {1;36} [list $ratio %]]"
	#
	puts "\n\t[color {1;31} SENDING]"
	exec sx\
	$outName \
	< $port > $port &
	
    } elseif {[regexp {^\W*eLua#\W*$} $income]} {
	puts $fh " "
	#after 300 {exit 0}
	exit 0
    }
    #puts [regexp {\s*} $income]
    if {[string trim $income]!=""} {
      puts "\x1b\[34m$income\x1b\[0m"
    }
    
}
fileevent stdin readable {
    if {[gets stdin line] >= 0} {
	#puts -nonewline "Read data: "
	#sputs $line
	puts $fh "$line\r\n"
    }
}

puts $fh "recv\r\n"
flush $fh
            
       
vwait forever