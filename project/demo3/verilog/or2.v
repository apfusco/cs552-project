module or2 (in1,in2,out);
   input in1,in2;
   output out;
   wire out_n;
   nor2 nor_out_n(.in1(in1), .in2(in2), .out(out_n));
   not1 not_out(.in1(out_n), .out(out));
endmodule
