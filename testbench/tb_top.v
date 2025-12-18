`include "include/params.vh"

module tb_top ();
    reg clk;
    reg enable;
    wire [2:0] count;

    counter #(
        .WIDTH(3)
    ) counter_3 (
        .clk(clk),
        .enable(enable),
        .count(count)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile(`DUMP_FILE);
        $dumpvars(0);
        
        enable = 1;
        #30;
        enable = 0;
        #30;
        enable = 1;
        #50 $finish;

    end
endmodule