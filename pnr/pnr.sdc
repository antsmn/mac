
create_clock [get_ports clk] -name core_clock -period $::env(CLK_PERIOD)
set_all_input_output_delays .1
