module carry_bit_1b(G, P, C_in, C_out);
    input G; //g_i
    input P; // p_i
    input C_in; // c_i
    output C_out; // c_i+1

    wire not1_g_out;
    wire nand2_P_Cin_out;

    // c_i+1 = [!g_i nand [p_i nand c_i]]
    nand2 nand2_P_Cin(.in1(P), .in2(C_in), .out(nand2_P_Cin_out));
    not1 not1_g(.in1(G), .out(not1_g_out));
    nand2 nand2_Cout(.in1(not1_g_out), .in2(nand2_P_Cin_out), .out(C_out));

endmodule
