yosys -import

file mkdir $::env(OUT_DIR)

set slang_args "-D SYNTHESIS"

foreach arg $::env(VLOG_DEFINES) {
    lappend slang_args -D $arg
}
foreach arg $::env(VLOG_PARAMS) {
    lappend slang_args -G $arg
}

if {$::env(VLOG_FLIST) != ""} {
    read_slang {*}$slang_args -F $::env(VLOG_FLIST) --keep-hierarchy --top $::env(VLOG_TOP)
}
if {$::env(VLOG_FILES) != ""} {
    read_slang {*}$slang_args {*}[glob $::env(VLOG_FILES)] --keep-hierarchy --top $::env(VLOG_TOP)
}


prep -run :check -flatten -top $::env(VLOG_TOP)

foreach file $::env(TECH_MAP_FILES) {
    techmap -map $file
}
techmap

# opt

clean -purge
check -assert

write_verilog -simple-lhs -nohex -nodec -noattr $::env(NETLIST)

stat
