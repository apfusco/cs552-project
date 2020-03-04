/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    a 4-bit CLA module
*/
module cla_4b(A, B, C_in, S, C_out);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    input [N-1: 0] A, B;
    input          C_in;
    output [N-1:0] S;
    output         C_out;

    wire [N-1: 0] G; // generate bits
    wire [N-1: 0] P; // propagate bits
    wire [N-2: 0] carryBits; // carrybits from CLA logic

    // YOUR CODE HERE

    // gen/prop bits
    generate_propagate_1b g0p0(.A(A[0]), .B(B[0]), .G(G[0]), .P(P[0]));
    generate_propagate_1b g1p1(.A(A[1]), .B(B[1]), .G(G[1]), .P(P[1]));
    generate_propagate_1b g2p2(.A(A[2]), .B(B[2]), .G(G[2]), .P(P[2]));
    generate_propagate_1b g3p3(.A(A[3]), .B(B[3]), .G(G[3]), .P(P[3]));

    // carry bits
    carry_bit_1b c1(.G(G[0]), .P(P[0]), .C_in(C_in), .C_out(carryBits[0]));
    carry_bit_1b c2(.G(G[1]), .P(P[1]), .C_in(carryBits[0]), .C_out(carryBits[1]));
    carry_bit_1b c3(.G(G[2]), .P(P[2]), .C_in(carryBits[1]), .C_out(carryBits[2]));
    carry_bit_1b c4(.G(G[3]), .P(P[3]), .C_in(carryBits[2]), .C_out(C_out));

    // adders
    fullAdder_1b adder0(.A(A[0]), .B(B[0]), .C_in(C_in), 
        .S(S[0]), .C_out());
    fullAdder_1b adder1(.A(A[1]), .B(B[1]), .C_in(carryBits[0]), 
        .S(S[1]), .C_out());
    fullAdder_1b adder2(.A(A[2]), .B(B[2]), .C_in(carryBits[1]), 
        .S(S[2]), .C_out());
    fullAdder_1b adder3(.A(A[3]), .B(B[3]), .C_in(carryBits[2]), 
        .S(S[3]), .C_out());

endmodule
