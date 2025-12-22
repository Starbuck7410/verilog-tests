module dlx_control (
    input clk,
    input reset,
    input step_en,
    input busy,
    input [31:0] data_in,
    output gpr_we,
    output reg mr,
    output reg mw,
    output reg [2:0] sm_state,
    output reg [4:0] reg_address,
    output reg [9:0] pc,
    output [15:0] memory_address
);
    localparam INIT = 3'h0;
    localparam FETCH = 3'h1;
    localparam DECODE = 3'h2;
    localparam LOAD = 3'h3;
    localparam STORE = 3'h4;
    localparam WRITEBACK = 3'h5;
    localparam HALT = 3'h6;

    localparam INST_LW = 6'b100011;
    localparam INST_SW = 6'b101011;

    reg [31:0] instruction;
    reg [5:0] opcode;


    initial begin 
        instruction = 0;
        sm_state = INIT;
        mr = 0;
        mw = 0;
        reg_address = 0;
        pc = 0;
    end    


    always @ (posedge clk or posedge reset) begin 

        if (reset) begin 
            sm_state <= INIT;
            mr <= 0;
            mw <= 0;
            pc <= 0;
            instruction <= 0;
        end

        else begin 

            if (sm_state == INIT && step_en) begin
                sm_state <= FETCH;
                mr <= 1;
            end

            else if (sm_state == FETCH && ~busy) begin
                instruction <= data_in;

                sm_state <= DECODE;
                mr <= 0;
                opcode <= data_in[31:26];
                reg_address <= data_in[20:16];
                pc <= pc + 1;


            end

            else if (sm_state == DECODE && opcode == INST_LW) begin
                sm_state <= LOAD;
                mr <= 1;
            end

            else if(sm_state == LOAD && !busy) begin
                sm_state <= WRITEBACK;
                mr <= 0;
            end

            else if(sm_state == DECODE && opcode == INST_SW) begin
                sm_state <= STORE;
                mw <= 1;
            end

            else if(sm_state == DECODE) begin
                sm_state <= HALT;
                mw <= 0;
                mr <= 0;
            end

            else if(sm_state == STORE && !busy) begin
                sm_state <= INIT;
                mw <= 0;
            end

            if(sm_state == WRITEBACK && ~step_en) begin 
                sm_state <= INIT;
                mr <= 0;
                mw <= 0;          
            end

        end    

    end

    assign memory_address = (sm_state == FETCH) ? {6'b0, pc} : instruction[15:0];
    assign gpr_we = !busy && (sm_state == LOAD); 
endmodule   