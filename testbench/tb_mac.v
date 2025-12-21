`include "include/params.vh"
`timescale 1ns/1ps

module tb_mac; // memory access control

    // Inputs
    reg clk;
    reg reset;
    reg ack_n;
    reg mr;
    reg mw;

    // Outputs
    wire [1:0] sm_state;
    wire as_n;
    wire stop_n;
    wire wr_n;
    wire in_init;
    wire busy;

    // DUT
    write_state_machine dut (
        .clk(clk),
        .reset(reset),
        .ack_n(ack_n),
        .mr(mr),
        .mw(mw),
        .sm_state(sm_state),
        .as_n(as_n),
        .stop_n(stop_n),
        .wr_n(wr_n),
        .in_init(in_init),
        .busy(busy)
    );

    // Clock: 10ns period
    always #5 clk = ~clk;

    initial begin
        // VCD
        $dumpfile(`DUMP_FILE);
        $dumpvars(0);

        // Init
        clk   = 0;
        reset = 1;
        ack_n = 1;
        mr    = 0;
        mw    = 0;

        // Hold reset
        #20;
        reset = 0;

        // ---- WRITE transaction ----
        // Request write
        #10;
        mw = 1;

        #10;
        mw = 0;

        // Wait one cycle, then acknowledge
        #30;
        ack_n = 0;

        // Release acknowledge
        #10;
        ack_n = 1;
        mw    = 0;

        // ---- READ transaction ----
        #30;
        mr = 1;

        #70;
        ack_n = 0;

        #10;
        ack_n = 1;
        mr    = 0;

        // Idle
        #20;

        $finish;
    end

endmodule
