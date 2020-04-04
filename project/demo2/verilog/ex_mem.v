module ex_mem(
        // outputs
        out_rd_data_1,
        out_rd_data_2,
        out_alu_ofl,
        out_alu_out,
        out_alu_zero,
        out_PC_src,
        out_sext_imm, 
        out_PC_sext_imm,
        out_reg_sext_imm,
        out_alu_ltz,
        out_alu_lteq,
        out_set_sel,
        out_mem_wr_en,
        out_mem_en,
        out_wr_reg,
        out_wr_sel,
        out_LBI,
        out_SLBI,
        out_stall_n,
        err,
        // inputs
        clk,
        rst,
        in_rd_data_1,
        in_rd_data_2,
        in_alu_ofl,
        in_alu_out,
        in_alu_zero,
        in_PC_src,
        in_sext_imm,
        in_PC_sext_imm,
        in_reg_sext_imm,
        in_alu_ltz,
        in_alu_lteq,
        in_set_sel,
        in_mem_wr_en,
        in_mem_en,
        in_wr_reg,
        in_wr_sel,
        in_LBI,
        in_SLBI,
        in_stall_n,
        in_take_new_PC);

   output [15:0] out_rd_data_1;
   output [15:0] out_rd_data_2;
   output        out_alu_ofl;
   output [15:0] out_alu_out;
   output        out_alu_zero;
   output        out_PC_src;      // High for for using PC_inc + PC_sext_imm
   output [15:0] out_sext_imm;
   output [15:0] out_PC_sext_imm;
   output [15:0] out_reg_sext_imm;
   output        out_alu_ltz;
   output        out_alu_lteq;
   output [1:0]  out_set_sel;
   output        out_mem_wr_en;
   output        out_mem_en;
   output [2:0]  out_wr_reg;
   output [2:0]  out_wr_sel;
   output [15:0] out_LBI;
   output [15:0] out_SLBI;
   output        out_stall_n; 
   output        err;

   input        clk;
   input        rst;
   input [15:0] in_rd_data_1;
   input [15:0] in_rd_data_2;
   input        in_alu_ofl;
   input [15:0] in_alu_out;
   input        in_alu_zero;
   input        in_PC_src;      // High for for using PC_inc + PC_sext_imm
   input [15:0] in_sext_imm;
   input [15:0] in_PC_sext_imm;
   input [15:0] in_reg_sext_imm;
   input        in_alu_ltz;
   input        in_alu_lteq;
   input [1:0]  in_set_sel;
   input        in_mem_wr_en;
   input        in_mem_en;
   input [2:0]  in_wr_reg;
   input [2:0]  in_wr_sel;
   input [15:0] in_LBI;
   input [15:0] in_SLBI;
   input        in_stall_n; // low if stage should stall
   input        take_new_PC; // arrives from execute, low if stall

   wire         stall_n;
   
   // control stall takes priority over the stall from previous stage
   assign stall_n = (take_new_PC == 1'b0) ? in_stall_n : 1'b0;

   // TODO: writeEn needs to be low in the event of a stall.
   // TODO: mem_wr_en needs to be low in the event of a stall.
   register #(.N(1)) alu_ofl_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_alu_ofl), .dataOut(out_alu_ofl), .err());
   register #(.N(16)) alu_out_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_alu_out), .dataOut(out_alu_out), .err());
   register #(.N(1)) zero_alu_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_alu_zero), .dataOut(out_alu_zero), .err());
   register #(.N(1)) PC_src_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_PC_src), .dataOut(out_PC_src), .err());
   register #(.N(16)) sext_imm_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_sext_imm), .dataOut(out_sext_imm), .err());
   register #(.N(16)) PC_sext_imm_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_PC_sext_imm), .dataOut(out_PC_sext_imm), .err());
   register #(.N(16)) reg_sext_imm_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_reg_sext_imm), .dataOut(out_reg_sext_imm), .err());
   register #(.N(1)) ltz_alu_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_alu_ltz), .dataOut(out_alu_ltz), .err());
   register #(.N(1)) lteq_alu_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_alu_lteq), .dataOut(out_alu_lteq), .err());
   register #(.N(2)) set_sel_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_set_sel), .dataOut(out_set_sel), .err());
   register #(.N(1)) mem_wr_en_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_mem_wr_en), .dataOut(out_mem_wr_en), .err());
   register #(.N(1)) mem_en_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_mem_en), .dataOut(out_mem_en), .err());
   register #(.N(3)) wr_reg_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_wr_reg), .dataOut(out_wr_reg), .err());
   register #(.N(3)) wr_sel_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_wr_sel), .dataOut(out_wr_sel), .err());
   register #(.N(16)) LBI_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_LBI), .dataOut(out_LBI), .err());
   register #(.N(16)) SLBI_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_SLBI), .dataOut(out_SLBI), .err());
   register #(.N(1)) stall_n_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(stall_n), .dataOut(out_stall_n), .err());

endmodule
