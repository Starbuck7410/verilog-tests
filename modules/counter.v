module counter #(
    parameter WIDTH = 8
)(
    input clk,
    input enable,
    output reg [WIDTH - 1:0] count
);

    initial begin
        count = 0;
    end

    
    always @(posedge clk) begin
        if(enable) begin
            count <= count + 1;
        end
    end
    

endmodule