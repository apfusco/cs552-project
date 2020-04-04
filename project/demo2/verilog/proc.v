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

   // Important signal
   wire [15:0] new_PC;
   wire        take_new_PC;

   // Fetch stage signals
   wire [15:0] if_PC_inc;
   wire        if_halt;
   wire [15:0] if_instr;
   // Decode stage signals
   wire [15:0] id_PC_inc;
   wire        id_stall_n;
   wire        id_halt;
   wire [15:0] id_rd_data_1;
   wire [15:0] id_rd_data_2;
   wire [15:0] id_oprnd_2;
   wire [15:0] id_sext_imm;
   wire [2:0]  id_alu_op;
   wire [1:0]  id_br_cnd_sel;
   wire [1:0]  id_set_sel;
   wire [15:0] id_instr;
   wire [15:0] id_wr_data;
   wire        id_has_Rt;
   wire        id_wr_en;
   wire [2:0]  id_wr_reg;
   wire [2:0]  id_wr_sel;
   wire        id_jmp_reg_instr;
   // Execute stage signals
   wire [15:0] ex_PC_inc;
   wire        ex_halt;
   wire [15:0] ex_rd_data_1;
   wire [15:0] ex_rd_data_2;
   wire [2:0]  ex_rd_reg_1;
   wire [2:0]  ex_rd_reg_2;
   wire        ex_has_Rt;
   wire [15:0] ex_oprnd_2;
   wire [15:0] ex_alu_out;
   wire [15:0] ex_sext_imm;
   wire [2:0]  ex_alu_op;
   wire [1:0]  ex_br_cnd_sel;
   wire [1:0]  ex_set_sel;
   wire        ex_alu_invA;
   wire        ex_alu_invB;
   wire        ex_alu_sign;
   wire        ex_stall_n;
   wire        ex_alu_zero;
   wire        ex_alu_ofl;
   wire        ex_alu_ltz;
   wire        ex_alu_lteq;
   wire        ex_mem_en;
   wire        ex_mem_wr;
   wire        ex_wr_en;
   wire [2:0]  ex_wr_reg;
   wire [2:0]  ex_wr_sel;
   wire        ex_jmp_reg_instr;
   wire [15:0] ex_LBI;
   wire [15:0] ex_SLBI;
   // Memory stage signals
   wire [15:0] mem_PC_inc;
   wire        mem_halt;
   wire [15:0] mem_rd_data_1;
   wire [15:0] mem_rd_data_2;
   //wire [15:0] oprnd_2;
   wire [15:0] mem_alu_out;
   wire [15:0] mem_mem_out;
   wire [15:0] mem_sext_imm;
   wire [2:0]  mem_alu_op;
   wire        mem_set;
   wire        mem_alu_zero;
   wire        mem_alu_ofl;
   wire        mem_alu_ltz;
   wire        mem_alu_lteq;
   wire [1:0]  mem_set_sel;
   wire        mem_mem_en;
   wire        mem_mem_wr;
   wire [15:0] mem_wr_data;
   wire        mem_wr_en;
   wire [2:0]  mem_wr_reg;
   wire [2:0]  mem_wr_sel;
   wire        mem_stall_n;
   wire [15:0] mem_LBI;
   wire [15:0] mem_SLBI;
   //wire        jmp_reg_instr;
   // Write back stage signals
   wire [15:0] wb_PC_inc;
   wire        wb_halt;
   wire [15:0] wb_rd_data_1;
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
   wire [2:0]  wb_wr_reg;
   wire [2:0]  wb_wr_sel;
   wire [15:0] wb_LBI;
   wire [15:0] wb_SLBI;
   //wire        jmp_reg_instr;

   // forwarding signals
   wire        ex_fwd_Rs;
   wire        ex_fwd_Rt;
   wire        mem_fwd_Rs;
   wire        mem_fwd_Rt;
   wire [15:0] ex_Rs;
   wire [15:0] ex_Rt;
   wire [15:0] mem_Rs;
   wire [15:0] mem_Rt;

   // stall signals
   wire        stall;

   assign err = fetch_error   |
                if_id_error   |
                decode_error  |
                id_ex_error   |
                execute_error |
                ex_mem_error  |
                memory_error  |
                mem_wb_error  |
                wb_error;

   fetch fetch0(.instr(if_instr),
                .PC_inc(if_PC_inc),
                .err(fetch_error),
                .clk(clk),
                .rst(rst),
                .new_PC(new_PC),
                .take_new_PC(take_new_PC),
                .stall(stall));

   if_id if_id_pipe(.out_instr(id_instr),
                    .out_PC_inc(id_PC_inc),
                    .out_stall_n(id_stall_n),
                    .err(if_id_error),
                    .clk(clk),
                    .rst(rst),
                    .in_instr(if_instr),
                    .in_stall_n(~stall), // turns stall into an active low
                    .in_PC_inc(if_PC_inc));

   decode decode0(.rd_data_1(id_rd_data_1),
                  .rd_data_2(id_rd_data_2),
                  .oprnd_2(id_oprnd_2),
                  .sext_imm(id_sext_imm),
                  .br_cnd_sel(id_br_cnd_sel),
                  .set_sel(id_set_sel),
                  .has_Rt(id_has_Rt),
                  .out_wr_en(id_wr_en),
                  .out_wr_reg(id_wr_reg),
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
                  .halt(id_halt),
                  .err(decode_error),
                  .rd_reg_1(id_instr[10:8]),
                  .rd_reg_2(id_instr[7:5]),
                  .in_wr_en(wb_wr_en),
                  .in_wr_reg(wb_wr_reg),
                  .wr_data(wb_wr_data),
                  .instr(id_instr),
                  .clk(clk),
                  .rst(rst));

   id_ex id_ex_pipe(.out_PC_inc(ex_PC_inc),
                    .out_rd_data_1(ex_rd_data_1),
                    .out_rd_data_2(ex_rd_data_2), 
                    .out_rd_reg_1(ex_rd_reg_1),
                    .out_rd_reg_2(ex_rd_reg_2),
                    .out_has_Rt(ex_has_Rt),
                    .out_oprnd_2(ex_oprnd_2),
                    .out_sext_imm(ex_sext_imm),
                    .out_br_cnd_sel(ex_br_cnd_sel),
                    .out_set_sel(ex_set_sel),
                    .out_mem_wr(ex_mem_wr),
                    .out_mem_en(ex_mem_en),
                    .out_wr_en(ex_wr_en),
                    .out_wr_reg(ex_wr_reg),
                    .out_wr_sel(ex_wr_sel),
                    .out_jmp_reg_instr(ex_jmp_reg_instr),
                    .out_jmp_instr(ex_jmp_instr),
                    .out_br_instr(ex_br_instr),
                    .out_alu_op(ex_alu_op),
                    .out_alu_invA(ex_alu_invA),
                    .out_alu_invB(ex_alu_invB),
                    .out_alu_Cin(ex_alu_Cin),
                    .out_alu_sign(ex_alu_sign),
                    .out_stall_n(ex_stall_n),
                    .out_halt(ex_halt),
                    .err(id_ex_error),
                    .clk(clk),
                    .rst(rst),
                    .in_PC_inc(id_PC_inc),
                    .in_rd_data_1(id_rd_data_1),
                    .in_rd_data_2(id_rd_data_2),
                    .in_rd_reg_1(id_instr[10:8]), // TODO: handle when these are garbage (i.e. the instruction doesn't have an Rs or Rt)
                    .in_rd_reg_2(id_instr[7:5]), 
                    .in_has_Rt(id_has_Rt),
                    .in_oprnd_2(id_oprnd_2),
                    .in_sext_imm(id_sext_imm),
                    .in_br_cnd_sel(id_br_cnd_sel),
                    .in_set_sel(id_set_sel),
                    .in_mem_wr(id_mem_wr),
                    .in_mem_en(id_mem_en),
                    .in_wr_en(id_wr_en),
                    .in_wr_reg(id_wr_reg), // TODO: same as above note for Rd
                    .in_wr_sel(id_wr_sel),
                    .in_jmp_reg_instr(id_jmp_reg_instr),
                    .in_jmp_instr(id_jmp_instr),
                    .in_br_instr(id_br_instr),
                    .in_alu_op(id_alu_op),
                    .in_alu_invA(id_alu_invA),
                    .in_alu_invB(id_alu_invB),
                    .in_alu_Cin(id_alu_Cin),
                    .in_alu_sign(id_alu_sign),
                    .in_stall_n(id_stall_n), 
                    .take_new_PC(take_new_PC),
                    .in_ex_fwd_Rs(ex_fwd_Rs),
                    .in_ex_fwd_Rt(ex_fwd_Rt),
                    .in_mem_fwd_Rs(mem_fwd_Rs),
                    .in_mem_fwd_Rt(mem_fwd_Rt),
                    .in_ex_Rs(ex_Rs),
                    .in_ex_Rt(ex_Rt),
                    .in_mem_Rs(mem_Rs),
                    .in_mem_Rt(mem_Rt),
                    .in_halt(id_halt));

   execute execute0(.oprnd_1(ex_rd_data_1),
                    .oprnd_2(ex_oprnd_2),
                    .sext_imm(ex_sext_imm),
                    .alu_Cin(ex_alu_Cin),
                    .alu_op(ex_alu_op),
                    .alu_invA(ex_alu_invA),
                    .alu_invB(ex_alu_invB),
                    .alu_sign(ex_alu_sign),
                    .set_sel(ex_set_sel),
                    .PC_inc(ex_PC_inc),
                    .br_cnd_sel(ex_br_cnd_sel),
                    .br_instr(ex_br_instr),
                    .jmp_instr(ex_jmp_instr),
                    .jmp_reg_instr(ex_jmp_reg_instr),
                    .ex_fwd_Rs(ex_fwd_Rs),
                    .ex_fwd_Rt(ex_fwd_Rt),
                    .mem_fwd_Rs(mem_fwd_Rs),
                    .mem_fwd_Rt(mem_fwd_Rt),
                    .ex_Rs_val(ex_Rs),
                    .ex_Rt_val(ex_Rt),
                    .mem_Rs_val(mem_Rs),
                    .mem_Rt_val(mem_Rt),
                    .ofl(ex_alu_ofl),
                    .alu_out(ex_alu_out),
                    .zero(ex_alu_zero),
                    .ltz(ex_alu_ltz),
                    .lteq(ex_alu_lteq),
                    .take_new_PC(take_new_PC),
                    .new_PC(new_PC),
                    .set(ex_set),
                    .LBI(ex_LBI),
                    .SLBI(ex_SLBI),
                    .err(execute_error));

   ex_mem ex_mem_pipe(.out_rd_data_1(mem_rd_data_1),
                      .out_rd_data_2(mem_rd_data_2),
                      .out_alu_ofl(mem_alu_ofl),
                      .out_alu_out(mem_alu_out),
                      .out_alu_zero(mem_alu_zero),
                      .out_sext_imm(mem_sext_imm),
                      .out_alu_ltz(mem_alu_ltz),
                      .out_alu_lteq(mem_alu_lteq),
                      .out_set_sel(mem_set_sel),
                      .out_mem_wr(mem_mem_wr),
                      .out_mem_en(mem_mem_en),
                      .out_wr_en(mem_wr_en),
                      .out_wr_reg(mem_wr_reg), 
                      .out_wr_sel(mem_wr_sel),
                      .out_set(mem_set),
                      .out_LBI(mem_LBI),
                      .out_SLBI(mem_SLBI),
                      .out_stall_n(mem_stall_n),
                      .out_halt(mem_halt),
                      .err(ex_mem_error),
                      .clk(clk),
                      .rst(rst),
                      .in_rd_data_1(ex_rd_data_1),
                      .in_rd_data_2(ex_rd_data_2),
                      .in_alu_ofl(ex_alu_ofl),
                      .in_alu_out(ex_alu_out),
                      .in_alu_zero(ex_alu_zero),
                      .in_alu_ltz(ex_alu_ltz),
                      .in_alu_lteq(ex_alu_lteq),
                      .in_set_sel(ex_set_sel),
                      .in_sext_imm(ex_sext_imm),
                      .in_mem_wr(ex_mem_wr),
                      .in_mem_en(ex_mem_en),
                      .in_wr_en(ex_wr_en),
                      .in_wr_reg(ex_wr_reg), 
                      .in_wr_sel(ex_wr_sel),
                      .in_set(ex_set),
                      .in_LBI(ex_LBI),
                      .in_SLBI(ex_SLBI),
                      .in_stall_n(ex_stall_n), 
                      .in_halt(ex_halt),
                      .take_new_PC(take_new_PC));

   memory memory0(.data_out(mem_mem_out),
                  .data_in(mem_rd_data_2),// FIXME: Currenty high Z
                  .addr(mem_alu_out),
                  .en(mem_mem_en),
                  .mem_wr(mem_mem_wr),
                  .createdump(mem_halt),
                  .clk(clk),
                  .rst(rst),
                  .err(memory_error));

   mem_wb mem_wb_pipe(.out_wr_reg(wb_wr_reg),
                      .out_wr_en(wb_wr_en),
                      .out_wr_sel(wb_wr_sel),
                      .out_alu_out(wb_alu_out),
                      .out_mem_out(wb_mem_out),
                      .out_sext_imm(wb_sext_imm),
                      .out_PC_inc(wb_PC_inc),
                      .out_set(wb_set),
                      .out_LBI(wb_LBI),
                      .out_SLBI(wb_SLBI),
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
                      .in_set(mem_set),
                      .in_LBI(mem_LBI),
                      .in_SLBI(mem_SLBI),
                      .in_stall_n(mem_stall_n));

   wb wb0(.alu_out(wb_alu_out),
          .mem_out(wb_mem_out),
          .PC_inc(wb_PC_inc),
          .set(wb_set),
          .rd_data_1(wb_rd_data_1),
          .sext_imm(wb_sext_imm),
          .wr_sel(wb_wr_sel),
          .LBI(wb_LBI),
          .SLBI(wb_SLBI),
          .wr_data(wb_wr_data),
          .err(wb_error));


   forward forward0(.ex_fwd_Rs(ex_fwd_Rs),
                    .ex_fwd_Rt(ex_fwd_Rt),
                    .mem_fwd_Rs(mem_fwd_Rs),
                    .mem_fwd_Rt(mem_fwd_Rt),
                    .ex_Rs(ex_Rs),
                    .ex_Rt(ex_Rt),
                    .mem_Rs(mem_Rs),
                    .mem_Rt(mem_Rt),
                    .mem_wr_en(mem_wr_en), // reg write signal from ex/mem
                    .ex_mem_Rd(mem_wr_reg),
                    .id_ex_has_Rt(ex_has_Rt),
                    .id_ex_Rs(ex_rd_reg_1),
                    .id_ex_Rt(ex_rd_reg_2),
                    .wb_wr_en(wb_wr_en),
                    .mem_wb_Rd(wb_wr_reg),
                    .ex_mem_alu_result(mem_alu_out),
                    .ex_mem_set_result({15'h0000, mem_set}),
                    .ex_mem_lbi_result(mem_LBI),
                    .ex_mem_slbi_result(mem_SLBI),
                    .ex_mem_wr_sel(mem_wr_sel),
                    .mem_wb_alu_result(wb_alu_out),
                    .mem_wb_mem_result(wb_mem_out),
                    .mem_wb_set_result({15'h0000, wb_set}),
                    .mem_wb_lbi_result(wb_LBI),
                    .mem_wb_slbi_result(wb_SLBI),
                    .mem_wb_wr_sel(wb_wr_sel));

   stall stall0(.id_ex_stall(stall),
                .id_ex_mem_wr(ex_mem_wr), 
                .id_ex_Rd(ex_wr_reg),
                .if_id_Rs(id_instr[10:8]), // TODO: only check if Rs/Rt are present?
                .if_id_Rt(id_instr[7:5]));

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
