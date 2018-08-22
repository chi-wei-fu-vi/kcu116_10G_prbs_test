proc Cmd_Server {port} {
   set s [socket -server CmdAccept $port]
   vwait ::forever_flag
   close $s
}
proc CmdAccept {sock addr port} {
   global cmd
   # Record the client's information
   puts "Accept $sock from $addr port $port"
   set cmd(addr,$sock) [list $addr $port]
   fconfigure $sock -buffering line
   # Set up a callback for when the client sends data
   fileevent $sock readable [list Cmd $sock]
}
proc Cmd {sock} {
  global cmd
  global common_offset
  global channel_offset
  global vio_regs_offset
  global offset
  # Check end of file or abnormal connection drop.
  # then cmd data back to the client
  
  if {[eof $sock] || [catch {gets $sock line}]} {
    # end of file or abnormal connection drop
    close $sock
    puts "Close $cmd(addr,$sock)"
    unset cmd(addr,$sock)
  } elseif {[string compare $line "quit"] ==0} {
    # Prevent new connections. 
    # Existing connections stay open. 
    close $sock
    puts "Close $cmd(addr,$sock)"
    unset cmd(addr,$sock)
    set ::forever_flag 1
  } elseif {[string compare $line "source prbs_test.tcl"] ==0} {
    source prbs_test.tcl
    puts $sock "Finish command of $line"
  } elseif {[string compare $line "source ber_dfe_scan.tcl"] ==0} {
    source ber_dfe_scan.tcl
    puts $sock "Finish command of $line"
  } elseif {[string compare $line "source matrix_scan.tcl"] ==0} {
    source matrix_scan.tcl
    puts $sock "Finish command of $line"
  } elseif {[string compare $line "source prescale_scan.tcl"] ==0} {
    source prescale_scan.tcl
    puts $sock "Finish command of $line"
  } elseif {[string compare $line "prbs_test_ini"] ==0} {
    prbs_test_ini
    puts $sock "Finish command of $line"
  } elseif {[string compare $line "reset_all 0"] ==0} {
    reset_all 0
    puts $sock "Finish command of $line"
  } elseif {[string compare $line "reset_all 1"] ==0} {
    reset_all 1
    puts $sock "Finish command of $line"
  } elseif {[string match "set *" $line] ==1} {
    set alist [split $line { }]
    set varname [lindex $alist 1]
    set value [lrange $alist 2 end]
    puts "varname : $varname"
    puts "value : $value"
    set $varname $value
    puts "$varname : [set $varname]"
    puts $sock "Finish command of $line"
  } else {
    puts "Executing $line"
    set err_flag [catch {eval $line}]
    if { $err_flag } {
      puts $sock "ERROR: No command of $line"
    } else {
      puts $sock "Finish command of $line"
    }
  }
}
#  cmd client
proc Cmd_Client { host port } {
  set s [socket $host $port]
  fconfigure $s -buffering line
  return $s
}
# A sample client session looks like this
#  set s [Cmd_Client localhost 50007]
#  puts $s "Hello!"
#  puts $s "quit"
#  gets $s line
#  puts $line
#  close $s
#set channel_offset [expr 0x44a11000]
#set vio_regs_offset [expr 0x44a12000]
#set common_offset [expr 0x44a10000]
Cmd_Server 50007
exit
