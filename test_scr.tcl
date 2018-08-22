
set channel_offset [expr 0x44a11000]
set vio_regs_offset [expr 0x44a12000]
set common_offset [expr 0x44a10000]
set offset $channel_offset
source prbs_test.tcl
program_bit_file
prbs_test_ini
set offset $vio_regs_offset
reset_all 1
reset_all 0
set offset $channel_offset
proc set_tx { swing pre post } {
  global offset
  global channel_offset
  global vio_regs_offset
  set offset $vio_regs_offset
  # default 5'b11000
  txdiffctrl $swing 
  # default 5'b00000
  txprecursor $pre
  # default 5'b00000
  txpostcursor $post
  set offset $channel_offset
}
set_tx 48 0 0
exit
