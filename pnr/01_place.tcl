
# must fit PDN rings between core and die, space > ring_width * 2 + spacings + offset
# placement padding in SITE widths applied to both sides for higher utilization
# set global_place_pad 0
# set detail_place_pad 0
# Padding makes cells appear larger to GPL (and DPL) in order to prevent placing cells too close to each other. These larger cell sizes will cause it to look like the utilization is higher because there is less free space.

# site ROW are horizontal tracks inside the core area that define where standard cells can be legally placed, each site row has a fixed height exactly matching the height of standard cells

# Core utilization is a measure of how much of the core area is occupied by standard cells, macros, and other components. The remaining area is left for routing and additional optimization. If the core utilization is too high, routing becomes challenging, leading to congestion and potential timing violations. Conversely, if the utilization is too low, valuable silicon space is wasted.
# A typical core utilization target is around 70–80%, leaving sufficient space for routing and optimization.

# initialize_floorplan -site $site -utilization 80 -core_space 0.4 -aspect_ratio 1.0

initialize_floorplan -site $site -die_area $die_area -core_area $core_area

source $tracks_file

# remove buffers inserted by synthesis
remove_buffers

if { $pre_placed_macros_file != "" } {
  source $pre_placed_macros_file
}

################################################################
# Macro Placement
if { [have_macros] } {
  lassign $macro_place_halo halo_x halo_y
  set_macro_base_halo $halo_x $halo_y
  set report_dir [make_result_file ${design}_${platform}_rtlmp]
  rtl_macro_placer -report_directory $report_dir
}

################################################################
# Tapcell insertion
# eval tapcell $tapcell_args ;# tclint-disable command-args
tapcell {*}$tapcell_args

################################################################
# Power distribution network insertion
source $pdn_cfg
pdngen

################################################################
# Global placement

foreach layer_adjustment $global_routing_layer_adjustments {
  lassign $layer_adjustment layer adjustment
  set_global_routing_layer_adjustment $layer $adjustment
}
set_routing_layers -signal $global_routing_layers -clock $global_routing_clock_layers
set_macro_extension 2

# Global placement skip IOs
global_placement -density $global_place_density -pad_left $global_place_pad -pad_right $global_place_pad -skip_io

# IO Placement
include -echo $pin_file

place_pins -hor_layers $io_placer_hor_layer -ver_layers $io_placer_ver_layer

# Global placement with placed IOs and routability-driven
global_placement -routability_driven -density $global_place_density \
  -pad_left $global_place_pad -pad_right $global_place_pad

# checkpoint
set global_place_db [make_result_file ${design}_${platform}_global_place.db]
write_db $global_place_db

################################################################
# Repair max slew/cap/fanout violations and normalize slews
source $layer_rc_file
set_wire_rc -signal -layer $wire_rc_layer
set_wire_rc -clock -layer $wire_rc_layer_clk
set_dont_use $dont_use

estimate_parasitics -placement

repair_design -slew_margin $slew_margin -cap_margin $cap_margin

repair_tie_fanout -separation $tie_separation $tielo_port
repair_tie_fanout -separation $tie_separation $tiehi_port

set_placement_padding -global -left $detail_place_pad -right $detail_place_pad
detailed_placement

# post resize timing report (ideal clocks)
report_worst_slack -min -digits 3
report_worst_slack -max -digits 3
report_tns -digits 3
# Check slew repair
report_check_types -max_slew -max_capacitance -max_fanout -violators

utl::metric "RSZ::repair_design_buffer_count" [rsz::repair_design_buffer_count]
utl::metric "RSZ::max_slew_slack" [expr [sta::max_slew_check_slack_limit] * 100]
utl::metric "RSZ::max_fanout_slack" [expr [sta::max_fanout_check_slack_limit] * 100]
utl::metric "RSZ::max_capacitance_slack" [expr [sta::max_capacitance_check_slack_limit] * 100]
