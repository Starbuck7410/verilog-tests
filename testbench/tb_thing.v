// Qucs 26.1.1  /home/shraga/Documents/Homework/Y4S2/Lab B/555/Circuits/1.4.sch

`timescale 1ps/100fs

module ic74193 (
    // Subcircuit Node Order:
    // .SUBCKT 74193 COUNT_UP COUNT_DOWN _LOAD CLR D0 D1 D2 D3 Q0 Q1 Q2 Q3 _CO _BO VCC VGND

    // Clock Inputs
    input  wire COUNT_UP,   // Count up on rising edge
    input  wire COUNT_DOWN, // Count down on rising edge

    // Control Inputs
    input  wire _LOAD,      // Asynchronous Parallel Load (Active Low)
    input  wire CLR,        // Asynchronous Master Reset (Active High)

    // Split Data Inputs
    input  wire D0,
    input  wire D1,
    input  wire D2,
    input  wire D3,

    // Split Data Outputs
    output wire Q0,
    output wire Q1,
    output wire Q2,
    output wire Q3,

    // Terminal Count Outputs
    output wire _CO,        // Carry Out / Terminal Count Up (Active Low)
    output wire _BO,        // Borrow Out / Terminal Count Down (Active Low)

    // Power Pins (Included for SPICE Netlist Compatibility)
    input  wire VCC,
    input  wire VGND
);

    // Internal 4-bit register for the counter state
    reg [3:0] count_reg = 4'b0000;

    // Group individual data input bits into a temporary vector
    wire [3:0] d_vec = {D3, D2, D1, D0};

    // Main Counter Sequential Logic
    // Triggers on the rising edge of either clock, or the activation of asynchronous signals
    always @(posedge COUNT_UP or posedge COUNT_DOWN or posedge CLR or negedge _LOAD) begin

        // 1. Asynchronous Clear (Highest Priority)
        if (CLR == 1'b1) begin
            count_reg <= 4'b0000;

        // 2. Asynchronous Load (Second Priority)
        end else if (_LOAD == 1'b0) begin
            count_reg <= d_vec;

        // 3. Synchronous Counting Logic
        end else begin
            if (COUNT_UP == 1'b1) begin
                count_reg <= count_reg + 1'b1;
            end else if (COUNT_DOWN == 1'b1) begin
                count_reg <= count_reg - 1'b1;
            end
        end
    end

    // Assign internal register bits back to the individual output wires
    assign Q0 = count_reg[0];
    assign Q1 = count_reg[1];
    assign Q2 = count_reg[2];
    assign Q3 = count_reg[3];

    // Gating Logic for Carry Out (_CO)
    // Drops low only when counter is at Max (15) AND the COUNT_UP clock pulse is low
    assign _CO = (count_reg == 4'd15 && COUNT_UP == 1'b0) ? 1'b0 : 1'b1;

    // Gating Logic for Borrow Out (_BO)
    // Drops low only when counter is at Min (0) AND the COUNT_DOWN clock pulse is low
    assign _BO = (count_reg == 4'd0 && COUNT_DOWN == 1'b0) ? 1'b0 : 1'b1;

endmodule


module Sub_n74193 (net_net0, net_clk, net_net2, net_net3, net_net4, net_net5, net_net6, net_net7, net_net8, net_net9, net_net10, net_net11, net_net12, net_net13, net_net14, net_net15);
 inout net_net0, net_clk, net_net2, net_net3, net_net4, net_net5, net_net6, net_net7, net_net8, net_net9, net_net10, net_net11, net_net12, net_net13, net_net14, net_net15;


  ic74193 X1 (net_net0, net_clk, net_net2, net_net7, net_net3, net_net4, net_net5, net_net6, net_net8, net_net9, net_net10, net_net11, net_net12, net_net13, net_net14, net_net15);
endmodule

module TestBench ();
  `ifdef DUMP_FILE_NAME
      initial begin
          $dumpfile(`DUMP_FILE_NAME);
          $dumpvars(0);
      end
  `endif
  wire netNbo;
  wire netNco;
  wire netQ0;
  wire netQ1;
  wire netQ2;
  wire netQ3;
  wire net_net0;
  wire net_clk;
  wire net_net2;
  wire net_net3;
  wire net_net4;
  wire net_net5;
  wire net_net6;
  wire net_net7;
  wire net_net8;


  // S4 logic 1
  reg     net_regS4net_net0 = 1;
  assign  net_net0 = net_regS4net_net0;
  initial
    net_regS4net_net0 <= 1;

  // S7 logic 1
  reg     net_regS7net_net1 = 1;
  assign  net_clk = net_regS7net_net1;
  initial
    net_regS7net_net1 <= 1;

  // S9 logic 0
  reg     net_regS9net_net2 = 0;
  assign  net_net2 = net_regS9net_net2;
  initial
    net_regS9net_net2 <= 0;

  // S10 logic 0
  reg     net_regS10net_net3 = 0;
  assign  net_net3 = net_regS10net_net3;
  initial
    net_regS10net_net3 <= 0;

  // S11 logic 0
  reg     net_regS11net_net4 = 0;
  assign  net_net4 = net_regS11net_net4;
  initial
    net_regS11net_net4 <= 0;
  Sub_n74193 SUB1 (net_net5, net_net6, netNbo, net_net7, net_net0, net_clk, net_net8, net_net2, netQ0, netQ1, netQ2, netQ3, netNco, netNbo, net_net3, net_net4);

  // S12 digital source
  reg    net_srcS12net_net6;
  assign net_net6 = net_srcS12net_net6;
  always begin
    net_srcS12net_net6 = 0;
    #1000;
    net_srcS12net_net6 = 1;
    #1000;
  end

  // S13 logic 0
  reg     net_regS13net_net5 = 0;
  assign  net_net5 = net_regS13net_net5;
  initial
    net_regS13net_net5 <= 0;

  // S14 logic 0
  reg     net_regS14net_net8 = 0;
  assign  net_net8 = net_regS14net_net8;
  initial
    net_regS14net_net8 <= 0;

  // S15 logic 1
  reg     net_regS15net_net7 = 1;
  assign  net_net7 = net_regS15net_net7;
  initial
    net_regS15net_net7 <= 1;

  initial begin
    #100000 $finish;
  end

endmodule // TestBench
