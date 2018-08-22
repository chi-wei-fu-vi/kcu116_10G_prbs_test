
proc set_circle_dict { xamax yamax { dbg 0 } } {
  set full_circle [expr 4 * ($xamax + $yamax)]
  if $dbg { puts "$full_circle $xamax $yamax" }
  for {set vec 0} {$vec <= $full_circle} {incr vec} {
     if $dbg { puts -nonewline "vec: $vec; " }
     # set x and y factors
     # vec   x       y
     #   0   1       0
     #   1  -1       0
     #   2   0       1
     #   3  -0      -1
     #   4   1       1
     #   5  -1       1
     #   6   1      -1
     #   7  -1      -1
     #   8   1/2     1
     #   9  -1/2     1
     #  10   1/2    -1
     #  11  -1/2    -1
     #  12   1       1/2
     #  13  -1       1/2
     #  14   1      -1/2
     #  15  -1      -1/2
     #  16   1/4     1
     #  17  -1/4     1
     #  18   1/4    -1
     #  19  -1/4    -1
     #  20   3/4     1
     #  21  -3/4     1
     #  22   3/4    -1
     #  23  -3/4    -1
     #  24   1       1/4
     #  25  -1       1/4
     #  26   1      -1/4
     #  27  -1      -1/4
     #  28   1      -3/4
     #  29  -1      -3/4
     #  30   1       3/4
     #  31  -1       3/4
     #  32   1/8     1
     #  33  -1/8     1
     #  34   1/8    -1
     #  35  -1/8    -1
     #  36   3/8     1
     #  37  -3/8     1
     #  38   3/8    -1
     #  39  -3/8    -1
     #  40   5/8     1
     #  41  -5/8     1
     #  42   5/8    -1
     #  43  -5/8    -1
     #  44   7/8     1
     #  45  -7/8     1
     #  46   7/8    -1
     #  47  -7/8    -1
     #  48   1       1/8
     #  49  -1       1/8
     #  50   1      -1/8
     #  51  -1      -1/8
     #  52   1      -3/8
     #  53  -1      -3/8
     #  54   1       3/8
     #  55  -1       3/8
     #  56   1       5/8
     #  57  -1       5/8
     #  58   1      -5/8
     #  59  -1      -5/8
     #  60   1      -7/8
     #  61  -1      -7/8
     #  62   1       7/8
     #  63  -1       7/8
     # ...
     switch $vec {
       0 {set xfac  1 ; set yfac  0}
       1 {set xfac -1 ; set yfac  0}
       2 {set xfac  0 ; set yfac  1}
       3 {set xfac  0 ; set yfac -1}
       4 {set xfac  1 ; set yfac  1}
       5 {set xfac -1 ; set yfac  1}
       6 {set xfac  1 ; set yfac -1}
       7 {set xfac -1 ; set yfac -1}
       default {
         set xfsign [expr ($vec & 1) ? -1.0 : 1.0]
         set yfsign [expr ($vec & 2) ? -1.0 : 1.0]
         if       {$vec < 16} {
           set xfval [expr ($vec & 4) ? 1/2.0 :   1.0]
           set yfval [expr ($vec & 4) ?   1.0 : 1/2.0]
         } elseif {$vec < 32} {
           set xfval [expr ($vec & 8) ? (((($vec & 0x4)>>2)<<1)+1)/4.0 :                            1.0]
           set yfval [expr ($vec & 8) ?                            1.0 : (((($vec & 0x4)>>2)<<1)+1)/4.0]
         } elseif {$vec < 64} {
           set xfval [expr ($vec & 16) ? (((($vec & 0xc)>>2)<<1)+1)/8.0 :                            1.0]
           set yfval [expr ($vec & 16) ?                            1.0 : (((($vec & 0xc)>>2)<<1)+1)/8.0]
         } elseif {$vec < 128} {
           set xfval [expr ($vec & 32) ? (((($vec & 0x1c)>>2)<<1)+1)/16.0 :                              1.0]
           set yfval [expr ($vec & 32) ?                              1.0 : (((($vec & 0x1c)>>2)<<1)+1)/16.0]
         } elseif {$vec < 256} {
           set xfval [expr ($vec & 64) ? (((($vec & 0x3c)>>2)<<1)+1)/32.0 :                              1.0]
           set yfval [expr ($vec & 64) ?                              1.0 : (((($vec & 0x3c)>>2)<<1)+1)/32.0]
         } elseif {$vec < 512} {
           set xfval [expr ($vec & 128) ? (((($vec & 0x7c)>>2)<<1)+1)/64.0 :                              1.0]
           set yfval [expr ($vec & 128) ?                              1.0 : (((($vec & 0x7c)>>2)<<1)+1)/64.0]
         } elseif {$vec < 1024} {
           set xfval [expr ($vec & 256) ? (((($vec & 0xfc)>>2)<<1)+1)/128.0 :                               1.0]
           set yfval [expr ($vec & 256) ?                               1.0 : (((($vec & 0xfc)>>2)<<1)+1)/128.0]
         } elseif {$vec < 2048} {
           set xfval [expr ($vec & 512) ? (((($vec & 0x1fc)>>2)<<1)+1)/256.0 :                                1.0]
           set yfval [expr ($vec & 512) ?                                1.0 : (((($vec & 0x1fc)>>2)<<1)+1)/256.0]
         } elseif {$vec < 4096} {
           set xfval [expr ($vec & 1024) ? (((($vec & 0x3fc)>>2)<<1)+1)/512.0 :                                1.0]
           set yfval [expr ($vec & 1024) ?                                1.0 : (((($vec & 0x3fc)>>2)<<1)+1)/512.0]
         } else {
           set xfval [expr ($vec & 2048) ? (((($vec & 0x7fc)>>2)<<1)+1)/1024.0 :                                 1.0]
           set yfval [expr ($vec & 2048) ?                                 1.0 : (((($vec & 0x7fc)>>2)<<1)+1)/1024.0]
         }
         set xfac [expr $xfsign*$xfval]
         set yfac [expr $yfsign*$yfval]
         if $dbg { puts -nonewline "$xfsign	$xfval	$yfsign	$yfval	" }
       }
    }
    # set vector coordinates
    dict set ::c_d $vec x [expr int($xfac * $xamax)]
    dict set ::c_d $vec y [expr int($yfac * $yamax)]
    if $dbg { puts "factors	:	$xfac	$yfac		vector:	[dict get $::c_d $vec x]	[dict get $::c_d $vec y]" }
  }
}

proc set_rxout_div {} {
  global offset
  set rxoutd [RXOUT_DIV]
  switch [format 0x%X $rxoutd] {
     0x0 {dict set ::_chinfo_d $offset rxout_div 1}
     0x1 {dict set ::_chinfo_d $offset rxout_div 2}
     0x2 {dict set ::_chinfo_d $offset rxout_div 4}
     0x3 {dict set ::_chinfo_d $offset rxout_div 8}
     0x4 {dict set ::_chinfo_d $offset rxout_div 16}
     0x5 {dict set ::_chinfo_d $offset rxout_div 32}
     default {puts "ERROR: invalid setting for RXOUT_DIV $rxoutd";exit 1}
  }
}

proc _dict2json { d } {
 set lines [list]
  dict for { k v } $d {
    if { [llength $v] > 1 } {
      lappend lines "'$k' : '[dict2json $v]'"

    } else {
      lappend lines  "'$k'  : '$v'"
    }
  }
  return  $lines
}
proc dict2json { d } {
  set res [_dict2json $d]
  return [string map { "\} \{" ,    "'\{" \{     "\}'" \}  "'" \"} $res]
}

proc ploteye {channel_offset sel val { scaled 1} } {
  switch $sel {
    ps  {set pref ""}
    ber {set pref ber}
  }
  if $scaled {
    set hl [llength [dict keys [dict get $::ber_plot_d $channel_offset $pref$val 0]]]
    puts -nonewline "+"; foreach x [.. $hl] {puts -nonewline "-"}; puts "+"
    dict for {y x_d} [dict get $::ber_plot_d $channel_offset $pref$val] {
      puts -nonewline "|"; dict for {x xp_d} [dict get $x_d] { puts -nonewline $xp_d }; puts "|"
    }
    puts -nonewline "+"; foreach x [.. $hl] {puts -nonewline "-"}; puts "+"
  } else {
    set hl [llength [dict keys [dict get $::ber_d $channel_offset $pref$val 0]]]
    puts -nonewline "+"; foreach x [.. $hl] {puts -nonewline "-"}; puts "+"
    dict for {y x_d} [dict get $::ber_d $channel_offset $pref$val] {
      puts -nonewline "|"
      dict for {x xp_d} [dict get $x_d] { puts -nonewline [ber2ch $xp_d] }
      puts "|"
    }
    puts -nonewline "+"; foreach x [.. $hl] {puts -nonewline "-"}; puts "+"
  }
}

proc ber2ch { ber } {
  if { $ber == "-1"  } {
    set c " "
  } elseif { $ber == "0.0" } {
    set c "."
  } elseif { $ber == "1.0" } {
    set c "X"
  } elseif { [regexp {0\.[1-9]\d*} $ber] || [regexp {.*e-1$} $ber] } {
    set c "0"
  } elseif { [regexp {0\.0[1-9]\d*} $ber] || [regexp {.*e-2$} $ber] } {
    set c "1"
  } elseif { [regexp {0\.00[1-9]\d*} $ber] || [regexp {.*e-3$} $ber] } {
    set c "2"
  } elseif { [regexp {0\.000[1-9]\d*} $ber] || [regexp {.*e-4$} $ber] } {
    set c "3"
  } elseif { [regexp {0\.{4}0[1-9]\d*} $ber] || [regexp {.*e-5$} $ber] } {
    set c "4"
  } elseif { [regexp {0\.{5}0[1-9]\d*} $ber] || [regexp {.*e-6$} $ber] } {
    set c "5"
  } elseif { [regexp {0\.{6}0[1-9]\d*} $ber] || [regexp {.*e-7$} $ber] } {
    set c "6"
  } elseif { [regexp {0\.{7}0[1-9]\d*} $ber] || [regexp {.*e-8$} $ber] } {
    set c "7"
  } elseif { [regexp {0\.{8}0[1-9]\d*} $ber] || [regexp {.*e-9$} $ber] } {
    set c "8"
  } elseif { [regexp {0\.{9}0[1-9]\d*} $ber] || [regexp {.*e-10$} $ber] } {
    set c "9"
  } elseif { [regexp {0\.{10}0[1-9]\d*} $ber] || [regexp {.*e-11$} $ber] } {
    set c "a"
  } elseif { [regexp {0\.{11}0[1-9]\d*} $ber] || [regexp {.*e-12$} $ber] } {
    set c "b"
  } elseif { [regexp {0\.{12}0[1-9]\d*} $ber] || [regexp {.*e-13$} $ber] } {
    set c "c"
  } elseif { [regexp {0\.{13}0[1-9]\d*} $ber] || [regexp {.*e-14$} $ber] } {
    set c "d"
  } elseif { [regexp {0\.{14}0[1-9]\d*} $ber] || [regexp {.*e-15$} $ber] } {
    set c "e"
  } elseif { [regexp {0\.{15}0[1-9]\d*} $ber] || [regexp {.*e-16$} $ber] } {
    set c "f"
  } elseif { [regexp {0\.{16}0[1-9]\d*} $ber] || [regexp {.*e-17$} $ber] } {
    set c "g"
  } elseif { [regexp {0\.{17}0[1-9]\d*} $ber] || [regexp {.*e-18$} $ber] } {
    set c "h"
  } elseif { [regexp {0\.{18}0[1-9]\d*} $ber] || [regexp {.*e-19$} $ber] } {
    set c "i"
  } elseif { [regexp {0\.{19}0[1-9]\d*} $ber] || [regexp {.*e-20$} $ber] } {
    set c "j"
  } elseif { [regexp {0\.{20}0[1-9]\d*} $ber] || [regexp {.*e-21$} $ber] } {
    set c "k"
  } elseif { [regexp {0\.{21}0[1-9]\d*} $ber] || [regexp {.*e-22$} $ber] } {
    set c "l"
  } elseif { [regexp {0\.{22}0[1-9]\d*} $ber] || [regexp {.*e-23$} $ber] } {
    set c "m"
  } elseif { [regexp {0\.{23}0[1-9]\d*} $ber] || [regexp {.*e-24$} $ber] } {
    set c "n"
  } elseif { [regexp {0\.{24}0[1-9]\d*} $ber] || [regexp {.*e-25$} $ber] } {
    set c "o"
  } elseif { [regexp {0\.{25}0[1-9]\d*} $ber] || [regexp {.*e-26$} $ber] } {
    set c "p"
  } elseif { [regexp {0\.{26}0[1-9]\d*} $ber] || [regexp {.*e-27$} $ber] } {
    set c "q"
  } elseif { [regexp {0\.{27}0[1-9]\d*} $ber] || [regexp {.*e-28$} $ber] } {
    set c "r"
  } elseif { [regexp {0\.{28}0[1-9]\d*} $ber] || [regexp {.*e-29$} $ber] } {
    set c "s"
  } elseif { [regexp {0\.{29}0[1-9]\d*} $ber] || [regexp {.*e-30$} $ber] } {
    set c "t"
  } elseif { [regexp {0\.{30}0[1-9]\d*} $ber] || [regexp {.*e-31$} $ber] } {
    set c "u"
  } elseif { [regexp {0\.{31}0[1-9]\d*} $ber] || [regexp {.*e-32$} $ber] } {
    set c "v"
  } else {
    set c "z"
  }
  #puts " ber2ch: ber=$ber -> $c;"
  return $c
}

proc set_intdw {} {
  global offset
  set rxintdw [RX_INT_DATAWIDTH]
  set rxdw    [RX_DATA_WIDTH]
  switch [format 0x%X_0x%X ${rxdw} ${rxintdw}] {
     0x2_0x0 -
     0x4_0x0 {dict set ::_chinfo_d $offset intdw 16}
     0x3_0x0 -
     0x5_0x0 {dict set ::_chinfo_d $offset intdw 20}
     0x4_0x1 -
     0x6_0x1 {dict set ::_chinfo_d $offset intdw 32}
     0x5_0x1 -
     0x7_0x1 {dict set ::_chinfo_d $offset intdw 40}
     0x6_0x2 -
     0x8_0x2 {dict set ::_chinfo_d $offset intdw 64}
     0x7_0x2 -
     0x9_0x2 {dict set ::_chinfo_d $offset intdw 80}
     default {puts "ERROR: invalid setting for RX data width (RX_DATA_WIDTH=$rxdw RX_INT_DATAWIDTH=$rxintdw)";exit 1}
  }
}

proc set_loopback { type } {
  global offset
  global vio_regs_offset
  global channel_offset
  set offset $vio_regs_offset
  switch $type {
     normal { loopback 0x0 }
     nepcs  { loopback 0x1 }
     nepma  { loopback 0x2 }
     fepcs  { loopback 0x6 }
     fepma  { loopback 0x4 }
  }
  set offset $channel_offset
}

proc set_rxlpmen { dfe } {
  global offset
  global vio_regs_offset
  global channel_offset
  set offset $vio_regs_offset
  rxlpmen [expr $dfe ? 0 : 1]
  set offset $channel_offset
}

proc set_es_sdata_mask {} {
  global offset
  ES_SDATA_MASK9 0xffff
  ES_SDATA_MASK8 0xffff
  ES_SDATA_MASK7 0xffff
  ES_SDATA_MASK6 0xffff
  ES_SDATA_MASK5 0xffff
  ES_SDATA_MASK4 0x0000
  switch [get_chinfo $offset intdw] {
     16 { ES_SDATA_MASK3 0xffff; ES_SDATA_MASK2 0xffff; ES_SDATA_MASK1 0xffff; ES_SDATA_MASK0 0xffff }
     20 { ES_SDATA_MASK3 0x0fff; ES_SDATA_MASK2 0xffff; ES_SDATA_MASK1 0xffff; ES_SDATA_MASK0 0xffff }
     32 { ES_SDATA_MASK3 0x0000; ES_SDATA_MASK2 0xffff; ES_SDATA_MASK1 0xffff; ES_SDATA_MASK0 0xffff }
     40 { ES_SDATA_MASK3 0x0000; ES_SDATA_MASK2 0x00ff; ES_SDATA_MASK1 0xffff; ES_SDATA_MASK0 0xffff }
     64 { ES_SDATA_MASK3 0x0000; ES_SDATA_MASK2 0x0000; ES_SDATA_MASK1 0x0000; ES_SDATA_MASK0 0xffff }
     80 { ES_SDATA_MASK3 0x0000; ES_SDATA_MASK2 0x0000; ES_SDATA_MASK1 0x0000; ES_SDATA_MASK0 0x0000 }
  }
}

proc set_es_qualifier {} {
  ES_QUAL_MASK9 0xffff
  ES_QUAL_MASK8 0xffff
  ES_QUAL_MASK7 0xffff
  ES_QUAL_MASK6 0xffff
  ES_QUAL_MASK5 0xffff
  ES_QUAL_MASK4 0xffff
  ES_QUAL_MASK3 0xffff
  ES_QUAL_MASK2 0xffff
  ES_QUAL_MASK1 0xffff
  ES_QUAL_MASK0 0xffff
}

proc set_es_init {} {
  set_testcfg
  set_rxout_div
  set_intdw
  set_loopback [get_chinfo loopback]
  set_rxlpmen [get_chinfo dfe]
  # trigger[5:2]=1
  ES_CONTROL 0x4
  ES_EYE_SCAN_EN 0x1
  ES_ERRDET_EN 0x1
  ES_PRESCALE 0x10
  set_es_sdata_mask
  set_es_qualifier
}

proc set_init_window { xamax yamax } {
  global offset
  if [info exists ::ber_d] { unset ::ber_d }
  # -1 for armed 0-31 for 10^-0 - 10^-31
  for {set ps -1} { $ps < 32 } { incr ps } {
    for {set x [expr 0 - $xamax] } { $x <= $xamax } { incr x } {
      for { set y $yamax } { $y >= -1*$yamax } { incr y -1 } {
        dict set ::ber_d $offset $ps $y $x -1
        dict set ::ber_d $offset ber$ps $y $x -1
      }
    }
  }
}

proc set_init_scaled_window { xmaxplot ymaxplot } {
  global offset
  if [info exists ::ber_plot_d] { unset ::ber_plot_d }
  for {set ps -1} { $ps < 32 } { incr ps } {
    for {set x [expr 0 - $xmaxplot] } { $x <= $xmaxplot } { incr x } {
      for { set y $ymaxplot } { $y >= -1*$ymaxplot } { incr y -1 } {
        dict set ::ber_plot_d $offset $ps $y $x " "
        dict set ::ber_plot_d $offset ber$ps $y $x " "
      }
    }
  }
}

proc set_testcfg {} {
  dict set ::_chinfo_d init_window 1
  dict set ::_chinfo_d max_circle_div -1
  dict set ::_chinfo_d gtylrunder10 1
  dict set ::_chinfo_d ber -1
  dict set ::_chinfo_d prescale_max 4
  dict set ::_chinfo_d matrix_xaxis_offset 0
  dict set ::_chinfo_d prescale_min 4
  dict set ::_chinfo_d matrix_yaxis_div -1
  dict set ::_chinfo_d matrix_yaxis_offset 0
  dict set ::_chinfo_d loopback normal
  dict set ::_chinfo_d vrange 0
  dict set ::_chinfo_d use_matrix 1
  dict set ::_chinfo_d dfe 1
  dict set ::_chinfo_d type GTYE4_CHANNEL
  dict set ::_chinfo_d matrix_xaxis_div -1
}

proc data_slice {data width from to} {
   set m [expr (1<<($to-$from+1))-1]
   set sdata [expr ($data>>$from) & $m]
   return [list $sdata $width]
}

proc get_chinfo {args} {
  if [llength $args] {
    return [dict get $::_chinfo_d {*}$args]
  } else {
    return $::_chinfo_d
  }
}

proc .. {a {b ""} {step 1}} {
  if {$b eq ""} {set b $a; set a 0} ;# argument shift
  if {![string is int $a] || ![string is int $b]} {
    scan $a %c a; scan $b %c b
    incr b $step ;# let character ranges include the last
    set mode %c
  } else {set mode %d}
  set ss [sgn $step]
  if {[sgn [expr {$b - $a}]] == $ss} {
    set res [format $mode $a]
    while {[sgn [expr {$b-$step-$a}]] == $ss} {
      lappend res [format $mode [incr a $step]]
    }
    set res
  } ;# one-armed if: else return empty list
}
proc sgn x {expr {($x>0) - ($x<0)}}

proc es_point {x y prescale intdw vrange dfe dbg} {
  global offset
  # prescale should be float
  if $dbg { puts -nonewline "	point $x $y - processing " }
  # reset run or arm -> WAIT
  ES_CONTROL 0
  # set horizontal offset
  switch [get_chinfo type] {
    GTHE4_CHANNEL -
    GTYE4_CHANNEL {
      # set horizontal offset (lower 11 bit) similar to GTYE3
      if {[get_chinfo gtylrunder10] == 1} {
        ES_HORZ_OFFSET [expr $x & ((1<<11)-1)]
      } else {
        ES_HORZ_OFFSET [expr (1<<11) | ($x & ((1<<11)-1))]
      }
    }
    default {
      ES_HORZ_OFFSET [expr $x & ((1<<11)-1)]
    }
  }
  # set vertical offset
  switch [get_chinfo type] {
    GTHE4_CHANNEL -
    GTYE4_CHANNEL {
      # (sign,ut(0 used for lpm and 1. step of dfe),code,range)
      RX_EYESCAN_VS_NEG_DIR [expr ($y >= 0) ? 0 : 1]
      RX_EYESCAN_VS_UT_SIGN 0
      RX_EYESCAN_VS_CODE    [expr abs($y)]
      RX_EYESCAN_VS_RANGE   $vrange
    }
  }

  if {$prescale == -1} {
    # fast eye scan
    # go into ARM and run for some time until status read happens, any error counts as fail
    ES_CONTROL 0x6
    set ber [expr [expr [es_control_status] & 1] + 0.0]
  } else {
    # find BER according to p (prescale)
    # go into RUN
    ES_CONTROL 0x1
    # wait for DONE
    set cstat [es_control_status]
    while {[expr $cstat & 1 ] == 0} {
      if $dbg { puts -nonewline " . status=$cstat control=[ES_CONTROL]" }
      after 100
      set cstat [es_control_status]
    }
    set error_cnt  [es_error_count]
    set sample_cnt [expr [es_sample_count] * pow(2,(1 + $prescale)) * $intdw]
    set ber [expr $error_cnt / ($sample_cnt + 0.0)]
  }

  if {$dfe && [get_chinfo type] != "GTPE2_CHANNEL"} {
    # add negative UT
    ES_CONTROL 0x0
    RX_EYESCAN_VS_UT_SIGN 1
    if {$prescale == -1} {
      # fast eye scan
      ES_CONTROL 0x6
      set ber [expr $ber + [expr [es_control_status] & 1] + 0.0]
    } else {
      # find BER according to p (prescale)
      ES_CONTROL 0x1
      set cstat [es_control_status]
      while {[expr $cstat & 1] == 0} {
        if $dbg { puts -nonewline " . status=$cstat control=[ES_CONTROL]" }
        after 100
        set cstat [es_control_status]
      }
      set error_cnt  [es_error_count]
      set sample_cnt [expr [es_sample_count] * pow(2,(1 + $prescale)) * $intdw]
      set ber [expr $ber + $error_cnt / ($sample_cnt + 0.0)]
    }
  }

  if $dbg { puts "done ($ber)" }
  return $ber

}
    
proc es_vec {endx endy prescale intdw vrange xscale yscale dfe dbg} {
  global offset
  set xsign [expr ( $endx >= 0) ? (1.0) : (-1.0)]
  set ysign [expr ( $endy >= 0) ? (1.0) : (-1.0)]

  puts -nonewline "x${endx}y${endy}:"
  set x_prev 0
  set y_prev 0
  set x_prev_int 0
  set y_prev_int 0
  set x_curr [expr $endx/2.0]
  set y_curr [expr $endy/2.0]
  set x_curr_int [expr int($x_curr)]
  set y_curr_int [expr int($y_curr)]
  set x_offs [expr abs(($x_curr - $x_prev)/2.0)]
  set y_offs [expr abs(($y_curr - $y_prev)/2.0)]
  dict set lber_d ber 0.0
  dict set lber_d vl [expr abs($endx) + abs($endy)]
  dict set lber_d vx $endx
  dict set lber_d vy $endy
  set last_ber 0.0
  set last_ber_before 0.0
  set vec_done 0
  # set first points if necessary
  if {[dict get $::ber_d $offset $prescale $y_prev_int $x_prev_int] == -1} {
    dict set ::ber_d $offset $prescale $y_prev_int $x_prev_int [es_point $x_prev_int $y_prev_int $prescale $intdw $vrange $dfe $dbg]
    puts -nonewline .
    if $dbg { puts "$x_prev_int $y_prev_int [dict get $::ber_d $offset $prescale $y_prev_int $x_prev_int]" }
    incr vec_done
  }
  if { ([dict get $::ber_d $offset $prescale $y_prev_int $x_prev_int] != 0.0) && ((abs($x_prev_int) + abs($y_prev_int)) < [dict get $lber_d vl])} {
    dict set lber_d ber [dict get $::ber_d $offset $prescale $y_prev_int $x_prev_int]
    dict set lber_d vl [expr abs($x_prev_int) + abs($y_prev_int)]
    dict set lber_d vx $x_prev_int
    dict set lber_d vy $y_prev_int
  }
  if {[dict get $::ber_d $offset $prescale $y_curr_int $x_curr_int] == -1} {
    dict set ::ber_d $offset $prescale $y_curr_int $x_curr_int [es_point $x_curr_int $y_curr_int $prescale $intdw $vrange $dfe $dbg]
    puts -nonewline .
    if $dbg { puts "$x_curr_int $y_curr_int [dict get $::ber_d $offset $prescale $y_curr_int $x_curr_int]" }
    incr vec_done
  }
  if { ([dict get $::ber_d $offset $prescale $y_curr_int $x_curr_int] != 0.0) && ((abs($x_curr_int) + abs($y_curr_int)) < [dict get $lber_d vl])} {
    dict set lber_d ber [dict get $::ber_d $offset $prescale $y_curr_int $x_curr_int]
    dict set lber_d vl [expr abs($x_curr_int) + abs($y_curr_int)]
    dict set lber_d vx $x_curr_int
    dict set lber_d vy $y_curr_int
  }
  set x_next [expr ([dict get $::ber_d $offset $prescale $y_curr_int $x_curr_int] == 0.0) ? ($x_curr + $xsign * $x_offs) : ($x_curr - $xsign * $x_offs)]
  set y_next [expr ([dict get $::ber_d $offset $prescale $y_curr_int $x_curr_int] == 0.0) ? ($y_curr + $ysign * $y_offs) : ($y_curr - $ysign * $y_offs)]
  set x_next_int [expr int($x_next)]
  set y_next_int [expr int($y_next)]
  while {(($x_next_int != $x_prev_int) || ($y_next_int != $y_prev_int)) && (($x_next_int != $x_curr_int) || ($y_next_int != $y_curr_int))} {
    set x_prev $x_curr
    set y_prev $y_curr
    set x_prev_int $x_curr_int
    set y_prev_int $y_curr_int
    set x_curr $x_next
    set y_curr $y_next
    set x_curr_int $x_next_int
    set y_curr_int $y_next_int
    set x_offs [expr abs(($x_curr - $x_prev)/2.0)]
    set y_offs [expr abs(($y_curr - $y_prev)/2.0)]
    if {[dict get $::ber_d $offset $prescale $y_curr_int $x_curr_int] == -1} {
      dict set ::ber_d $offset $prescale $y_curr_int $x_curr_int [es_point $x_curr_int $y_curr_int $prescale $intdw $vrange $dfe $dbg]
      puts -nonewline .
      if $dbg { puts "$x_curr_int $y_curr_int [dict get $::ber_d $offset $prescale $y_curr_int $x_curr_int]" }
      incr vec_done
    }
    if { ([dict get $::ber_d $offset $prescale $y_curr_int $x_curr_int] != 0.0) && ((abs($x_curr_int) + abs($y_curr_int)) < [dict get $lber_d vl])} {
      dict set lber_d ber [dict get $::ber_d $offset $prescale $y_curr_int $x_curr_int]
      dict set lber_d vl [expr abs($x_curr_int) + abs($y_curr_int)]
      dict set lber_d vx $x_curr_int
      dict set lber_d vy $y_curr_int
    }
    set x_next [expr ([dict get $::ber_d $offset $prescale $y_curr_int $x_curr_int] == 0.0) ? ($x_curr + $xsign * $x_offs) : ($x_curr - $xsign * $x_offs)]
    set y_next [expr ([dict get $::ber_d $offset $prescale $y_curr_int $x_curr_int] == 0.0) ? ($y_curr + $ysign * $y_offs) : ($y_curr - $ysign * $y_offs)]
    set x_next_int [expr int($x_next)]
    set y_next_int [expr int($y_next)]
  }
  if $vec_done {
    if {[dict get $::ber_d $offset $prescale $y_curr_int $x_curr_int] == 0.0} {
      dict set ::ber_plot_d $offset $prescale [expr int($y_prev*$yscale)] [expr int($x_prev*$xscale)] [ber2ch [dict get $lber_d ber]]
    } else {
       dict set ::ber_plot_d $offset $prescale [expr int($y_curr*$yscale)] [expr int($x_curr*$xscale)] [ber2ch [dict get $lber_d ber]]
    }
    puts " > BER on eye border: [dict get $lber_d ber]"
    # return 1 if errors at 0 point, recalibration after 1. vector necessary for US/US+ GTY an redo it
    return [expr ([dict get $lber_d ber] != 0.0 && $x_curr_int == 0 && $y_curr_int == 0) ? 1 : 0]
  } else {
    return 0
  }
}
proc es_mat {xmax xdiv xoffs ymax ydiv yoffs prescale intdw vrange xscale yscale dfe dbg} {
  global offset
  set xgridoffs [expr int($xmax / $xdiv)]
  set ygridoffs [expr -1 * int($ymax / $ydiv)]
  if {$xdiv == -1} {
    set xgridoffs 1
  } 
  if {$ydiv == -1} {
    set ygridoffs -1
  } 
  for {set ypt [expr $ymax + $ygridoffs]} {$ypt > (-1 * $ymax)} {incr ypt [expr ($ygridoffs == 0) ? 1 : $ygridoffs]} {
    for {set xpt [expr $xgridoffs - $xmax]} {$xpt < $xmax} {incr xpt [expr ($xgridoffs == 0) ? 1 : $xgridoffs]} {
      set xpts [expr $xpt + $xoffs]
      set ypts [expr $ypt + $yoffs]
      set xpto [expr ($xpts > $xmax) ? $xmax : (($xpts < (-1 * $xmax)) ? (-1 * $xmax) : $xpts)]
      set ypto [expr ($ypts > $ymax) ? $ymax : (($ypts < (-1 * $ymax)) ? (-1 * $ymax) : $ypts)]
      if {[dict get $::ber_d $offset $prescale $ypto $xpto] == -1} {
        dict set ::ber_d      $offset $prescale $ypto                     $xpto                     [es_point $xpto $ypto $prescale $intdw $vrange $dfe $dbg]
        dict set ::ber_plot_d $offset $prescale [expr int($ypto*$yscale)] [expr int($xpto*$xscale)] [ber2ch [dict get $::ber_d $offset $prescale $ypto $xpto]]
        puts -nonewline [ber2ch [dict get $::ber_d $offset $prescale $ypto $xpto]]
        if $dbg { puts " point: $xpto $ypto ber=[dict get $::ber_d $offset $prescale $ypto $xpto] " }
      }
    }
    puts ""
  }
}
proc sweep_prescale { use_mat ps_min ps_max max_circle_div xamax xmat_div xmat_offs yamax ymat_div ymat_offs intdw vrange xscale yscale dfe { dbg 0 } } {
  global offset
  set full_circle [expr 4*($xamax+$yamax)]
  for {set ps $ps_min} {$ps <= $ps_max} {incr ps} {
    # write prescale
    if {$ps != -1} {
       ES_PRESCALE $ps
    }
    if $use_mat {
       es_mat $xamax $xmat_div $xmat_offs $yamax $ymat_div $ymat_offs $ps $intdw $vrange $xscale $yscale $dfe $dbg
    } else {
      # sweep angle of vector
      set end_vec [expr ($max_circle_div == -1) ? $full_circle : $max_circle_div]
      set gty_cal_try 10
      for {set vec 0} {$vec < $end_vec} {incr vec} {
        if {$vec == 0} {
          switch [get_chinfo type] {
             GTYE3_CHANNEL -
             GTYE4_CHANNEL {
               while {[es_vec [dict get $::c_d $vec x] [dict get $::c_d $vec y] $ps $intdw $vrange $xscale $yscale $dfe $dbg] && $gty_cal_try} {
                  # do recal
                  puts -nonewline "realignment sequence: moves the Eye Scan clock in 2 UI increments "
                  ES_HORZ_OFFSET 0x880
                  eyescanreset 1
                  ES_HORZ_OFFSET 0x800
                  eyescanreset 0
                  puts "done"
                  incr gty_cal_try -1
                  if {$gty_cal_try == 0} {puts "ERROR: eye is closed due to bad synchronization or link is down"}
               }
             }
             default {
               es_vec [dict get $::c_d $vec x] [dict get $::c_d $vec y] $ps $intdw $vrange $xscale $yscale $dfe $dbg
             }
          }
        } else {
          es_vec [dict get $::c_d $vec x] [dict get $::c_d $vec y] $ps $intdw $vrange $xscale $yscale $dfe $dbg
        }
      }
    }
    puts "
***************** scaled eye diagram for prescale value of $ps ****************************"
    ploteye $offset ps $ps
  }
}
    
proc es_vec_ber {endx endy ber intdw vrange xscale yscale dfe dbg} {
  global offset

  set xsign [expr ( $endx >= 0) ? (1.0) : (-1.0)]
  set ysign [expr ( $endy >= 0) ? (1.0) : (-1.0)]

  # find eye border in armed state first and then search with prescale until ber is reached (prescale selected according to ug578, table 4-17, up to 80 bus width)
  set prescale -1
  puts -nonewline "x${endx}y${endy}:"
  set x_prev 0
  set y_prev 0
  set x_prev_int 0
  set y_prev_int 0
  set x_curr [expr $endx/2.0]
  set y_curr [expr $endy/2.0]
  set x_curr_int [expr int($x_curr)]
  set y_curr_int [expr int($y_curr)]
  set x_offs [expr abs(($x_curr - $x_prev)/2.0)]
  set y_offs [expr abs(($y_curr - $y_prev)/2.0)]
  dict set lber_d ber 0.0
  dict set lber_d vl [expr abs($endx) + abs($endy)]
  dict set lber_d vx $endx
  dict set lber_d vy $endy
  set last_ber 0.0
  set last_ber_before 0.0
  set vec_done 0
  # set first points if necessary
  if {[dict get $::ber_d $offset ber$ber $y_prev_int $x_prev_int] == -1} {
    dict set ::ber_d $offset ber$ber $y_prev_int $x_prev_int [es_point $x_prev_int $y_prev_int $prescale $intdw $vrange $dfe $dbg]
    puts -nonewline .
    if $dbg { puts "$x_prev_int $y_prev_int [dict get $::ber_d $offset ber$ber $y_prev_int $x_prev_int]" }
    incr vec_done
  }
  if { ([dict get $::ber_d $offset ber$ber $y_prev_int $x_prev_int] != 0.0) && ((abs($x_prev_int) + abs($y_prev_int)) < [dict get $lber_d vl])} {
    dict set lber_d ber [dict get $::ber_d $offset ber$ber $y_prev_int $x_prev_int]
    dict set lber_d vl [expr abs($x_prev_int) + abs($y_prev_int)]
    dict set lber_d vx $x_prev_int
    dict set lber_d vy $y_prev_int
  }
  if {[dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] == -1} {
    dict set ::ber_d $offset ber$ber $y_curr_int $x_curr_int [es_point $x_curr_int $y_curr_int $prescale $intdw $vrange $dfe $dbg]
    puts -nonewline .
    if $dbg { puts "$x_curr_int $y_curr_int [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]" }
    incr vec_done
  }
  if { ([dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] != 0.0) && ((abs($x_curr_int) + abs($y_curr_int)) < [dict get $lber_d vl])} {
    dict set lber_d ber [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]
    dict set lber_d vl [expr abs($x_curr_int) + abs($y_curr_int)]
    dict set lber_d vx $x_curr_int
    dict set lber_d vy $y_curr_int
  }
  set x_next [expr ([dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] == 0.0) ? ($x_curr + $xsign * $x_offs) : ($x_curr - $xsign * $x_offs)]
  set y_next [expr ([dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] == 0.0) ? ($y_curr + $ysign * $y_offs) : ($y_curr - $ysign * $y_offs)]
  set x_next_int [expr int($x_next)]
  set y_next_int [expr int($y_next)]
  while {(($x_next_int != $x_prev_int) || ($y_next_int != $y_prev_int)) && (($x_next_int != $x_curr_int) || ($y_next_int != $y_curr_int))} {
    set x_prev $x_curr
    set y_prev $y_curr
    set x_prev_int $x_curr_int
    set y_prev_int $y_curr_int
    set x_curr $x_next
    set y_curr $y_next
    set x_curr_int $x_next_int
    set y_curr_int $y_next_int
    set x_offs [expr abs(($x_curr - $x_prev)/2.0)]
    set y_offs [expr abs(($y_curr - $y_prev)/2.0)]
    if {[dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] == -1} {
      dict set ::ber_d $offset ber$ber $y_curr_int $x_curr_int [es_point $x_curr_int $y_curr_int $prescale $intdw $vrange $dfe $dbg]
      puts -nonewline .
      if $dbg { puts "$x_curr_int $y_curr_int [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]" }
      incr vec_done
    }
    if { ([dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] != 0.0) && ((abs($x_curr_int) + abs($y_curr_int)) < [dict get $lber_d vl])} {
      dict set lber_d ber [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]
      dict set lber_d vl [expr abs($x_curr_int) + abs($y_curr_int)]
      dict set lber_d vx $x_curr_int
      dict set lber_d vy $y_curr_int
    }
    set x_next [expr ([dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] == 0.0) ? ($x_curr + $xsign * $x_offs) : ($x_curr - $xsign * $x_offs)]
    set y_next [expr ([dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] == 0.0) ? ($y_curr + $ysign * $y_offs) : ($y_curr - $ysign * $y_offs)]
    set x_next_int [expr int($x_next)]
    set y_next_int [expr int($y_next)]
  }
  if $vec_done {
    if {[dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] == 0.0} {
      dict set ::ber_plot_d $offset ber$ber [expr int($y_prev*$yscale)] [expr int($x_prev*$xscale)] [ber2ch [dict get $lber_d ber]]
    } else {
      dict set ::ber_plot_d $offset ber$ber [expr int($y_curr*$yscale)] [expr int($x_curr*$xscale)] [ber2ch [dict get $lber_d ber]]
    }
    puts -nonewline " > eye border found in armed state"
    if {([dict get $lber_d ber] != 0.0) && ($x_curr_int == 0) && ($y_curr_int == 0)} {
      # return 1 if errors at 0 point, recalibration after 1. vector necessary for US/US+ GTY an redo it
      puts ""
      return 1
    } else {
      # find ber
      # set prescale to necessary value
      if {$ber < 6} {
        set prescale 0
      } elseif {$ber > 15} {
        set prescale 31
      } else {
        switch ${ber}_$intdw {
          6_80 -
          6_64 -
          6_40 {set prescale 0}
          6_32 -
          6_20 {set prescale 1}
          6_16 {set prescale 2}
          7_80 -
          7_64 {set prescale 3}
          7_40 -
          7_32 {set prescale 4}
          7_20 -
          7_16 {set prescale 5}
          8_80 -
          8_64 {set prescale 6}
          8_40 -
          8_32 {set prescale 7}
          8_20 -
          8_16 {set prescale 8}
          9_80 {set prescale 9}
          9_64 -
          9_40 {set prescale 10}
          9_32 -
          9_20 {set prescale 11}
          9_16 {set prescale 12}
          10_80 -
          10_64 {set prescale 13}
          10_40 -
          10_32 {set prescale 14}
          10_20 -
          10_16 {set prescale 15}
          11_80 -
          11_64 {set prescale 16}
          11_40 -
          11_32 {set prescale 17}
          11_20 -
          11_16 {set prescale 18}
          12_80 {set prescale 19}
          12_64 -
          12_40 {set prescale 20}
          12_32 -
          12_20 {set prescale 21}
          12_16 {set prescale 22}
          13_80 -
          13_64 {set prescale 23}
          13_40 -
          13_32 {set prescale 24}
          13_20 -
          13_16 {set prescale 25}
          14_80 -
          14_64 {set prescale 26}
          14_40 -
          14_32 {set prescale 27}
          14_20 -
          14_16 {set prescale 28}
          15_80 {set prescale 29}
          15_64 -
          15_40 {set prescale 30}
          15_32 -
          15_20 -
          15_16 {set prescale 31}
        }
      }
      set rber [expr pow(10, -1*$ber)]
      if $dbg { puts " ber=$ber ($rber); intdw=$intdw; prescale=$prescale" }
      # measure current point and move to center until ber is found, remeasure points if needed
      dict set ::ber_d $offset ber$ber $y_curr_int $x_curr_int [es_point $x_curr_int $y_curr_int $prescale $intdw $vrange $dfe $dbg]
      dict set ::ber_plot_d $offset ber$ber [expr int($y_curr*$yscale)] [expr int($x_curr*$xscale)] [ber2ch [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]]
      puts -nonewline .
      if {[dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] != 0.0} {
        dict set lber_d ber [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]
        dict set lber_d vl [expr abs($x_curr_int) + abs($y_curr_int)]
        dict set lber_d vx $x_curr_int
        dict set lber_d vy $y_curr_int
      }
      if $dbg { puts " prescale=$prescale $x_curr_int $y_curr_int [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]" }
      set vecfac [expr ($x_curr+$y_curr)/($endx+$endy)]
      set x_next [expr ($endx * $vecfac)]
      set y_next [expr ($endy * $vecfac)]
      set x_next_int [expr int($x_next)]
      set y_next_int [expr int($y_next)]
      if $dbg { puts "$endx $endy $vecfac $x_next_int $y_next_int" }
      if {[dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] == 0.0} {
        # move out
        while {[dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] < $rber} {
          while {($x_next_int == $x_curr_int) && ($y_next_int == $y_curr_int) && ($vecfac <= 1.0)} {
            set vecfac [expr $vecfac + 0.001]
            set x_next [expr ($endx * $vecfac)]
            set y_next [expr ($endy * $vecfac)]
            set x_next_int [expr int($x_next)]
            set y_next_int [expr int($y_next)]
          }
          if $dbg { puts "$endx $endy $vecfac $x_next_int $y_next_int" }
          set x_curr $x_next
          set y_curr $y_next
          set x_curr_int $x_next_int
          set y_curr_int $y_next_int
          dict set ::ber_d $offset ber$ber $y_curr_int $x_curr_int [es_point $x_curr_int $y_curr_int $prescale $intdw $vrange $dfe $dbg]
          dict set ::ber_plot_d $offset ber$ber [expr int($y_curr*$yscale)] [expr int($x_curr*$xscale)] [ber2ch [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]]
          puts -nonewline .
          if $dbg { puts "$x_curr_int $y_curr_int [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]" }
          if {[dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] != 0.0} {
            dict set lber_d ber [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]
            dict set lber_d vl [expr abs($x_curr_int) + abs($y_curr_int)]
            dict set lber_d vx $x_curr_int
            dict set lber_d vy $y_curr_int
          }
        }
      }
      while {[dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] > $rber} {
        while {($x_next_int == $x_curr_int) && ($y_next_int == $y_curr_int) && ($vecfac > 0)} {
          set vecfac [expr $vecfac - 0.001]
          set x_next [expr ($endx * $vecfac)]
          set y_next [expr ($endy * $vecfac)]
          set x_next_int [expr int($x_next)]
          set y_next_int [expr int($y_next)]
          if $dbg { puts "$vecfac $x_curr_int $x_next_int $y_curr_int $y_next_int" }
        }
        if $dbg { puts "$endx $endy $vecfac $x_next_int $y_next_int" }
        set x_curr $x_next
        set y_curr $y_next
        set x_curr_int $x_next_int
        set y_curr_int $y_next_int
        dict set ::ber_d $offset ber$ber $y_curr_int $x_curr_int [es_point $x_curr_int $y_curr_int $prescale $intdw $vrange $dfe $dbg]
        dict set ::ber_plot_d $offset ber$ber [expr int($y_curr*$yscale)] [expr int($x_curr*$xscale)] [ber2ch [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]]
        puts -nonewline .
        if {[dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] != 0.0} {
          dict set lber_d ber [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]
          dict set lber_d vl [expr abs($x_curr_int) + abs($y_curr_int)]
          dict set lber_d vx $x_curr_int
          dict set lber_d vy $y_curr_int
        }
        if $dbg { puts "$x_curr_int $y_curr_int [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]" }
        if {[dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int] == 0.0} { continue }
      }
      
      #puts " > BER on eye border: [dict get $::ber_d $offset ber$ber $y_curr_int $x_curr_int]"
      puts " > BER on eye border: [dict get $lber_d ber]"
      return 0
    }
  } else {
    return 0
  }
}

proc find_target_ber { t_ber max_circle_div full_circle intdw vrange xscale yscale dfe { dbg 0 }} {
  global offset
  # sweep angle of vector
  set end_vec [expr ($max_circle_div == -1) ? $full_circle : $max_circle_div]
  set gty_cal_try 10
  for {set vec 0} {$vec < $end_vec} {incr vec} {
    if {$vec == 0} {
      switch [get_chinfo type] {
        GTYE4_CHANNEL {
          while {[es_vec_ber [dict get $::c_d $vec x] [dict get $::c_d $vec y] $t_ber $intdw $vrange $xscale $yscale $dfe $dbg] && $gty_cal_try} {
            # do recal
            puts -nonewline "realignment sequence: moves the Eye Scan clock in 2 UI increments "
            ES_HORZ_OFFSET 0x880
            eyescanreset 1
            ES_HORZ_OFFSET 0x800
            eyescanreset 0
            puts "done"
            incr gty_cal_try -1
            if {$gty_cal_try == 0} {puts "ERROR: eye is closed due to bad synchronization or link is down"}
          }
        }
        default {
           es_vec_ber [dict get $::c_d $vec x] [dict get $::c_d $vec y] $t_ber $intdw $vrange $xscale $yscale $dfe $dbg
        }
      }
    } else {
         es_vec_ber [dict get $::c_d $vec x] [dict get $::c_d $vec y] $t_ber $intdw $vrange $xscale $yscale $dfe $dbg
    }
  }
  puts "
***************** eye diagram for target BER of 1e-$t_ber ****************************"
  ploteye $offset ber $t_ber
}

proc do_reset {} {
  global offset
  global channel_offset
  global vio_regs_offset
  set offset $vio_regs_offset
  reset_all 1
  reset_all 0
  puts -nonewline "waiting for RXRESETDONE ... "
  while {1} {
    if [RXRESETDONE] {break}
    puts -nonewline "." 
  }
  puts "done"
  set offset $channel_offset
}
proc test_scr { { dbg 1 } } {
  global offset
  # get device configuration and test configuration
  set_es_init

  # retrieve device configuration
  set intdw [get_chinfo $offset intdw]
  set rxout_div [get_chinfo $offset rxout_div]

  # retrieve test configuration
  set vrange [get_chinfo vrange]
  set dfe [get_chinfo vrange]
  dict set ::_chinfo_d $offset dbg $dbg
  set init_window [get_chinfo init_window]
  set t_ber [get_chinfo ber]
  # prescale start and end point, value range -1 - 31, min <= max, -1 - means quick armed mode
  set ps_min [get_chinfo prescale_min]
  set ps_max [get_chinfo prescale_max]
  # vectors used in plot the eye (power of 2) or -1 draw full eye circle in matrix
  set max_circle_div [get_chinfo max_circle_div]
  set use_mat [get_chinfo use_matrix]
  set xmat_div [get_chinfo matrix_xaxis_div]
  set ymat_div [get_chinfo matrix_yaxis_div]
  set xmat_offs [get_chinfo matrix_xaxis_offset]
  set ymat_offs [get_chinfo matrix_yaxis_offset]

  set xamax [expr 32 * $rxout_div]
  set yamax 127
  set full_circle [ expr 4 * ($xamax + $yamax) ]
  if $init_window {  set_init_window $xamax $yamax  }

  # scaled measurement data
  set xmaxplot 32
  set ymaxplot 8
  set xscale [expr (1.0*$xmaxplot/$xamax)]
  set yscale [expr (1.0*$ymaxplot/$yamax)]
  if $init_window { set_init_scaled_window $xmaxplot $ymaxplot }
  set_circle_dict $xamax $yamax $dbg
  if { $t_ber != -1 } {
     find_target_ber $t_ber $max_circle_div $full_circle $intdw $vrange $xscale $yscale $dfe $dbg
  } else {
    sweep_prescale $use_mat $ps_min $ps_max $max_circle_div $xamax $xmat_div $xmat_offs $yamax $ymat_div $ymat_offs $intdw $vrange $xscale $yscale $dfe $dbg
  }
  set fh [open ber_d.json w]
  puts $fh [dict2json $::ber_d]
  close $fh
  set fh [open ber_plot_d.json w]
  puts $fh [dict2json $::ber_plot_d]
  close $fh
}

#set channel_offset [expr 0x44a11000]
#set vio_regs_offset [expr 0x44a12000]
#set common_offset [expr 0x44a10000]

#test_scr
