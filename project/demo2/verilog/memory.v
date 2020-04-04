/*
   CS/ECE 552 Spring '20
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
module memory (data_out, data_in, addr, en, mem_wr, createdump, clk, rst, err);

    // memory signals
    output [15:0] data_out;
    input [15:0] data_in;
    input [15:0] addr;
    input en;
    input mem_wr;
    input createdump;
    input clk;
    input rst;
    output err;

    assign err = (^{data_in, addr, en, mem_wr, createdump, clk, rst} === 1'bX) ? 1'b1 : 1'b0;
    
   memory2c mem(.data_out(data_out), .data_in(data_in), .addr(addr), .enable(en), 
        .wr(mem_wr), .createdump(createdump), .clk(clk), .rst(rst));

endmodule
