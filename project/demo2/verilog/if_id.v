module if_id(
        // outputs
        out_instr,
        out_PC_inc,
        out_halt,
        err,
        // inputs
        clk,
        rst,
        in_instr,
        in_stall_n,
        in_PC_inc,
        in_halt);

   output [15:0] out_instr;
   output [15:0] out_PC_inc;
   output        out_halt;
   output err;

   input        clk;
   input        rst;
   input [15:0] in_instr;
   input [15:0] in_PC_inc;
   input        in_stall_n; // active low
   input        in_halt;

   assign err = (^{clk, rst, in_instr, in_stall_n, in_PC_inc, in_halt} === 1'bX) ? 1'b1
         : 1'b0;

    // TODO: add writeEn signal once fowarding logic is implemented for stalls
   register #(.N(16)) instr_reg(.clk(clk), .rst(rst), .writeEn(in_stall_n), .dataIn(in_instr), .dataOut(out_instr), .err());
   register #(.N(16)) PC_inc_reg(.clk(clk), .rst(rst), .writeEn(in_stall_n), .dataIn(in_PC_inc), .dataOut(out_PC_inc), .err());
   register #(.N(1)) halt_reg(.clk(clk), .rst(rst), .writeEn(in_stall_n), .dataIn(in_halt), .dataOut(out_halt), .err());

endmodule
