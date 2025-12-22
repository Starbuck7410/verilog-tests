`include "include/params.vh"

module tb_top ();
    reg clk;
    reg enable;
    reg reset;
    wire [2:0] count;

    counter #(
        .WIDTH(3)
    ) counter_3 (
        .reset(reset),
        .clk(clk),
        .enable(enable),
        .count(count)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile(`DUMP_FILE);
        $dumpvars(0);
        reset = 0;
        enable = 1;
        #30;
        enable = 0;
        #30;
        enable = 1;
        #70;
        reset = 1;
        #10;
        reset = 0;
        #30;

        $finish;

    end
endmodule