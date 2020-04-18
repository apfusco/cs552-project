module generate_propagate_1b(A, B, G, P);
    input A, B;
    output G;
    output P;

    wire nand2_out;
    wire nor2_out;

    // generate bit (g = ![a nand b])
    nand2 not_g(.in1(A), .in2(B), .out(nand2_out));
    not1 gen_bit(.in1(nand2_out), .out(G));
    
    // propagate bit (g = ![a nor b])
    nor2 not_p(.in1(A), .in2(B), .out(nor2_out));
    not1 prop_bit(.in1(nor2_out), .out(P));

endmodule
