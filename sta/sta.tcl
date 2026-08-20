
suppress_msg 1212

foreach file $::env(TECH_LIB) {
    read_liberty $file
}
read_verilog $::env(NETLIST)
link_design  $::env(VLOG_TOP)
read_sdc sta.sdc

# set_cmd_units -time ns -capacitance fF -current uA -voltage V -resistance kOhm -distance um
set sta_report_default_digits 3

write_sdf $::env(OUT_DIR)/$::env(VLOG_TOP).sdf

report_checks -path_delay max -fields {cap fanout slew}
