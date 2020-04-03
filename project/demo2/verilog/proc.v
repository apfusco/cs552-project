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
   wire if_id_error;
   wire decode_error;
   wire id_ex_error;
   wire execute_error;
   wire ex_mem_error;
   wire memory_error;
   wire mem_wb_error;
   wire wb_error;

   // Fetch stage signals
   wire [15:0] if_PC_inc;
   wire [15:0] if_PC_sext_imm;
   wire [15:0] if_reg_sext_imm;
   wire        if_PC_src;
   wire        if_PC_en;
   wire [15:0] if_instr;
   // Decode stage signals
   wire [15:0] id_PC_inc;
   wire [15:0] id_PC_sext_imm;
   wire [15:0] id_reg_sext_imm;
   wire        id_PC_src;
   wire        id_PC_en;
   wire [15:0] id_sext_imm;
   wire [15:0] id_instr;
   // Execute stage signals
   wire [15:0] ex_PC_inc;
   wire [15:0] ex_PC_sext_imm;
   wire [15:0] ex_reg_sext_imm;
   wire        ex_PC_src;
   wire        ex_PC_en;
   wire [15:0] ex_rd_data_1;
   wire [15:0] ex_rd_data_2;
   wire [15:0] ex_oprnd_2;
   wire [15:0] ex_alu_out;
   wire [15:0] ex_sext_imm;
   wire [2:0]  ex_alu_op;
   wire [1:0]  ex_br_cnd_sel;
   wire [1:0]  ex_set_sel;
   wire        ex_alu_invA;
   wire        ex_alu_invB;
   wire        ex_alu_sign;
   wire        ex_alu_zero;
   wire        ex_alu_ofl;
   wire        ex_alu_ltz;
   wire        ex_alu_lteq;
   wire        ex_mem_en;
   wire        ex_mem_wr;
   wire [15:0] ex_wr_data;
   wire        ex_wr_en;
   wire [2:0]  ex_wr_sel;
   wire        ex_jmp_reg_instr;
   // Memory stage signals
   wire [15:0] mem_PC_inc;
   wire [15:0] mem_PC_sext_imm;
   wire [15:0] mem_reg_sext_imm;
   wire        mem_PC_src;
   wire        mem_PC_en;
   //wire [15:0] rd_data_1;
   //wire [15:0] rd_data_2;
   //wire [15:0] oprnd_2;
   wire [15:0] mem_alu_out;
   wire [15:0] mem_mem_out;
   wire [15:0] mem_sext_imm;
   wire [2:0]  mem_alu_op;
   wire        mem_set;
   wire [1:0]  mem_set_sel;
   wire        mem_alu_zero;
   wire        mem_alu_ofl;
   wire        mem_alu_ltz;
   wire        mem_alu_lteq;
   wire        mem_mem_en;
   wire        mem_mem_wr;
   wire [15:0] mem_wr_data;
   wire        mem_wr_en;
   wire [2:0]  mem_wr_sel;
   //wire        jmp_reg_instr;
   // Write back stage signals
   wire [15:0] wb_PC_inc;
   wire [15:0] wb_PC_sext_imm;
   wire [15:0] wb_reg_sext_imm;
   wire        wb_PC_src;
   wire        wb_PC_en;
   wire [15:0] wb_alu_out;
   wire [15:0] wb_mem_out;
   wire [15:0] wb_sext_imm;
   wire [2:0]  wb_alu_op;
   wire        wb_set;
   //wire        alu_zero;
   //wire        alu_ofl;
   //wire        alu_ltz;
   //wire        alu_lteq;
   wire        wb_mem_en;
   wire        wb_mem_wr;
   wire [15:0] wb_wr_data;
   wire        wb_wr_en;
   wire [2:0]  wb_wr_sel;
   //wire        jmp_reg_instr;

   // TODO: Add pipeline module error signals.
   assign err = fetch_error | decode_error | execute_error | memory_error | wb_error;

   fetch fetch0(.instr(if_instr),
                .PC_inc(if_PC_inc),
                .err(fetch_error),
                .PC_sext_imm(if_PC_sext_imm),
                .reg_sext_imm(if_reg_sext_imm),
                .clk(clk),
                .rst(rst),
                .take_br(if_PC_src),
                .pc_en(if_PC_en),
                .jmp_reg_instr(if_jmp_reg_instr));

   if_id if_id_pipe(.out_instr(id_instr),
                    .out_PC_inc(id_PC_inc),
                    .err(if_id_error),
                    .clk(clk),
                    .rst(rst),
                    .in_instr(if_instr),
                    .in_PC_inc(if_PC_inc));

   decode decode0(.rd_data_1(id_rd_data_1),
                  .rd_data_2(id_rd_data_2),
                  .oprnd_2(id_oprnd_2),
                  .sext_imm(id_sext_imm),
                  .br_cnd_sel(id_br_cnd_sel),
                  .set_sel(id_set_sel),
                  .mem_wr_en(id_mem_wr),
                  .mem_en(id_mem_en),
                  .wr_sel(id_wr_sel),
                  .jmp_reg_instr(id_jmp_reg_instr),
                  .jmp_instr(id_jmp_instr),
                  .br_instr(id_br_instr),
                  .alu_op(id_alu_op),
                  .alu_invA(id_alu_invA),
                  .alu_invB(id_alu_invB),
                  .alu_Cin(id_alu_Cin),
                  .alu_sign(id_alu_sign),
                  .pc_en(id_PC_en),
                  .err(decode_error),
                  .rd_reg_1(id_instr[10:8]),
                  .rd_reg_2(id_instr[7:5]),
                  .wr_en(id_wr_en),
                  .wr_data(id_wr_data),
                  .instr(id_instr),
                  .clk(clk),
                  .rst(rst));

   id_ex id_ex_pipe(.out_rd_data_1(ex_rd_data_1),
                    .out_rd_data_2(ex_rd_data_2), 
                    .out_oprnd_2(ex_oprnd_2),
                    .out_sext_imm(ex_sext_imm),
                    .out_br_cnd_sel(ex_br_cnd),
                    .out_set_sel(ex_set_sel),
                    .out_mem_wr_en(ex_mem_wr_en),
                    .out_mem_en(ex_mem_en),
                    .out_wr_sel(ex_wr_sel),
                    .out_jmp_reg_instr(ex_jmp_reg_instr),
                    .out_jmp_instr(ex_jmp_instr),
                    .out_br_instr(ex_br_instr),
                    .out_alu_op(ex_alu_op),
                    .out_alu_invA(ex_alu_invA),
                    .out_alu_invB(ex_alu_invB),
                    .out_alu_Cin(ex_alu_Cin),
                    .out_alu_sign(ex_alu_sign),
                    .out_pc_en(ex_PC_en),
                    .err(id_ex_error),
                    .clk(clk),
                    .rst(rst),
                    .in_rd_data_1(id_rd_data_1),
                    .in_rd_data_2(id_rd_data_2),
                    .in_oprnd_2(id_oprnd_2),
                    .in_sext_imm(id_sext_imm),
                    .in_br_cnd_sel(id_br_cnd_sel),
                    .in_set_sel(id_set_sel),
                    .in_mem_wr_en(id_mem_wr_en),
                    .in_mem_en(id_mem_en),
                    .in_wr_sel(id_wr_sel),
                    .in_jmp_reg_instr(id_jmp_reg_instr),
                    .in_jmp_instr(id_jmp_instr),
                    .in_br_instr(id_br_instr),
                    .in_alu_op(id_alu_op),
                    .in_alu_invA(id_alu_invA),
                    .in_alu_invB(id_alu_invB),
                    .in_alu_Cin(id_alu_Cin),
                    .in_alu_sign(id_alu_sign),
                    .in_pc_en(id_PC_en));

   execute execute0(.oprnd_1(ex_rd_data_1),
                    .oprnd_2(ex_oprnd_2),
                    .sext_imm(ex_sext_imm),
                    .alu_Cin(ex_alu_Cin),
                    .alu_op(ex_alu_op),
                    .alu_invA(ex_alu_invA),
                    .alu_invB(ex_alu_invB),
                    .alu_sign(ex_alu_sign),
                    .PC_inc(ex_PC_inc),
                    .br_cnd_sel(ex_br_cnd_sel),
                    .br_instr(ex_br_instr),
                    .jmp_instr(ex_jmp_instr),
                    .ofl(ex_alu_ofl),
                    .alu_out(ex_alu_out),
                    .zero(ex_alu_zero),
                    .PC_src(ex_PC_src),
                    .PC_sext_imm(ex_PC_sext_imm),
                    .reg_sext_imm(ex_reg_sext_imm),
                    .ltz(ex_alu_ltz),
                    .lteq(ex_alu_lteq),
                    .err(execute_error));

   // TODO: Needs sext_imm pipelined through
   ex_mem ex_mem_pipe(.out_ofl(mem_ofl),
                      .out_alu_out(mem_alu_out),
                      .out_zero(mem_zero),
                      .out_PC_src(mem_PC_src),
                      .out_PC_sext_imm(mem_PC_sext_imm),
                      .out_reg_sext_imm(mem_reg_sext_imm),
                      .out_ltz(mem_ltz),
                      .out_lteq(mem_lteq),
                      .out_set_sel(mem_set_sel),
                      .out_sext_imm(mem_sext_imm),
                      .out_mem_wr_en(mem_wr_en),
                      .out_mem_en(mem_en),
                      .out_wr_sel(mem_wr_sel),
                      .err(ex_mem_error),
                      .clk(clk),
                      .rst(rst),
                      .in_ofl(ex_ofl),
                      .in_alu_out(ex_alu_out),
                      .in_zero(ex_zero),
                      .in_PC_src(ex_PC_src),
                      .in_PC_sext_imm(ex_PC_sext_imm),
                      .in_reg_sext_imm(ex_reg_sext_imm),
                      .in_ltz(ex_ltz),
                      .in_lteq(ex_lteq),
                      .in_set_sel(ex_set_sel),
                      .in_sext_imm(ex_sext_imm),
                      .in_mem_wr_en(ex_mem_wr_en),
                      .in_mem_en(ex_mem_en),
                      .in_wr_sel(ex_wr_sel));

   memory memory0(.data_out(mem_mem_out),
                  .data_in(mem_rd_data_2),
                  .addr(mem_alu_out),
                  .en(mem_mem_en),
                  .mem_wr(mem_mem_wr),
                  .createdump(~mem_PC_en),
                  .clk(clk),
                  .rst(rst),
                  .set(mem_set),
                  .ofl(mem_alu_ofl),
                  .zero(mem_alu_zero),
                  .ltz(mem_alu_ltz),
                  .lteq(mem_alu_lteq),
                  .set_sel(mem_set_sel),
                  .err(memory_error));

   // TODO: Needs sext_imm
   mem_wb mem_wb_pipe(.out_wr_reg(wb_wr_reg),
                      .out_wr_en(wb_wr_en),
                      .out_wr_sel(wb_wr_sel),
                      .out_alu_out(wb_alu_out),
                      .out_mem_out(wb_mem_out),
                      .out_sext_imm(wb_sext_imm),
                      .out_PC_inc(wb_PC_inc),
                      .out_LBI(wb_LBI),
                      .out_SLBI(wb_SLBI),
                      .out_set(wb_set),
                      .err(mem_wb_error),
                      .clk(clk),
                      .rst(rst),
                      .in_wr_reg(mem_wr_reg),
                      .in_wr_en(mem_wr_en),
                      .in_wr_sel(mem_wr_sel),
                      .in_alu_out(mem_alu_out),
                      .in_mem_out(mem_mem_out),
                      .in_sext_imm(mem_sext_imm),
                      .in_PC_inc(mem_PC_inc),
                      .in_LBI(mem_LBI),
                      .in_SLBI(mem_SLBI),
                      .in_set(mem_set));

   wb wb0(.instr(wb_instr),
          .alu_out(wb_alu_out),
          .mem_out(wb_mem_out),
          .PC_inc(wb_PC_inc),
          .set(wb_set),
          .rd_data_1(wb_rd_data_1),
          .sext_imm(wb_sext_imm),
          .wr_sel(wb_wr_sel),
          .wr_data(wb_wr_data),
          .err(wb_error));

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
