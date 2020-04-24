/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch (instr, PC_inc, halt, err, clk, rst, new_PC, take_new_PC, stall, actual_halt);
    
    output [15:0] instr;
    output [15:0] PC_inc; // PC + 2
    output halt;
    output err;
    input clk;
    input rst;
    input [15:0] new_PC;
    input take_new_PC;
    input stall;
    input actual_halt;

    wire mem_en;
    wire [15:0] nxt_PC;
    wire [15:0] PC_reg_out;
    wire [15:0] PC_inc_wire; // PC + 2
    wire [15:0] two;
    wire [15:0] PC_mux_out;
    wire gnd;
    wire update_PC;
    wire halt_n;

    // NOP signals
    wire [15:0] nop_instr;
    wire nop_halt;
    assign instr = take_new_PC ? {5'b00001, nop_instr[10:0]} : nop_instr;
    assign halt = nop_halt & ~take_new_PC;

    assign halt_n = |instr[15:11]; // HALT is decoded in fetch for immediate feedback.
    assign nop_halt = ~halt_n;
    assign update_PC = (halt_n & ~stall) | take_new_PC;
    assign gnd = 1'b0;
    assign mem_en = 1'b1;
    assign two = 16'h0002;
    assign PC_inc = PC_inc_wire;

    assign err = (^{clk, rst, new_PC, take_new_PC, stall, actual_halt} === 1'bX) ? 1'b1 : 1'b0;

    // PC + 2 since our ISA uses 16 bit instructions
    cla_16b pc_addr(.A(PC_reg_out), .B(two), .C_in(1'b0), .S(PC_inc_wire), .C_out());

    // select between PC + 2, or a newly calculated PC
    mux2_1 mux2_1_nxt_PC [15:0](.InA(PC_inc_wire), .InB(new_PC), .S(take_new_PC), .Out(nxt_PC));

    // TODO: add compatability with EPC and error ouput
    register #(.N(16)) pc_reg(.clk(clk), .rst(rst), .writeEn(update_PC),
            .dataIn(nxt_PC), .dataOut(PC_reg_out), .err());
    
    memory2c imem(.data_out(nop_instr), .data_in(), .addr(PC_reg_out), 
            .enable(mem_en), .wr(gnd), .createdump(actual_halt), .clk(clk), 
            .rst(rst)); 

endmodule
