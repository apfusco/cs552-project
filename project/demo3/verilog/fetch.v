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

    wire mem_system_error;
    wire input_error;

    wire        took_new_PC;
    wire [15:0] nxt_PC;
    wire [15:0] PC_reg_out;
    wire [15:0] PC_inc_wire; // PC + 2
    wire [15:0] two;
    wire [15:0] PC_mux_out;
    wire update_PC;
    wire halt_n;

    wire done;
    wire cache_stall;
    wire cache_hit;

    // NOP signals
    wire [15:0] nop_instr;
    wire nop_halt;

    assign instr = (take_new_PC | cache_stall | took_new_PC) ? {5'b00001, nop_instr[10:0]} : nop_instr;
    assign halt = nop_halt;

    assign halt_n = |instr[15:11] | ~done | take_new_PC | took_new_PC; // HALT is decoded in fetch for immediate feedback.
    assign nop_halt = ~halt_n;
    // TODO: Handle the case when take_new_PC is asserted during a cache stall
    assign update_PC = ((halt_n & ~stall & done) | take_new_PC) & ~took_new_PC;
    assign two = 16'h0002;
    assign PC_inc = PC_inc_wire;

    assign input_error = (^{clk,
                            rst,
                            new_PC,
                            take_new_PC,
                            stall,
                            actual_halt} === 1'bX) ? 1'b1 : 1'b0;

    assign err = input_error | mem_system_error;

    // PC + 2 since our ISA uses 16 bit instructions
    cla_16b pc_addr(.A(PC_reg_out), .B(two), .C_in(1'b0), .S(PC_inc_wire), .C_out());

    // select between PC + 2, or a newly calculated PC
    mux2_1 mux2_1_nxt_PC [15:0](.InA(PC_inc_wire), .InB(new_PC), .S(take_new_PC), .Out(nxt_PC));

    // TODO: add compatability with EPC and error ouput
    register #(.N(16)) pc_reg(.clk(clk), .rst(rst), .writeEn(update_PC),
            .dataIn(nxt_PC), .dataOut(PC_reg_out), .err());

    register #(.N(1)) took_new_PC_reg(.clk(clk), .rst(rst), .writeEn(take_new_PC | done),
            .dataIn(take_new_PC & cache_stall), .dataOut(took_new_PC), .err());

    //memory2c imem(.data_out(nop_instr), .data_in(), .addr(PC_reg_out),
    //        .enable(1'b1), .wr(1'b0), .createdump(actual_halt), .clk(clk),
    //        .rst(rst));

    mem_system imem(.DataOut(nop_instr),
                    .Done(done),
                    .Stall(cache_stall),
                    .CacheHit(cache_hit),
                    .err(mem_system_error),
                    .Addr((~done & ~cache_stall & ~take_new_PC) | took_new_PC | stall ? PC_reg_out : nxt_PC),
                    .DataIn(16'h0000),
                    .Rd(halt_n),
                    .Wr(1'b0),
                    .createdump(actual_halt),
                    .clk(clk),
                    .rst(rst));

endmodule
