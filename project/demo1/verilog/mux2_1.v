/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 1

    2-1 mux template
*/
module mux2_1 #(parameter N) (InA, InB, S, Out);
    input [N-1: 0] InA;
    input [N-1: 0] InB;
    input   S;
    output [N-1: 0] Out;

    wire S_n, A_s, B_s;

    not1 not_A(S, S_n);

    nand2 nand_A_s(InA, S_n, A_s),
          nand_B_s(InB, S, B_s),
          nand_Out(A_s, B_s, Out);

endmodule
