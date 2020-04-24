/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 1
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the Op() value that is passed in (2 bit number).  It uses these
    shifts to shift the value any number of bits between 0 and 15 bits.
 */
module shifter (In, Cnt, Op, Out);

   // declare constant for size of inputs, outputs (N) and # bits to shift (C)
   parameter   N = 16;
   parameter   C = 4;
   parameter   O = 2;

   input [N-1:0]   In;
   input [C-1:0]   Cnt;
   input [O-1:0]   Op;
   output [N-1:0]  Out;

   wire [N-1:0]    shftd_1b, shftd_2b, shftd_4b;

   // Opcode | Operation
   // 00     | Rotate left
   // 01     | Shift left
   // 10     | Shift right arithmetic
   // 11     | Shift right logical

   // Combination of an 8-bit, 4-bit, 2-bit, and 1-bit shifter.
   shifter_nb #(.SHFT(1)) shifter_1b(.In(In), .Cnt(Cnt[0]), .Op(Op), .Out(shftd_1b));
   shifter_nb #(.SHFT(2)) shifter_2b(.In(shftd_1b), .Cnt(Cnt[1]), .Op(Op), .Out(shftd_2b));
   shifter_nb #(.SHFT(4)) shifter_4b(.In(shftd_2b), .Cnt(Cnt[2]), .Op(Op), .Out(shftd_4b));
   shifter_nb #(.SHFT(8)) shifter_8b(.In(shftd_4b), .Cnt(Cnt[3]), .Op(Op), .Out(Out));
   
endmodule
