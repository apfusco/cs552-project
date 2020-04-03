module ex_mem(
        // outputs
        out_ofl,
        out_alu_out,
        out_zero,
        out_PC_src,
        out_sext_imm, 
        out_PC_sext_imm,
        out_reg_sext_imm,
        out_ltz,
        out_lteq,
        out_set_sel,
        out_mem_wr_en,
        out_mem_en,
        out_wr_sel,
        err,
        // inputs
        clk,
        rst,
        in_ofl,
        in_alu_out,
        in_zero,
        in_PC_src,
        in_sext_imm,
        in_PC_sext_imm,
        in_reg_sext_imm,
        in_ltz,
        in_lteq,
        in_set_sel,
        in_mem_wr_en,
        in_mem_en,
        in_wr_sel);

   output        out_ofl;
   output [15:0] out_alu_out;
   output        out_zero;
   output        out_PC_src;      // High for for using PC_inc + PC_sext_imm
   output [15:0] out_sext_imm,
   output [15:0] out_PC_sext_imm;
   output [15:0] out_reg_sext_imm;
   output        out_ltz;
   output        out_lteq;
   output [1:0]  out_set_sel;
   output        out_mem_wr_en;
   output        out_mem_en;
   output [1:0]  out_wr_sel;
   output        err;

   input        clk;
   input        rst;
   input        in_ofl;
   input [15:0] in_alu_out;
   input        in_zero;
   input        in_PC_src;      // High for for using PC_inc + PC_sext_imm
   input [15:0] in_sext_imm;
   input [15:0] in_PC_sext_imm;
   input [15:0] in_reg_sext_imm;
   input        in_ltz;
   input        in_lteq;
   input [1:0]  in_set_sel;
   input        in_mem_wr_en;
   input        in_mem_en;
   input [1:0]  in_wr_sel;

   // TODO: writeEn needs to be low in the event of a stall.
   // TODO: mem_wr_en needs to be low in the event of a stall.
   register #(.N(1)) ofl_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_ofl), .dataOut(out_ofl), .err()));
   register #(.N(16)) alu_out_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_alu_out), .dataOut(out_alu_out), .err()));
   register #(.N(1)) zero_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_zero), .dataOut(out_zero), .err()));
   register #(.N(1)) PC_src_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_PC_src), .dataOut(out_PC_src), .err()));
   register #(.N(16)) sext_imm_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_sext_imm), .dataOut(out_sext_imm), .err()));
   register #(.N(16)) PC_sext_imm_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_PC_sext_imm), .dataOut(out_PC_sext_imm), .err()));
   register #(.N(16)) reg_sext_imm_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_reg_sext_imm), .dataOut(out_reg_sext_imm), .err()));
   register #(.N(1)) ltz_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_ltz), .dataOut(out_ltz), .err()));
   register #(.N(1)) lteq_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_lteq), .dataOut(out_lteq), .err()));
   register #(.N(2)) set_sel_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_set_sel), .dataOut(out_set_sel), .err()));
   register #(.N(1)) mem_wr_en_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_mem_wr_en), .dataOut(out_mem_wr_en), .err()));
   register #(.N(1)) mem_en_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_mem_en), .dataOut(out_mem_en), .err()));
   register #(.N(2)) wr_sel_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_wr_sel), .dataOut(out_wr_sel), .err()));

endmodule
