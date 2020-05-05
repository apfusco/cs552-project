/*
   CS/ECE 552, Spring '20
   Homework #3, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
module regFile (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                );

   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   /* YOUR CODE HERE */
   parameter N = 16;// Number of bits per register
   parameter S = 3; // Number of bits to select register
   parameter R = 2 ** S; // Number of registers

   wire [R-1:0]   reg_err;
   wire [R-1:0]   reg_wr;
   wire [R-1:0]   wr_en;
   wire [R*N-1:0] Q;

   register #(.N(N)) regs[R-1:0](.clk(clk), .rst(rst), .writeEn(wr_en),
                                 .dataIn(writeData), .dataOut(Q[R*N-1:0]),
                                 .err(reg_err));

   assign err = 1'b0;
   //assign err = |{reg_err, ((^{read1RegSel, read2RegSel, writeRegSel} === 1'bX) ? 1'b1 : 1'b0)};

   mux8_1 mux_read1RegSel[N-1:0](.InA(Q[1*N-1:0*N]),
                                 .InB(Q[2*N-1:1*N]),
                                 .InC(Q[3*N-1:2*N]),
                                 .InD(Q[4*N-1:3*N]),
                                 .InE(Q[5*N-1:4*N]),
                                 .InF(Q[6*N-1:5*N]),
                                 .InG(Q[7*N-1:6*N]),
                                 .InH(Q[8*N-1:7*N]),
                                 .S(read1RegSel),
                                 .Out(read1Data));
   mux8_1 mux_read2RegSel[N-1:0](.InA(Q[1*N-1:0*N]),
                                 .InB(Q[2*N-1:1*N]),
                                 .InC(Q[3*N-1:2*N]),
                                 .InD(Q[4*N-1:3*N]),
                                 .InE(Q[5*N-1:4*N]),
                                 .InF(Q[6*N-1:5*N]),
                                 .InG(Q[7*N-1:6*N]),
                                 .InH(Q[8*N-1:7*N]),
                                 .S(read2RegSel),
                                 .Out(read2Data));
   decoder3_8 dec_reg_wr(.Input(writeRegSel), .Output(reg_wr));
   assign wr_en = reg_wr & {R{writeEn}};

endmodule
