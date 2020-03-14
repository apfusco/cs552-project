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
               pc_en,
               err,
               rd_reg_1,
               rd_reg_2,
               wr_en,
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
    output pc_en;
    output err;

    input [2:0] rd_reg_1;
    input [2:0] rd_reg_2;
    input wr_en;
    input [15:0] wr_data;
    input [15:0] instr;
    input clk;
    input rst;
    
    wire [2:0] sext_op;
    wire [1:0] wr_reg_sel;
    wire oprnd_sel;
    wire [2:0] wr_reg;

    // Error signals
    wire reg_error;
    wire cntrl_error;
    wire input_error;

    assign input_error = (^{rd_reg_1, rd_reg_2, wr_en, wr_data, instr, clk, rst} === 1'bX) ? 1'b1 : 1'b0;
    assign err = reg_error | cntrl_error | input_error;

    // determine the dest register
    mux4_1 wr_reg_mux [2:0](.InA(instr[4:2]), .InB(instr[7:5]), .InC(instr[10:8]),
            .InD(3'h7), .S(wr_reg_sel), .Out(wr_reg));

    // register file
    regFile registers(.read1Data(rd_data_1), .read2Data(rd_data_2), .err(reg_error), 
            .clk(clk), .rst(rst), .read1RegSel(rd_reg_1), .read2RegSel(rd_reg_2), 
            .writeRegSel(wr_reg), .writeData(wr_data), .writeEn(wr_en));
    
    // sign extension for immediates
        // TODO: this won't work for ST instructions
    sext sign_extender(.instr(instr), .imm(sext_imm));
    mux2_1 oprnd2_mux [15:0](.InA(rd_data_2), .InB(sext_imm), .S(oprnd_sel),
            .Out(oprnd_2));

   control cntrl(.instr(instr),
                 .br_cnd_sel(br_cnd_sel),
                 .set_sel(set_sel),
                 .wr_en(wr_en),
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
                 .pc_en(pc_en),
                 .err(cntrl_error));

endmodule
