module register #(parameter N) (clk, rst, writeEn, dataIn, dataOut, err);

   input         clk;
   input         rst;
   input         writeEn;
   input [N-1:0] dataIn;

   output [N-1:0] dataOut;
   output         err;

   wire [N-1:0] d;
   wire [N-1:0] q;

   assign err = (^{dataIn, writeEn} === 1'bX) ? 1'b1 : 1'b0;

   mux2_1 mux[N-1:0](.InA(q), .InB(dataIn), .S(writeEn), .Out(d));
   dff flop[N-1:0](.q(q), .d(d), .clk(clk), .rst(rst));
   assign dataOut = q;

endmodule
