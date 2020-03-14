/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */

   // Error signals
   wire fetch_error;
   wire decode_error;
   wire execute_error;
   wire memory_error;
   wire wb_error;

   // PC values
   wire [15:0] PC;
   wire [15:0] PC_inc;
   wire [15:0] nxt_PC;
   wire [15:0] PC_sext_imm;
   wire [15:0] reg_sext_imm;
   wire PC_src;

   // Other signals
   wire [15:0] instr;
   wire [15:0] rd_data_1;
   wire [15:0] rd_data_2;
   wire [15:0] oprnd_2;
   wire [15:0] alu_out;
   wire [15:0] mem_out;
   wire [2:0]  alu_op;
   wire set;
   wire [1:0] set_sel;
   wire alu_invA;
   wire alu_invB;
   wire alu_sign;
   wire alu_zero;
   wire mem_en;
   wire mem_wr;
   wire [15:0] wr_data;
   wire wr_en;
   wire [2:0] wr_sel;

   fetch fetch_stage(.instr(instr),
                     .nxt_PC(nxt_PC),
                     .PC_sext_imm(PC_sext_imm),
                     .reg_sext_imm(),
                     .PC_src(PC_src),
                     .clk(clk),
                     .rst(rst),
                     .mem_en(mem_en),
                     .mem_wr(mem_wr),
                     .dump(/* TODO: ? */),
                     .br_instr(),
                     .take_br(PC_src),
                     .jump_instr(),
                     .jump_reg_instr());
   decode decode_stage(.rd_data_1(rd_data_1),
                       .rd_data_2(rd_data_2),
                       .oprnd_2(oprnd_2),
                       .br_cnd_sel(br_cnd_sel),
                       .set_sel(set_sel),
                       .mem_wr_en(mem_wr_en),
                       .mem_en(mem_en),
                       .wr_sel(wr_sel),
                       .jmp_reg_instr(jmp_reg_instr),
                       .jmp_instr(jmp_instr),
                       .br_instr(br_instr),
                       .sext_op(sext_op),
                       .alu_op(alu_op),
                       .alu_invA(alu_invA),
                       .alu_invB(alu_invB),
                       .alu_Cin(alu_Cin),
                       .alu_sign(alu_sign),
                       .pc_en(pc_en),
                       .err(decode_error),
                       .rd_reg_1(instr[10:8]),
                       .rd_reg_2(instr[7:5]),
                       .wr_en(wr_en),
                       .wr_data(wr_data),
                       .instr(instr),
                       .clk(clk),
                       .rst(rst));
   execute execute_stage(.oprnd_1(rd_data_1),
                         .oprnd_2(oprnd_2),
                         .alu_Cin(alu_Cin),
                         .alu_op(alu_op),
                         .alu_invA(alu_invA),
                         .alu_invB(alu_invB),
                         .alu_sign(alu_sign),
                         .PC_inc(PC_inc),
                         .br_cnd_sel(br_cnd_sel),
                         .alu_out(alu_out),
                         .zero(alu_zero),
                         .PC_src(PC_src),
                         .PC_sext_imm(PC_sext_imm),
                         .reg_sext_imm(reg_sext_imm),
                         .take_br(PC_src),
                         .err(execute_error));
   memory memory_stage(.data_out(mem_out),
                       .data_in(rd_data_2),
                       .addr(alu_out),
                       .en(mem_en),
                       .wr(mem_wr),
                       .createdump(),
                       .clk(clk),
                       .rst(rst),
                       .br(),
                       .p(),
                       .eq(),
                       .n(),
                       .zero(),
                       .alu_out_msb());
   wb wb_stage(.instr(instr),
               .alu_out(alu_out),
               .mem_out(mem_out),
               .PC_inc(PC_inc),
               .set(set),
               .rd_data_1(rd_data_1),
               .sext_imm(sext_imm),
               .wr_sel(wr_sel),
               .wr_data(wr_data));

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
