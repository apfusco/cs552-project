/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 1

    2-1 mux template
*/
module mux2_1(InA, InB, S, Out);
    input   InA, InB;
    input   S;
    output  Out;

    wire S_n, A_s, B_s;

    not1 not_A(S, S_n);

    nand2 nand_A_s(InA, S_n, A_s),
          nand_B_s(InB, S, B_s),
          nand_Out(A_s, B_s, Out);

endmodule
