module and2 (in1,in2,out);
   input in1,in2;
   output out;
   wire out_n;
   nand2 nand_out_n(in1, in2, out_n);
   not1 not_out(out_n, out);
endmodule
