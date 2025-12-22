`include "include/params.vh"
`timescale 1ns / 1ps

module tb_dlx_control;

    reg clk;
    reg reset;
    reg step_en;
    reg busy;
    reg [31:0] data_in;

    wire mr;
    wire mw;
    wire gpr_we;
    wire [2:0] sm_state;
    wire [4:0] reg_address;
    wire [9:0] pc;
    wire [15:0] memory_address;

    // DUT
    dlx_control dut (
        .clk(clk),
        .reset(reset),
        .step_en(step_en),
        .busy(busy),
        .data_in(data_in),
        .mr(mr),
        .mw(mw),
        .gpr_we(gpr_we),
        .sm_state(sm_state),
        .reg_address(reg_address),
        .pc(pc),
        .memory_address(memory_address)
    );

    // Clock: 10ns period
    always #5 clk = ~clk;

    // Opcodes
    localparam INST_LW = 6'b100011;
    localparam INST_SW = 6'b101011;

    // Simple memory model behavior
    initial begin
        // VCD
        $dumpfile(`DUMP_FILE);
        $dumpvars(0);
        busy = 0;
        clk = 0;
        reset = 1;
        step_en = 0;
        data_in = 32'b0;

        // Reset
        #11;
        reset = 0;

        // === STEP 1: LOAD instruction ===
        // lw r1, 0x0010
        data_in = {
            INST_LW,      // opcode
            5'd0,         // rs (ignored)
            5'd1,         // rt = r1
            16'h0010      // address
        };

        step_en = 1;
        busy = 0;   // instruction fetch completes
        #10;
        step_en = 0;

        busy = 1;
        #30;
        // reset = 1;
        busy = 0;
        #10;
        reset = 0;
        busy = 1;
        #10;
        // LOAD data return
        data_in = 32'hDEADBEEF;
        #30;
        busy = 0;
        #10;
        data_in = 0;
        #20;
        // === STEP 2: STORE instruction ===
        // sw r1, 0x0020
        data_in = {
            INST_SW,
            5'd0,
            5'd12,
            16'h0020
        };
        step_en = 1;
        #10;
        step_en = 0;
        // step_en = 1;
        busy = 0;
        #20;

        busy = 1;
        #20;

        busy = 0;
        #10;

        step_en = 0;

        #50;
        $finish;
    end

endmodule
