# dual-port-ram-verilog
RTL design of a Dual Port RAM in Verilog HDL supporting simultaneous read and write through two independent ports, verified with a self-checking testbench in Quartus Prime.
# Dual Port RAM (DPRAM) in Verilog HDL

RTL design of a parameterized Dual Port RAM with two independent ports, supporting simultaneous read and write operations. Simulated and verified using a self-checking testbench in Quartus Prime / ModelSim.

![Waveform](images/waveform_overview.png)

## Features
- Two independent ports (A and B), each with its own clock, address, data and write enable
- Simultaneous read and write through both ports
- Parameterized data width and address width (default 8-bit data, 16 words)
- Self-checking testbench with 5 test scenarios
- Documented behavior for same-port read-during-write and address conflicts

## Block diagram
![Block diagram](docs/block_diagram.png)

## Repository structure
```
dual-port-ram-verilog/
├── rtl/dual_port_ram.v         # RTL design
├── tb/dual_port_ram_tb.v       # Self-checking testbench
├── sim/run_modelsim.do         # ModelSim run script
├── docs/port_description.md    # Ports and behavior
└── images/                     # Waveforms and reports
```

## Ports
| Signal | Dir | Description |
|---|---|---|
| clk_a / clk_b | in | Port clocks |
| we_a / we_b | in | Write enables |
| addr_a / addr_b | in | Addresses |
| din_a / din_b | in | Write data |
| dout_a / dout_b | out | Read data (registered) |

Full details: [docs/port_description.md](docs/port_description.md)

## Verification
| Test | What it checks |
|---|---|
| 1 | Write via port A, read via port B |
| 2 | Write via port B, read via port A |
| 3 | Simultaneous writes to different addresses |
| 4 | Simultaneous read (A) and write (B) at different addresses |
| 5 | Fill all locations via A, read all back via B |

The testbench prints PASS/FAIL for every check and a final summary.

## How to run
**ModelSim / Questa**
```
vsim -c -do "do sim/run_modelsim.do"
```
or in the GUI, from the repo root: `do sim/run_modelsim.do`

**Quartus Prime**
1. Create a new project and add `rtl/dual_port_ram.v` as the top-level module
2. Add `tb/dual_port_ram_tb.v` as the testbench and run RTL simulation
3. Compile to view resource usage

## Results
- All [5/5] test scenarios pass
- Resource utilization (Quartus, [device name]): [X] logic elements, [Y] memory bits
- Simulation waveforms: see `images/`

## Tools
Verilog HDL | Quartus Prime | ModelSim

## Future improvements
- Add write-conflict detection or priority arbitration
- Add byte-enable support
- Randomized and constrained-random testing
- Synthesize and test on an FPGA board

## Author
Ananya Vijay | ECE, Dayananda Sagar College of Engineering
