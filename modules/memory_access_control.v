module memory_access_control(
    input clk,
    input reset,
    input ack_n,
    input mr,
    input mw,
    output reg [1:0] sm_state,
    output reg as_n,
    output stop_n,
    output reg wr_n,
    output reg in_init,
    output reg busy
    );

	localparam WAIT_REQUEST = 2'b00;
	localparam WAIT_ACK = 2'b01;
	localparam NEXT = 2'b10;
	
	reg [1:0] prev_state; 
	reg stop_n_reg;

	initial begin 
		sm_state = WAIT_REQUEST; // starting at the wait state
		stop_n_reg = 1;
		wr_n = 1;
		as_n = 1;
		in_init = 1;
		prev_state = WAIT_REQUEST;
        busy = 0;
	end

	always @ (posedge clk) begin 
		
		if(reset) begin
			sm_state = WAIT_REQUEST; // starting at the wait state
            stop_n_reg = 1;
            wr_n = 1;
            as_n = 1;
            in_init = 1;
            prev_state = WAIT_REQUEST;
            busy = 0;
		end
		else begin
		
			if(sm_state == WAIT_REQUEST && (mr || mw)) begin 
                prev_state <= WAIT_REQUEST;
				sm_state <= WAIT_ACK;

				wr_n <= mw & ~mr;
                as_n <= 0;
                in_init <= 0;
                busy <= 1;
			end	

			else if(sm_state == WAIT_ACK && !ack_n) begin 
				prev_state <= WAIT_ACK;
				sm_state <= NEXT;

                wr_n <= 1;
                as_n <= 1;
                in_init <= 1;
                busy <= 0;
			end

			else if(sm_state == NEXT) begin
				prev_state <= NEXT;
				sm_state <= WAIT_REQUEST;
			end

            else begin
                prev_state = sm_state;
            end
			
			stop_n_reg = (!prev_state == WAIT_ACK) ; 
		end
		
	end
	
	assign stop_n = stop_n_reg | !ack_n | (sm_state == NEXT) | (sm_state == WAIT_REQUEST);

endmodule