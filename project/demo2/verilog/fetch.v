/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch (instr, PC_inc, err, clk, rst, new_PC, take_new_PC, pc_en);
    
    output [15:0] instr;
    output [15:0] PC_inc; // PC + 2
    output err;
    input clk;
    input rst;
    input [15:0] new_PC;
    input take_new_PC;
    input pc_en;

    wire mem_en;
    wire [15:0] nxt_PC;
    wire [15:0] PC_reg_out;
    wire [15:0] PC_inc_wire; // PC + 2
    wire [15:0] two;
    wire [15:0] PC_mux_out;
    wire gnd;
    wire update_PC;
    wire halt_n;

    assign halt_n = |instr[15:11]; // HALT is decoded in fetch for immediate feedback.
    assign update_PC = halt_n; // TODO: Add logic to handle a stall.
    assign gnd = 1'b0;
    assign mem_en = 1'b1;
    assign two = 16'h0002;
    assign PC_inc = PC_inc_wire;

    assign err = (^{clk, rst, new_PC, take_new_PC, pc_en} === 1'bX) ? 1'b1 : 1'b0;

    // PC + 2 since our ISA uses 16 bit instructions
    cla_16b pc_addr(.A(PC_reg_out), .B(two), .C_in(1'b0), .S(PC_inc_wire), .C_out());

    // select between PC + 2, or a newly calculated PC
    mux2_1 mux2_1_nxt_PC [15:0](.InA(PC_inc_wire), .InB(new_PC), .S(take_new_PC), .Out(nxt_PC));

    // TODO: add compatability with EPC and error ouput
    register #(.N(16)) pc_reg(.clk(clk), .rst(rst), .writeEn(update_PC),
            .dataIn(nxt_PC), .dataOut(PC_reg_out), .err());
    
    memory2c imem(.data_out(instr), .data_in(), .addr(PC_reg_out), 
            .enable(mem_en), .wr(gnd), .createdump(~halt_n), .clk(clk), 
            .rst(rst)); 

endmodule
