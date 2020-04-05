/*
   CS/ECE 552 Spring '20
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
module memory (data_out, data_in, addr, en, mem_wr, mem_mem_fwd, fwd_data_in, createdump, clk, rst, err);

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
    output err;

    wire [15:0] data;

    assign err = (^{data_in, addr, en, mem_wr, mem_mem_fwd, fwd_data_in,
          createdump, clk, rst} === 1'bX) ? 1'b1 : 1'b0;

    mux2_1 mux2_1_data [15:0](.InA(data_in), .InB(fwd_data_in), .S(mem_mem_fwd), .Out(data));
    
   memory2c mem(.data_out(data_out), .data_in(data), .addr(addr), .enable(en), 
        .wr(mem_wr), .createdump(createdump), .clk(clk), .rst(rst));

endmodule
