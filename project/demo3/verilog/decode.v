/*
   CS/ECE 552 Spring '20
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode (rd_data_1,
               rd_data_2,
               oprnd_2,
               sext_imm,
               br_cnd_sel,
               set_sel,
               has_Rt,
               out_wr_en,
               out_wr_reg,
               mem_wr_en,
               mem_en,
               wr_sel,
               jmp_reg_instr,
               jmp_instr,
               br_instr,
               alu_op,
               alu_invA,
               alu_invB,
               alu_Cin,
               alu_sign,
               halt,
               err,
               rd_reg_1,
               rd_reg_2,
               in_wr_en,
               in_wr_reg,
               wr_data,
               instr,
               clk,
               rst);

    output [15:0] rd_data_1;
    output [15:0] rd_data_2;
    output [15:0] oprnd_2;
    output [15:0] sext_imm;
    output [1:0] br_cnd_sel;
    output [1:0] set_sel;
    output has_Rt;
    output out_wr_en;
    output [2:0] out_wr_reg;
    output mem_wr_en;
    output mem_en;
    output [2:0] wr_sel;
    output jmp_reg_instr;
    output jmp_instr;
    output br_instr;
    output [2:0] alu_op;
    output alu_invA;
    output alu_invB;
    output alu_Cin;
    output alu_sign;
    output halt;
    output err;

    input [2:0] rd_reg_1;
    input [2:0] rd_reg_2;
    input in_wr_en;
    input [2:0] in_wr_reg;
    input [15:0] wr_data;
    input [15:0] instr;
    input clk;
    input rst;
    
    wire [1:0] sext_op;
    wire [1:0] wr_reg_sel;
    wire oprnd_sel;

    // Error signals
    wire reg_error;
    wire cntrl_error;
    wire input_error;
    wire sext_error;

    assign input_error = (^{rd_reg_1, rd_reg_2, in_wr_en, wr_data, instr, clk, rst} === 1'bX) ? 1'b1 : 1'b0;
    assign err = reg_error | cntrl_error | input_error | sext_error;

    // determine the dest register
    mux4_1 wr_reg_mux [2:0](.InA(instr[4:2]), .InB(instr[7:5]), .InC(instr[10:8]),
            .InD(3'h7), .S(wr_reg_sel), .Out(out_wr_reg));

    // register file
    regFile_bypass registers(.read1Data(rd_data_1),
                             .read2Data(rd_data_2),
                             .err(reg_error),
                             .clk(clk),
                             .rst(rst),
                             .read1RegSel(rd_reg_1),
                             .read2RegSel(rd_reg_2),
                             .writeRegSel(in_wr_reg),
                             .writeData(wr_data),
                             .writeEn(in_wr_en));
    
    // sign extension for immediates
    sext sign_extender(.instr(instr), .ext_op(sext_op), .imm(sext_imm), .err(sext_error));
    mux2_1 oprnd2_mux [15:0](.InA(rd_data_2), .InB(sext_imm), .S(oprnd_sel),
            .Out(oprnd_2));

   control cntrl(.instr(instr),
                 .br_cnd_sel(br_cnd_sel),
                 .set_sel(set_sel),
                 .wr_en(out_wr_en),
                 .has_Rt(has_Rt),
                 .mem_wr_en(mem_wr_en),
                 .mem_en(mem_en),
                 .wr_sel(wr_sel),
                 .wr_reg_sel(wr_reg_sel),
                 .oprnd_sel(oprnd_sel),
                 .jmp_reg_instr(jmp_reg_instr),
                 .jmp_instr(jmp_instr),
                 .br_instr(br_instr),
                 .sext_op(sext_op),
                 .alu_op(alu_op),
                 .alu_invA(alu_invA),
                 .alu_invB(alu_invB),
                 .alu_Cin(alu_Cin),
                 .alu_sign(alu_sign),
                 .halt(halt),
                 .err(cntrl_error));

endmodule
