/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 1

    4-1 mux template
*/
module mux4_1(InA, InB, InC, InD, S, Out);
    input        InA, InB, InC, InD;
    input [1:0]  S;
    output       Out;

    wire         AB_s, CD_s;

    mux2_1 mux_AB_s(.InA(InA), .InB(InB), .S(S[0]), .Out(AB_s)),
           mux_CD_s(.InA(InC), .InB(InD), .S(S[0]), .Out(CD_s)),
	       mux_Out(.InA(AB_s), .InB(CD_s), .S(S[1]), .Out(Out));

endmodule
