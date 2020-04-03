module mem_wb(
        // outputs
        out_wr_data,
        out_wr_en,
        out_wr_sel,
        out_alu_out,
        out_mem_out,
        out_PC_inc,
        out_LBI,
        out_SLBI,
        out_sext_imm,
        out_set,
        err,
        // inputs
        clk,
        rst,
        in_wr_data,
        in_wr_en,
        in_wr_sel,
        in_alu_out,
        in_mem_out,
        in_PC_inc,
        in_LBI,
        in_SLBI,
        in_sext_imm,
        in_set);

   output [15:0] out_wr_data;
   output        out_wr_en;
   output [2:0]  out_wr_reg;
   output [2:0]  out_wr_sel;
   output [15:0] out_alu_out;
   output [15:0] out_mem_out;
   output [15:0] out_PC_inc;
   output [15:0] out_LBI;
   output [15:0] out_SLBI;
   output [15:0] out_sext_imm;
   output        out_set;
   output        err;

   input        clk;
   input        rst;
   input [15:0] in_wr_data;
   input        in_wr_en;
   input [2:0]  in_wr_reg;
   input [2:0]  in_wr_sel;
   input [15:0] in_alu_out;
   input [15:0] in_mem_out;
   input [15:0] in_PC_inc;
   input [15:0] in_LBI;
   input [15:0] in_SLBI;
   input [15:0] in_sext_imm;
   input        in_set;

   // TODO: writeEn needs to be low in the event of a stall.
   // TODO: wr_en needs to be low in the event of a stall.
   register #(.N(16)) wr_data_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_wr_data), .dataOut(out_wr_data), .err());
   register #(.N(1)) wr_en_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_wr_en), .dataOut(out_wr_en), .err());
   register #(.N(3)) wr_reg_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_wr_reg), .dataOut(out_wr_reg), .err());
   register #(.N(3)) wr_sel_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_wr_sel), .dataOut(out_wr_sel), .err());
   register #(.N(16)) alu_out_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_alu_out), .dataOut(out_alu_out), .err());
   register #(.N(16)) mem_out_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_mem_out), .dataOut(out_mem_out), .err());
   register #(.N(16)) PC_inc_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_PC_inc), .dataOut(out_PC_inc), .err());
   register #(.N(16)) LBI_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_LBI), .dataOut(out_LBI), .err());
   register #(.N(16)) SLBI_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_SLBI), .dataOut(out_SLBI), .err());
   register #(.N(16)) sext_imm_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_sext_imm), .dataOut(out_sext_imm), .err());
   register #(.N(1)) set_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_set), .dataOut(out_set), .err());

endmodule
