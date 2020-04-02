module id_ex(
        // outputs
        out_rd_data_1, 
        out_rd_data_2, 
        out_oprnd_2,
        out_sext_imm,
        out_br_cnd_sel,
        out_set_sel,
        out_mem_wr_en,
        out_mem_en,
        out_wr_sel,
        out_jmp_reg_instr,
        out_jmp_instr,
        out_br_instr,
        out_alu_op,
        out_alu_invA,
        out_alu_invB,
        out_alu_Cin,
        out_alu_sign,
        out_pc_en,
        err,
        // inputs
        clk,
        rst,
        in_rd_data_1,
        in_rd_data_2,
        in_oprnd_2,
        in_sext_imm,
        in_br_cnd_sel,
        in_set_sel,
        in_mem_wr_en,
        in_mem_en,
        in_wr_sel,
        in_jmp_reg_instr,
        in_jmp_instr,
        in_br_instr,
        in_alu_op,
        in_alu_invA,
        in_alu_invB,
        in_alu_Cin,
        in_alu_sign,
        in_pc_en);

    output [15:0] out_rd_data_1;
    output [15:0] out_rd_data_2;
    output [15:0] out_oprnd_2;
    output [15:0] out_sext_imm;
    output [1:0]  out_br_cnd_sel;
    output [1:0]  out_set_sel;
    output        out_mem_wr_en;
    output        out_mem_en;
    output [2:0]  out_wr_sel;
    output        out_jmp_reg_instr;
    output        out_jmp_instr;
    output        out_br_instr;
    output [2:0]  out_alu_op;
    output        out_alu_invA;
    output        out_alu_invB;
    output        out_alu_Cin;
    output        out_alu_sign;
    output        out_pc_en;
    output        err;

    input        clk;
    input        rst;
    input [15:0] in_rd_data_1;
    input [15:0] in_rd_data_2;
    input [15:0] in_oprnd_2;
    input [15:0] in_sext_imm;
    input [1:0]  in_br_cnd_sel;
    input [1:0]  in_set_sel;
    input        in_mem_wr_en;
    input        in_mem_en;
    input [2:0]  in_wr_sel;
    input        in_jmp_reg_instr;
    input        in_jmp_instr;
    input        in_br_instr;
    input [2:0]  in_alu_op;
    input        in_alu_invA;
    input        in_alu_invB;
    input        in_alu_Cin;
    input        in_alu_sign;
    input        in_pc_en;


    register #(.N(16)) rd_data_1_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_rd_data_1), .dataOut(out_rd_data_1), .err());
    register #(.N(16)) rd_data_2_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_rd_data_2), .dataOut(out_rd_data_2), .err());
    register #(.N(16)) oprnd_2_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_oprnd_2), .dataOut(out_oprnd_2), .err());
    register #(.N(16)) sext_imm_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_sext_imm), .dataOut(out_sext_imm), .err());
    register #(.N(2)) br_cnd_sel_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_br_cnd_sel), .dataOut(out_br_cnd_sel), .err());
    register #(.N(2)) set_sel_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_set_sel), .dataOut(out_set_sel), .err());
    register #(.N(1)) mem_wr_en_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_mem_wr_en), .dataOut(out_mem_wr_en), .err());
    register #(.N(1)) mem_en_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_mem_en), .dataOut(out_mem_en), .err());
    register #(.N(3)) wr_sel_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_wr_sel), .dataOut(out_wr_sel), .err());
    register #(.N(1)) jmp_reg_instr_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_jmp_reg_instr), .dataOut(out_jmp_reg_instr), .err());
    register #(.N(1)) jmp_instr_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_jmp_instr), .dataOut(out_jmp_instr), .err());
    register #(.N(1)) br_instr_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_br_instr), .dataOut(out_br_instr), .err());
    register #(.N(3)) alu_op_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_alu_op), .dataOut(out_alu_op), .err());
    register #(.N(1)) alu_invA_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_alu_invA), .dataOut(out_alu_invA), .err());
    register #(.N(1)) alu_invB_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_alu_invB), .dataOut(out_alu_invB), .err());
    register #(.N(1)) alu_Cin_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_alu_Cin), .dataOut(out_alu_Cin), .err());
    register #(.N(1)) alu_sign_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_alu_sign), .dataOut(out_alu_sign), .err());
    register #(.N(1)) pc_en_reg(.clk(clk), .rst(rst), .writeEn(1'b1), .dataIn(in_pc_en), .dataOut(out_pc_en), .err());

endmodule
