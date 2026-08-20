
source helpers.tcl
source flow_helpers.tcl
source asap7/asap7.vars

set design $::env(VLOG_TOP)
set top_module $::env(VLOG_TOP)
set synth_verilog $::env(NETLIST)

set pin_file pin_constraints.tcl
set sdc_file pnr.sdc

set die_area {0 0 30 30}
set core_area {0.4 0.4 29.6 29.6}

# set die_area {0 0 50 50}
# set core_area {2 2 48 48}

# include -echo flow.tcl

include -echo 00_init.tcl

include -echo 01_place.tcl
include -echo 02_place.tcl
include -echo 03_route.tcl
