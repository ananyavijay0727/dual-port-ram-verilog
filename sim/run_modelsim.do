# ModelSim / Questa run script (run from the repository root)
vlib work
vlog rtl/dual_port_ram.v tb/dual_port_ram_tb.v
vsim -voptargs=+acc work.dual_port_ram_tb
add wave -radix hex -r /dual_port_ram_tb/*
run -all
wave zoom full
