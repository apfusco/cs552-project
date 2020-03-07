/*
   CS/ECE 552 Spring '20
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
module memory (data_out, data_in, addr, en, wr, createdump, clk, rst);
    output [15:0] data_out;
    input [15:0] data_in;
    input [15:0] addr;
    input en;
    input wr;
    input createdump;
    input clk;
    input rst;
    
   // TODO: Your code here
   memory2c mem(.data_out(data_out), .data_in(data_in), .addr(addr), .enable(en), 
        .wr(wr), .createdump(createdump), .clk(clk), .rst(rst));
   

endmodule
