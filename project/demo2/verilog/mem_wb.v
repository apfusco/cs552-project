module mem_wb(/* TODO */);

   output [15:0] out_wr_reg;
   output        out_wr_en;
   output [2:0]  out_wr_sel;
   output [15:0] out_alu_out;
   output [15:0] out_mem_out;
   output [15:0] out_PC_inc;
   output [15:0] out_LBI;
   output [15:0] out_SLBI;
   output        out_set;
   output        err;

   input        clk;
   input        rst;
   input [15:0] in_wr_reg;
   input        in_wr_en;
   input [2:0]  in_wr_sel;
   input [15:0] in_alu_out;
   input [15:0] in_mem_out;
   input [15:0] in_PC_inc;
   input [15:0] in_LBI;
   input [15:0] in_SLBI;
   input        in_set;

   // TODO: writeEn needs to be low in the event of a stall.
   // TODO: wr_en needs to be low in the event of a stall.
   register #(.N(16)) wr_reg_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_wr_reg), .dataOut(out_wr_reg), .err());
   register #(.N(1)) wr_en_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_wr_en), .dataOut(out_wr_en), .err());
   register #(.N(3)) wr_sel_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_wr_sel), .dataOut(out_wr_sel), .err());
   register #(.N(16)) alu_out_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_alu_out), .dataOut(out_alu_out), .err());
   register #(.N(16)) mem_out_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_mem_out), .dataOut(out_mem_out), .err());
   register #(.N(16)) PC_inc_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_PC_inc), .dataOut(out_PC_inc), .err());
   register #(.N(16)) LBI_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_LBI), .dataOut(out_LBI), .err());
   register #(.N(16)) SLBI_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_SLBI), .dataOut(out_SLBI), .err());
   register #(.N(1)) set_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_set), .dataOut(out_set), .err()));

endmodule
