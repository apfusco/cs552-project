/*
   CS/ECE 552 Spring '20
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
module memory (data_out, data_in, addr, en, wr, createdump, clk, rst, 
        br, p, eq, n, zero, alu_out_msb);

    // memory signals
    output [15:0] data_out;
    input [15:0] data_in;
    input [15:0] addr;
    input en;
    input mem_wr;
    input createdump;
    input clk;
    input rst;

    // branching logic signals
    output br;
    input p;
    input eq;
    input n;
    input zero; 
    input alu_out_msb;
    
   // TODO: Your code here
   memory2c mem(.data_out(data_out), .data_in(data_in), .addr(addr), .enable(en), 
        .wr(mem_wr), .createdump(createdump), .clk(clk), .rst(rst));
   
   // determines branching behavior based on result flags
   mux4_1 mux(.InA(p), .InB(eq), .InC(n), .InD(1'bx), .S({alu_out_msb, zero}), .Out(br));

endmodule
