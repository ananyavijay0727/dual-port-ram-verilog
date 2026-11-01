`timescale 1ns/1ps

// Self-checking testbench for dual_port_ram
module dual_port_ram_tb;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;
    localparam DEPTH = 1 << ADDR_WIDTH;

    reg                   clk_a = 0, clk_b = 0;
    reg                   we_a  = 0, we_b  = 0;
    reg  [ADDR_WIDTH-1:0] addr_a = 0, addr_b = 0;
    reg  [DATA_WIDTH-1:0] din_a = 0, din_b = 0;
    wire [DATA_WIDTH-1:0] dout_a, dout_b;

    integer errors = 0;
    integer k;

    // Device under test
    dual_port_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk_a(clk_a), .we_a(we_a), .addr_a(addr_a), .din_a(din_a), .dout_a(dout_a),
        .clk_b(clk_b), .we_b(we_b), .addr_b(addr_b), .din_b(din_b), .dout_b(dout_b)
    );

    // Two independent clocks (different periods)
    always #5 clk_a = ~clk_a;   // 100 MHz
    always #7 clk_b = ~clk_b;   // ~71 MHz

    // ---------------- Tasks ----------------
    task write_a(input [ADDR_WIDTH-1:0] a, input [DATA_WIDTH-1:0] d);
    begin
        @(negedge clk_a);
        addr_a = a; din_a = d; we_a = 1;
        @(negedge clk_a);
        we_a = 0;
    end
    endtask

    task write_b(input [ADDR_WIDTH-1:0] a, input [DATA_WIDTH-1:0] d);
    begin
        @(negedge clk_b);
        addr_b = a; din_b = d; we_b = 1;
        @(negedge clk_b);
        we_b = 0;
    end
    endtask

    task read_check_a(input [ADDR_WIDTH-1:0] a, input [DATA_WIDTH-1:0] expected);
    begin
        @(negedge clk_a);
        we_a = 0; addr_a = a;
        @(posedge clk_a); #1;
        if (dout_a !== expected) begin
            $display("FAIL  port A addr=%0h expected=%0h got=%0h", a, expected, dout_a);
            errors = errors + 1;
        end else
            $display("PASS  port A addr=%0h data=%0h", a, dout_a);
    end
    endtask

    task read_check_b(input [ADDR_WIDTH-1:0] a, input [DATA_WIDTH-1:0] expected);
    begin
        @(negedge clk_b);
        we_b = 0; addr_b = a;
        @(posedge clk_b); #1;
        if (dout_b !== expected) begin
            $display("FAIL  port B addr=%0h expected=%0h got=%0h", a, expected, dout_b);
            errors = errors + 1;
        end else
            $display("PASS  port B addr=%0h data=%0h", a, dout_b);
    end
    endtask

    // ---------------- Test sequence ----------------
    initial begin
        $dumpfile("dual_port_ram_tb.vcd");
        $dumpvars(0, dual_port_ram_tb);

        #20;

        $display("\nTest 1: write via port A, read via port B");
        write_a(4'h3, 8'hA5);
        read_check_b(4'h3, 8'hA5);

        $display("\nTest 2: write via port B, read via port A");
        write_b(4'h7, 8'h3C);
        read_check_a(4'h7, 8'h3C);

        $display("\nTest 3: simultaneous writes to different addresses");
        fork
            write_a(4'h1, 8'h11);
            write_b(4'h2, 8'h22);
        join
        read_check_a(4'h1, 8'h11);
        read_check_b(4'h2, 8'h22);

        $display("\nTest 4: simultaneous read (A) and write (B), different addresses");
        write_a(4'h5, 8'h55);
        fork
            write_b(4'h6, 8'h66);
            read_check_a(4'h5, 8'h55);
        join
        read_check_b(4'h6, 8'h66);

        $display("\nTest 5: fill all locations via A, read back via B");
        for (k = 0; k < DEPTH; k = k + 1)
            write_a(k, k + 8'h10);
        for (k = 0; k < DEPTH; k = k + 1)
            read_check_b(k, k + 8'h10);

        $display("\n------------------------------------");
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d error(s)", errors);
        $display("------------------------------------\n");

        $stop;
    end

endmodule
