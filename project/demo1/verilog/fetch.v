/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch (instr, PC_sext_imm, reg_sext_imm, clk, rst,
        mem_wr, dump, take_br, pc_en, jmp_reg_instr);
    
    output [15:0] instr;
    input [15:0] PC_sext_imm; // PC + 2 + some immediate
    input [15:0] reg_sext_imm; // immediate from a register (ex. JR instruction)
    input clk;
    input rst;
    input mem_wr;
    input dump;
    input take_br;
    input pc_en;
    input jmp_reg_instr;

    wire mem_en;
    wire [15:0] nxt_PC;
    wire [15:0] PC_reg_out;
    wire [15:0] PC_inc; // PC + 2
    wire [15:0] two;
    wire [15:0] PC_mux_out;
    wire gnd;

    assign gnd = 1'b0;
    assign mem_en = 1'b1;
    assign two = 16'h0002;

    // PC + 2 since our ISA uses 16 bit instructions
    cla_16b pc_addr(.A(PC_reg_out), .B(two), .C_in(1'b0), .S(PC_inc), .C_out());

    // select between PC + 2, a sign-extended imm, or an imm from a reg
    // assign PC_sel = (br_instr & take_br) | jump_instr;
    mux2_1 PC_mux [15:0](.InA(PC_inc), .InB(PC_sext_imm), .S(take_br), 
            .Out(PC_mux_out));
    mux2_1 jump_reg_mux [15:0](.InA(PC_mux_out), .InB(reg_sext_imm),
            .S(jmp_reg_instr), .Out(nxt_PC));

    // TODO: add compatability with EPC and error ouput
    register #(.N(16)) pc_reg(.clk(clk), .rst(rst), .writeEn(pc_en),
            .dataIn(nxt_PC), .dataOut(PC_reg_out), .err());
    
    // TODO: unsure of what data_in should tie with
    memory2c imem(.data_out(instr), .data_in(), .addr(PC_reg_out), 
            .enable(mem_en), .wr(gnd), .createdump(dump), .clk(clk), 
            .rst(rst)); 
endmodule
