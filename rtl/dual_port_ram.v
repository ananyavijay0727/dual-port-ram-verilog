// -----------------------------------------------------------------------------
// Dual Port RAM (true dual-port, synchronous)
// -----------------------------------------------------------------------------
// - Two independent ports (A and B), each with its own clock, write enable,
//   address, data input and data output.
// - Both ports can read or write in the same clock period, so reads and
//   writes can happen simultaneously through the two ports.
// - Parameterized data width and address width.
//
// Behavior notes:
// - Read is synchronous: dout updates one clock edge after the address.
// - Same-port read during write returns the OLD data (read-before-write).
// - Both ports writing the same address at the same time is not supported;
//   the final stored value is undefined. Avoid it at the system level.
// -----------------------------------------------------------------------------
module dual_port_ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    // Port A
    input  wire                  clk_a,
    input  wire                  we_a,
    input  wire [ADDR_WIDTH-1:0] addr_a,
    input  wire [DATA_WIDTH-1:0] din_a,
    output reg  [DATA_WIDTH-1:0] dout_a,

    // Port B
    input  wire                  clk_b,
    input  wire                  we_b,
    input  wire [ADDR_WIDTH-1:0] addr_b,
    input  wire [DATA_WIDTH-1:0] din_b,
    output reg  [DATA_WIDTH-1:0] dout_b
);

    localparam DEPTH = 1 << ADDR_WIDTH;

    // Memory array
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Initialise to zero (simulation and FPGA power-up)
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = {DATA_WIDTH{1'b0}};
    end

    // Port A
    always @(posedge clk_a) begin
        if (we_a)
            mem[addr_a] <= din_a;
        dout_a <= mem[addr_a];
    end

    // Port B
    always @(posedge clk_b) begin
        if (we_b)
            mem[addr_b] <= din_b;
        dout_b <= mem[addr_b];
    end

endmodule
