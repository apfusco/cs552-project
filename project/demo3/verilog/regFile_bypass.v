/*
   CS/ECE 552, Spring '20
   Homework #3, Problem #2
  
   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
module regFile_bypass (
                       // Outputs
                       read1Data, read2Data, err,
                       // Inputs
                       clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                       );
   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   /* YOUR CODE HERE */
    wire [15:0] no_bypass1;
    wire [15:0] no_bypass2;
    
    // instanstiate the register file
    regFile r1(
               // Outputs
               .read1Data(no_bypass1), .read2Data(no_bypass2), .err(err),
               // Inputs
               .clk(clk), .rst(rst), .read1RegSel(read1RegSel), .read2RegSel(read2RegSel), 
               .writeRegSel(writeRegSel), .writeData(writeData), .writeEn(writeEn)
               );

    // bypass logic
        // choose the writeData (i.e. RF bypass) if the register written to and read from 
        // are the same, and we actually want to do a write
    assign read1Data = (read1RegSel == writeRegSel) ? (writeEn ? writeData : no_bypass1) :
                                                    no_bypass1;
    assign read2Data = (read2RegSel == writeRegSel) ? (writeEn ? writeData : no_bypass2) :
                                                    no_bypass2;
endmodule
