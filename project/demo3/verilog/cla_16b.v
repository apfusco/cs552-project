/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    a 16-bit CLA module
*/
module cla_16b(A, B, C_in, S, C_out);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    input [N-1: 0] A, B;
    input          C_in;
    output [N-1:0] S;
    output         C_out;

    wire [2: 0] cla_out; // carry out bits from CLAs

    // YOUR CODE HERE
    cla_4b cla_0(.A(A[3:0]), .B(B[3:0]), .C_in(C_in), .S(S[3:0]), 
        .C_out(cla_out[0]));
    cla_4b cla_1(.A(A[7:4]), .B(B[7:4]), .C_in(cla_out[0]), .S(S[7:4]), 
        .C_out(cla_out[1]));
    cla_4b cla_2(.A(A[11:8]), .B(B[11:8]), .C_in(cla_out[1]), .S(S[11:8]), 
        .C_out(cla_out[2]));
    cla_4b cla_3(.A(A[15:12]), .B(B[15:12]), .C_in(cla_out[2]), .S(S[15:12]), 
        .C_out(C_out));
endmodule
