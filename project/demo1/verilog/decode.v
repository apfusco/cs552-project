/*
   CS/ECE 552 Spring '20
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode (rd_data_1, rd_data_2, oprnd_2, err, rd_reg_1, rd_reg_2,
         wr_en, wr_data, instr, wr_reg_sel, oprnd_sel, clk, rst);
    output [15:0] rd_data_1;
    output [15:0] rd_data_2;
    output [15:0] oprnd_2;
    output err;

    input [2:0] rd_reg_1;
    input [2:0] rd_reg_2;
    input wr_en;
    input [15:0] wr_data;
    input [15:0] instr;
    input wr_reg_sel;
    input oprnd_sel;
    input clk;
    input rst;
    
    wire [15:0] sext_imm;
    wire [2:0] wr_reg;

    // determine the dest register
    mux4_1 wr_reg_mux [2:0](.InA(instr[4:2], .InB(instr[7:5]), .InC(instr[10:8]),
            .InD(3'h7), .S(wr_reg_sel), .Out(wr_reg));

    // register file
    regFile registers(.read1Data(rd_data_1), .read2Data(rd_data_2), .err(err), 
            .clk(clk), .rst(rst), .read1RegSel(rd_reg_1), .read2RegSel(rd_reg_2), 
            .writeRegSel(wr_reg), .writeData(wr_data), .writeEn(wr_en));
    
    // sign extension for immediates
        // TODO: this won't work for ST instructions
    sext sign_extender(.instr(instr), .imm(sext_imm));
    mux2_1 oprnd2_mux [15:0](.InA(rd_data_2), .InB(sext_imm), .S(oprnd_sel),
            .Out(oprnd_2));

endmodule
