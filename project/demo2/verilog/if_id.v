module if_id(out_instr, out_PC_inc, err, clk, rst, in_instr, in_PC_inc);

   output [15:0] out_instr;
   output [15:0] out_PC_inc;
   output err;

   input        clk;
   input        rst;
   input [15:0] in_instr;
   input [15:0] in_PC_inc;

   register #(.N(16)) instr_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_instr), .dataOut(out_instr), .err());
   register #(.N(16)) PC_inc_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_PC_inc), .dataOut(out_PC_inc), .err());

endmodule
