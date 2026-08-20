
set clk_name   $::env(CLK_NAME)
set clk_port   $::env(CLK_PORT)
set clk_period $::env(CLK_PERIOD)

set clk_frac 0.1

create_clock -name $clk_name -period $clk_period [get_ports -quiet $clk_port]

# set_clock_uncertainty $clk_frac clk

set delay [expr $clk_period * $clk_frac]
set inputs [all_inputs -no_clocks]
set outputs [all_outputs]

set_input_delay $delay -clock $clk_name $inputs
set_output_delay $delay -clock $clk_name $outputs

# set_false_path -from [get_ports rstn]

# set_timing_derate -late 1.05
# set_timing_derate -early 0.95
