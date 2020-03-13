/*
   CS/ECE 552 Spring '20
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
module memory (data_out, data_in, addr, en, mem_wr, createdump, clk, rst,
               set, ofl, zero, ltz, lteq, set_sel);

    // memory signals
    output [15:0] data_out;
    input [15:0] data_in;
    input [15:0] addr;
    input en;
    input mem_wr;
    input createdump;
    input clk;
    input rst;

    // set logic signals
    output      set;
    input       ofl;
    input       zero;
    input       ltz;
    input       lteq;
    input [1:0] set_sel;
    
   // TODO: Your code here
   memory2c mem(.data_out(data_out), .data_in(data_in), .addr(addr), .enable(en), 
        .wr(mem_wr), .createdump(createdump), .clk(clk), .rst(rst));
   
   // determines branching behavior based on result flags
   mux4_1 mux(.InA(ofl), .InB(zero), .InC(ltz), .InD(lteq), .S(set_sel), .Out(set));

endmodule
