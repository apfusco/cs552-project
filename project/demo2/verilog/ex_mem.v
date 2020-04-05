module ex_mem(
        // outputs
        out_PC_inc,
        out_rd_data_1,
        out_rd_data_2,
        out_rd_reg_1,
        out_alu_ofl,
        out_alu_out,
        out_alu_zero,
        out_sext_imm, 
        out_alu_ltz,
        out_alu_lteq,
        out_set_sel,
        out_mem_wr,
        out_mem_en,
        out_wr_en,
        out_wr_reg,
        out_wr_sel,
        out_set,
        out_LBI,
        out_SLBI,
        out_halt,
        err,
        // inputs
        clk,
        rst,
        in_PC_inc,
        in_rd_data_1,
        in_rd_data_2,
        in_rd_reg_1,
        in_alu_ofl,
        in_alu_out,
        in_alu_zero,
        in_sext_imm,
        in_alu_ltz,
        in_alu_lteq,
        in_set_sel,
        in_mem_wr,
        in_mem_en,
        in_wr_en,
        in_wr_reg,
        in_wr_sel,
        in_set,
        in_LBI,
        in_SLBI,
        in_halt,
        take_new_PC);

   output [15:0] out_PC_inc;
   output [15:0] out_rd_data_1;
   output [15:0] out_rd_data_2;
   output [2:0] out_rd_reg_1;
   output        out_alu_ofl;
   output [15:0] out_alu_out;
   output        out_alu_zero;
   output [15:0] out_sext_imm;
   output        out_alu_ltz;
   output        out_alu_lteq;
   output [1:0]  out_set_sel;
   output        out_mem_wr;
   output        out_mem_en;
   output        out_wr_en;
   output [2:0]  out_wr_reg;
   output [2:0]  out_wr_sel;
   output        out_set;
   output [15:0] out_LBI;
   output [15:0] out_SLBI;
   output        out_halt;
   output        err;

   input        clk;
   input        rst;
   input [15:0] in_PC_inc;
   input [15:0] in_rd_data_1;
   input [15:0] in_rd_data_2;
   input [2:0]  in_rd_reg_1;
   input        in_alu_ofl;
   input [15:0] in_alu_out;
   input        in_alu_zero;
   input [15:0] in_sext_imm;
   input        in_alu_ltz;
   input        in_alu_lteq;
   input [1:0]  in_set_sel;
   input        in_mem_wr;
   input        in_mem_en;
   input        in_wr_en;
   input [2:0]  in_wr_reg;
   input [2:0]  in_wr_sel;
   input        in_set;
   input [15:0] in_LBI;
   input [15:0] in_SLBI;
   input        in_halt;
   input        take_new_PC; // arrives from execute, low if stall

   assign err = (^{clk,
                   rst,
                   in_PC_inc,
                   in_rd_data_1,
                   in_rd_data_2,
                   in_rd_reg_1,
                   in_alu_ofl,
                   in_alu_out,
                   in_alu_zero,
                   in_sext_imm,
                   in_alu_ltz,
                   in_alu_lteq,
                   in_set_sel,
                   in_mem_wr,
                   in_mem_en,
                   in_wr_en,
                   in_wr_reg,
                   in_wr_sel,
                   in_set,
                   in_LBI,
                   in_SLBI,
                   take_new_PC
                   } === 1'bX) ? 1'b1 : 1'b0;

   // TODO: writeEn needs to be low in the event of a stall.
   // TODO: mem_wr_en needs to be low in the event of a stall.
   register #(.N(16)) PC_inc_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_PC_inc), .dataOut(out_PC_inc), .err());
   register #(.N(16)) rd_data_1_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_rd_data_1), .dataOut(out_rd_data_1), .err());
   register #(.N(16)) rd_data_2_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_rd_data_2), .dataOut(out_rd_data_2), .err());
   register #(.N(3)) rd_reg_1_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_rd_reg_1), .dataOut(out_rd_reg_1), .err());
   register #(.N(1)) alu_ofl_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_alu_ofl), .dataOut(out_alu_ofl), .err());
   register #(.N(16)) alu_out_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_alu_out), .dataOut(out_alu_out), .err());
   register #(.N(1)) zero_alu_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_alu_zero), .dataOut(out_alu_zero), .err());
   register #(.N(16)) sext_imm_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_sext_imm), .dataOut(out_sext_imm), .err());
   register #(.N(1)) ltz_alu_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_alu_ltz), .dataOut(out_alu_ltz), .err());
   register #(.N(1)) lteq_alu_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_alu_lteq), .dataOut(out_alu_lteq), .err());
   register #(.N(2)) set_sel_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_set_sel), .dataOut(out_set_sel), .err());
   register #(.N(1)) mem_wr_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_mem_wr), .dataOut(out_mem_wr), .err());
   register #(.N(1)) mem_en_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_mem_en), .dataOut(out_mem_en), .err());
   register #(.N(1)) wr_en_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_wr_en), .dataOut(out_wr_en), .err());
   register #(.N(3)) wr_reg_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_wr_reg), .dataOut(out_wr_reg), .err());
   register #(.N(3)) wr_sel_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_wr_sel), .dataOut(out_wr_sel), .err());
   register #(.N(1)) set_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_set), .dataOut(out_set), .err());
   register #(.N(16)) LBI_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_LBI), .dataOut(out_LBI), .err());
   register #(.N(16)) SLBI_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_SLBI), .dataOut(out_SLBI), .err());
   register #(.N(1)) halt_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_halt), .dataOut(out_halt), .err());

endmodule
