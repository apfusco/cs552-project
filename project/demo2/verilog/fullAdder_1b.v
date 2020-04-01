/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    a 1-bit full adder
*/
module fullAdder_1b(A, B, C_in, S, C_out);
    input  A, B;
    input  C_in;
    output S;
    output C_out;

    wire nand2_A_B_out, xor2_A_B_out, nand2_Cin_AxB_out;

    // YOUR CODE HERE
    // sum bit (S = A xor B xor Cin)
    xor3 xor3_sum(.in1(A), .in2(B), .in3(C_in), .out(S));

    // carry-out bit (Cout = [A nand B] nand [Cin nand [A xor B]])
    nand2 nand2_A_B(.in1(A), .in2(B), .out(nand2_A_B_out));
    xor2 xor2_A_B(.in1(A), .in2(B), .out(xor2_A_B_out));
    nand2 nand2_Cin_AxB(.in1(C_in), .in2(xor2_A_B_out), .out(nand2_Cin_AxB_out));
    nand2 nand2_Cout(.in1(nand2_A_B_out), .in2(nand2_Cin_AxB_out), .out(C_out));

endmodule
