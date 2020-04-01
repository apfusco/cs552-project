module mux8_1 (InA, InB, InC, InD, InE, InF, InG, InH, S, Out);
    // parameter N for length of inputs and outputs (to use with larger inputs/outputs)
    input           InA, InB, InC, InD, InE, InF, InG, InH;
    input [2:0]     S;
    output          Out;

    wire mux0_out, mux1_out;
    
    mux4_1 mux0(.InA(InA), .InB(InB), .InC(InC), .InD(InD), 
        .S(S[1:0]), .Out(mux0_out));
    mux4_1 mux1(.InA(InE), .InB(InF), .InC(InG), .InD(InH), 
        .S(S[1:0]), .Out(mux1_out));
    mux2_1 mux2(.InA(mux0_out), .InB(mux1_out), .S(S[2]), .Out(Out));
    
endmodule
