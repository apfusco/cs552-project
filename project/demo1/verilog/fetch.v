/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch (nxt_PC, PC_sext_imm, PC_src, instr, clk, rst, mem_en, mem_wr, dump);
    output [15:0] instr;
    input [15:0] nxt_PC; 
    input [15:0] PC_sext_imm; // PC + 2 + some immediate
    input PC_src; // control signal for which PC address to take
    input clk;
    input rst;
    input mem_en;
    input mem_wr;
    input dump;

    wire [15:0] PC_reg_out;
    wire [15:0] PC_inc; // PC + 2
    wire [15:0] two;

    assign two = 16'h0002;

    // TODO: add compatability with EPC and error ouput
    register #(.N(16)) pc_reg(.clk(clk), .rst(rst), .writeEn(),
            .dataIn(nxt_PC), .dataOut(PC_reg_out), .err());

    // PC + 2 since our ISA uses 16 bit instructions
        // TODO: we don't care about c_out or c_in I think...
    cla_16b pc_addr(.A(PC_reg_out), .B(two), .C_in(), .S(PC_inc), .C_out());

    // TODO: unsure of what data_in should tie with
    memory2c imem(.data_out(instr), .data_in(), .addr(nxt_PC), 
            .enable(mem_en), .wr(mem_wr), .createdump(dump), .clk(clk), 
            .rst(rst)); 

    mux2_1 pc_mux [15:0](.InA(PC_inc), .InB(PC_sext_imm), .S(PC_src), 
            .Out(nxt_PC));
    
endmodule
