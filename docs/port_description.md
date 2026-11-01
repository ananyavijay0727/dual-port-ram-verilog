# Port Description

## Parameters
| Parameter | Default | Description |
|---|---|---|
| DATA_WIDTH | 8 | Width of each memory word |
| ADDR_WIDTH | 4 | Address width (depth = 2^ADDR_WIDTH = 16 words) |

## Ports
| Signal | Dir | Width | Description |
|---|---|---|---|
| clk_a | in | 1 | Port A clock |
| we_a | in | 1 | Port A write enable (1 = write) |
| addr_a | in | ADDR_WIDTH | Port A address |
| din_a | in | DATA_WIDTH | Port A write data |
| dout_a | out | DATA_WIDTH | Port A read data (registered) |
| clk_b | in | 1 | Port B clock |
| we_b | in | 1 | Port B write enable |
| addr_b | in | ADDR_WIDTH | Port B address |
| din_b | in | DATA_WIDTH | Port B write data |
| dout_b | out | DATA_WIDTH | Port B read data (registered) |

## Behavior
- **Synchronous read/write** on the rising edge of each port's own clock.
- **Simultaneous access:** both ports may be active in the same cycle.
- **Same-port read during write:** returns the old data (read-before-write).
- **Same-address conflict:** simultaneous writes from both ports to one
  address are not supported, and the stored value is undefined.
