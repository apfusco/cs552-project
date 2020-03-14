/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 2

    A 16-bit ALU module.  It is designed to choose
    the correct operation to perform on 2 16-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the 16-bit result
    of the operation, as well as output a Zero bit and an Overflow
    (OFL) bit.
*/
module alu (InA, InB, Cin, Op, invA, invB, sign, Out, Zero, Ofl, lt, lte, gt, gte);

   // declare constant for size of inputs, outputs (N),
   // and operations (O)
   parameter    N = 16;
   parameter    O = 3;
   
   input [N-1:0] InA;
   input [N-1:0] InB;
   input         Cin;
   input [O-1:0] Op;
   input         invA;
   input         invB;
   input         sign;
   output [N-1:0] Out;
   output         Ofl;
   output         Zero;
   output         lt;
   output         lte;
   output         gt;
   output         gte;

   wire [N-1:0] barrelOut;
   wire [N-1:0] adderSum;
   wire [N-1:0] andOut;
   wire [N-1:0] btrOut;
   wire [N-1:0] xorOut;
   wire [N-1:0] InA_n;
   wire [N-1:0] InB_n;
   wire [N-1:0] logic_out;

   wire [N-1:0] sel_A;
   wire [N-1:0] sel_B;
   wire sel_A_n;
   wire sel_B_n;
   wire adderSum_n;
   wire C_out;
   wire signed_ovfl;
   wire pos_ovfl;
   wire neg_ovfl;

   /* Opcodes:
   * 000 = rll = rotate left
   * 001 = sll = shift logical left
   * 010 = sra = shift right arithmetic
   * 011 = srl = shift right logical
   * 100 = ADD = A + B
   * 101 = AND = A & B
   * 110 = OR = reverse A
   * 111 = XOR = A ^ B
   */

   // 16 bit inverted A input
   not1 not1_InA_n[N-1:0](.in1(InA), .out(InA_n));

   // 16 bit inverted B input
   not1 not1_InB_n[N-1:0](.in1(InB), .out(InB_n));

   // select from inverted A/B
   mux2_1 mux_sel_A[N-1:0](.InA(InA), .InB(InA_n), .S(invA), .Out(sel_A));
   mux2_1 mux_sel_B[N-1:0](.InA(InB), .InB(InB_n), .S(invB), .Out(sel_B));

   // 16 bit barrel shifter
   shifter barrel(.In(sel_A), .Cnt(sel_B[3:0]), .Op(Op[1:0]), .Out(barrelOut));

   // 16 bit carry-lookahead adder (CLA)
   cla_16b adder(.A(sel_A), .B(sel_B), .C_in(Cin), .S(adderSum), .C_out(C_out));

   // 16 bit AND
   and2 and2_andOut[N-1:0](.in1(sel_A), .in2(sel_B), .out(andOut));

   // 16 bit BTR
   assign btrOut = {
      InA[0],
      InA[1],
      InA[2],
      InA[3],
      InA[4],
      InA[5],
      InA[6],
      InA[7],
      InA[8],
      InA[9],
      InA[10],
      InA[11],
      InA[12],
      InA[13],
      InA[14],
      InA[15]
      };

   // 16 bit XOR
   xor2 xor2_xorOut[N-1:0](.in1(sel_A), .in2(sel_B), .out(xorOut));

   // select from ADD, AND, OR, and XOR
   mux4_1 mux_logic[N-1:0](.InA(adderSum[N-1:0]), .InB(andOut[N-1:0]),
                           .InC(btrOut[N-1:0]), .InD(xorOut[N-1:0]), .S(Op[1:0]),
                           .Out(logic_out[N-1:0]));

   // select from logic and the barrel shifter
   mux2_1 mux_out[N-1:0](.InA(barrelOut), .InB(logic_out), .S({N{Op[2]}}), .Out(Out));

   // Overflow logic
   not1 not_sel_A_n(sel_A[N-1], sel_A_n);
   not1 not_sel_B_n(sel_B[N-1], sel_B_n);
   not1 not_sel_adderSum_n(adderSum[N-1], adderSum_n);
   nand3 nand_pos_ovfl(sel_A_n, sel_B_n, adderSum[N-1], pos_ovfl);
   nand3 nand_neg_ovfl(sel_A[N-1], sel_B[N-1], adderSum_n, neg_ovfl);
   nand2 nand_signed_ovfl(pos_ovfl, neg_ovfl, signed_ovfl);

   mux2_1 mux_Ofl(.InA(C_out), .InB(signed_ovfl), .S(sign), .Out(Ofl));

   // Zero logic
   // TODO: Ask if carry out should affect zero flag.
   assign Zero = !(|Out);
    
   // A < B
   assign lt = Out[15];

   // A <= B
   assign lte = (Out[15] || Zero);

   // A > B
   assign gt = !(Out[15] || Zero);

   // A >= B
   assign gte = !(Out[15]);

endmodule
