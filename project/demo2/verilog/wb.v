/*
   CS/ECE 552 Spring '20
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
module wb (alu_out,
           mem_out,
           PC_inc,
           set,
           rd_data_1,
           sext_imm,
           wr_sel,
           wr_data,
           LBI,
           SLBI,
           err);

   input  [15:0] alu_out;
   input  [15:0] mem_out;
   input  [15:0] PC_inc;
   input  set;
   input  [15:0] rd_data_1;
   input  [15:0] sext_imm;
   input  [2:0]  wr_sel;
   output [15:0] wr_data;
   input  [15:0] LBI;
   input  [15:0] SLBI;
   output err;

   wire [15:0] set_ext;
   wire [15:0] dontcare;

   assign set_ext = {15'h0000, set};
   assign dontcare = 16'hXXXX;
   assign err = (^{alu_out, mem_out, PC_inc, set, rd_data_1, sext_imm, wr_sel,
         LBI, SLBI} === 1'bX) ? 1'b1 : 1'b0;

   mux8_1 mux8_1_wr_data[15:0](.InA(alu_out),
                               .InB(mem_out),
                               .InC(PC_inc),
                               .InD(set_ext),
                               .InE(LBI),
                               .InF(SLBI),
                               .InG(dontcare),
                               .InH(dontcare),
                               .S(wr_sel),
                               .Out(wr_data));

endmodule
