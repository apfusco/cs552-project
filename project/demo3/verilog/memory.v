/*
   CS/ECE 552 Spring '20
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
module memory (data_out, data_in, addr, en, mem_wr, mem_mem_fwd, fwd_data_in, createdump, clk, rst, stall, err);

    // memory signals
    output [15:0] data_out;
    input [15:0] data_in;
    input [15:0] addr;
    input en;
    input mem_wr;
    input mem_mem_fwd;
    input [15:0] fwd_data_in;
    input createdump;
    input clk;
    input rst;
    output stall;
    output err;

    wire        input_error;
    wire        mem_system_error;

    wire [15:0] data;
    wire        done;
    wire        cache_hit;

    assign input_error = 1'b0;
    //assign input_error = (^{data_in, addr, en, mem_wr, mem_mem_fwd, fwd_data_in,
    //      createdump, clk, rst} === 1'bX) ? 1'b1 : 1'b0;
    assign err = input_error | mem_system_error;

    mux2_1 mux2_1_data [15:0](.InA(data_in), .InB(fwd_data_in), .S(mem_mem_fwd), .Out(data));
    
    //memory2c mem(.data_out(data_out), .data_in(data), .addr(addr), .enable(en), 
    //    .wr(mem_wr), .createdump(createdump), .clk(clk), .rst(rst));
    mem_system #(.memtype(1)) dmem(.DataOut(data_out),
                    .Done(done),
                    .Stall(stall),
                    .CacheHit(cache_hit),
                    .err(mem_system_error),
                    .Addr(addr),
                    .DataIn(data),
                    .Rd(en & ~mem_wr),
                    .Wr(en & mem_wr),
                    .createdump(createdump),
                    .clk(clk),
                    .rst(rst));

endmodule
