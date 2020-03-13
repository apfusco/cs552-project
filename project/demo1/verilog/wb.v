/*
   CS/ECE 552 Spring '20
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
module wb (instr,
           alu_out,
           mem_out,
           PC_inc,
           set,
           rd_data_1,
           sext_imm,
           wr_reg_sel,
           wr_data);

   input  [15:0] instr;
   input  [15:0] alu_out;
   input  [15:0] mem_out;
   input  [15:0] PC_inc;
   input  set;
   input  [15:0] rd_data_1;
   input  [15:0] sext_imm;
   input  [2:0]  wr_reg_sel;
   output [15:0] wr_data;

   wire [15:0] set_ext;
   wire [15:0] LBI;
   wire [15:0] SLBI;
   wire [15:0] dontcare;

   assign set_ext = {15'h0000, set};
   assign LBI = sext_imm;
   assign SLBI = {rd_data_1[7:0], sext_imm[7:0]};
   assign dontcare = 16'hXXXX;

   mux8_1 mux8_1_wr_data[15:0](.InA(alu_out),
                               .InB(mem_out),
                               .InC(PC_inc),
                               .InD(set_ext),
                               .InE(LBI),
                               .InF(SLBI),
                               .InG(dontcare),
                               .InH(dontcare),
                               .S(wr_reg_sel),
                               .Out(dontcare));

endmodule
