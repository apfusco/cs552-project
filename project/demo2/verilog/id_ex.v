module id_ex(
        // outputs
        out_rd_data_1, 
        out_rd_data_2, 
        out_rd_reg_1,
        out_rd_reg_2,
        out_has_Rt,
        out_oprnd_2,
        out_sext_imm,
        out_br_cnd_sel,
        out_set_sel,
        out_mem_wr,
        out_mem_en,
        out_wr_en,
        out_wr_reg,
        out_wr_sel,
        out_jmp_reg_instr,
        out_jmp_instr,
        out_br_instr,
        out_alu_op,
        out_alu_invA,
        out_alu_invB,
        out_alu_Cin,
        out_alu_sign,
        out_stall_n,
        out_halt,
        err,
        // inputs
        clk,
        rst,
        in_rd_data_1,
        in_rd_data_2,
        in_rd_reg_1,
        in_rd_reg_2,
        in_has_Rt,
        in_oprnd_2,
        in_sext_imm,
        in_br_cnd_sel,
        in_set_sel,
        in_mem_wr,
        in_mem_en,
        in_wr_en,
        in_wr_reg,
        in_wr_sel,
        in_jmp_reg_instr,
        in_jmp_instr,
        in_br_instr,
        in_alu_op,
        in_alu_invA,
        in_alu_invB,
        in_alu_Cin,
        in_alu_sign,
        in_stall_n,
        take_new_PC,
        in_ex_fwd_Rs,
        in_ex_fwd_Rt,
        in_mem_fwd_Rs,
        in_mem_fwd_Rt,
        in_ex_Rs,
        in_ex_Rt,
        in_mem_Rs,
        in_mem_Rt,
        in_halt);

    output [15:0] out_rd_data_1;
    output [15:0] out_rd_data_2;
    output [2:0]  out_rd_reg_1;
    output [2:0]  out_rd_reg_2;
    output        out_has_Rt;
    output [15:0] out_oprnd_2;
    output [15:0] out_sext_imm;
    output [1:0]  out_br_cnd_sel;
    output [1:0]  out_set_sel;
    output        out_mem_wr;
    output        out_mem_en;
    output        out_wr_en;
    output [2:0]  out_wr_reg;
    output [2:0]  out_wr_sel;
    output        out_jmp_reg_instr;
    output        out_jmp_instr;
    output        out_br_instr;
    output [2:0]  out_alu_op;
    output        out_alu_invA;
    output        out_alu_invB;
    output        out_alu_Cin;
    output        out_alu_sign;
    output        out_stall_n;
    output        out_halt;
    output        err;

    input        clk;
    input        rst;
    input [15:0] in_rd_data_1;
    input [15:0] in_rd_data_2;
    input [2:0]  in_rd_reg_1;
    input [2:0]  in_rd_reg_2;
    input        in_has_Rt;
    input [15:0] in_oprnd_2;
    input [15:0] in_sext_imm;
    input [1:0]  in_br_cnd_sel;
    input [1:0]  in_set_sel;
    input        in_mem_wr;
    input        in_mem_en;
    input        in_wr_en;
    input [2:0]  in_wr_reg;
    input [2:0]  in_wr_sel;
    input        in_jmp_reg_instr;
    input        in_jmp_instr;
    input        in_br_instr;
    input [2:0]  in_alu_op;
    input        in_alu_invA;
    input        in_alu_invB;
    input        in_alu_Cin;
    input        in_alu_sign;
    input        in_stall_n; // low if stage should stall
    input        take_new_PC;
    input        in_ex_fwd_Rs; // fwd on Rs from ex
    input        in_ex_fwd_Rt; // fwd on Rt from ex
    input        in_mem_fwd_Rs; // fwd on Rs from mem
    input        in_mem_fwd_Rt; // fwd on Rt from mem
    // TODO: These inputs don't seem to do anything...?
    input [15:0] in_ex_Rs;
    input [15:0] in_ex_Rt;
    input [15:0] in_mem_Rs;
    input [15:0] in_mem_Rt;
    input        in_halt;

    wire stall_n;

    assign err = (^{clk,
                    rst,
                    in_rd_data_1,
                    in_rd_data_2,
                    in_rd_reg_1,
                    in_rd_reg_2,
                    in_has_Rt,
                    in_oprnd_2,
                    in_sext_imm,
                    in_br_cnd_sel,
                    in_set_sel,
                    in_mem_wr,
                    in_mem_en,
                    in_wr_en,
                    in_wr_reg,
                    in_wr_sel,
                    in_jmp_reg_instr,
                    in_jmp_instr,
                    in_br_instr,
                    in_alu_op,
                    in_alu_invA,
                    in_alu_invB,
                    in_alu_Cin,
                    in_alu_sign,
                    in_stall_n,
                    take_new_PC,
                    in_ex_fwd_Rs,
                    in_ex_fwd_Rt,
                    in_mem_fwd_Rs,
                    in_mem_fwd_Rt,
                    in_ex_Rs,
                    in_ex_Rt,
                    in_mem_Rs,
                    in_mem_Rt,
                    in_halt
                    } === 1'bX) ? 1'b1 : 1'b0;

    assign stall_n = (take_new_PC == 1'b0) ? in_stall_n : 1'b0;

    register #(.N(16)) rd_data_1_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_rd_data_1), .dataOut(out_rd_data_1), .err());
    register #(.N(16)) rd_data_2_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_rd_data_2), .dataOut(out_rd_data_2), .err());
    register #(.N(3)) rd_reg_1_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_rd_reg_1), .dataOut(out_rd_reg_1), .err());
    register #(.N(3)) rd_reg_2_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_rd_reg_2), .dataOut(out_rd_reg_2), .err());
    register #(.N(1)) has_Rt_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_has_Rt), .dataOut(out_has_Rt), .err());
    register #(.N(16)) oprnd_2_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_oprnd_2), .dataOut(out_oprnd_2), .err());
    register #(.N(16)) sext_imm_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_sext_imm), .dataOut(out_sext_imm), .err());
    register #(.N(2)) br_cnd_sel_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_br_cnd_sel), .dataOut(out_br_cnd_sel), .err());
    register #(.N(2)) set_sel_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_set_sel), .dataOut(out_set_sel), .err());
    register #(.N(1)) mem_wr_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_mem_wr), .dataOut(out_mem_wr), .err());
    register #(.N(1)) mem_en_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_mem_en), .dataOut(out_mem_en), .err());
    register #(.N(1)) wr_en_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_wr_en), .dataOut(out_wr_en), .err());
    register #(.N(3)) wr_reg_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_wr_reg), .dataOut(out_wr_reg), .err());
    register #(.N(3)) wr_sel_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_wr_sel), .dataOut(out_wr_sel), .err());
    register #(.N(1)) jmp_reg_instr_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_jmp_reg_instr), .dataOut(out_jmp_reg_instr), .err());
    register #(.N(1)) jmp_instr_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_jmp_instr), .dataOut(out_jmp_instr), .err());
    register #(.N(1)) br_instr_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_br_instr), .dataOut(out_br_instr), .err());
    register #(.N(3)) alu_op_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_alu_op), .dataOut(out_alu_op), .err());
    register #(.N(1)) alu_invA_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_alu_invA), .dataOut(out_alu_invA), .err());
    register #(.N(1)) alu_invB_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_alu_invB), .dataOut(out_alu_invB), .err());
    register #(.N(1)) alu_Cin_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_alu_Cin), .dataOut(out_alu_Cin), .err());
    register #(.N(1)) alu_sign_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_alu_sign), .dataOut(out_alu_sign), .err());
    register #(.N(1)) stall_n_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(stall_n), .dataOut(out_stall_n), .err());
    register #(.N(1)) halt_reg(.clk(clk), .rst(rst), .writeEn(stall_n), .dataIn(in_halt), .dataOut(out_halt), .err());

endmodule
