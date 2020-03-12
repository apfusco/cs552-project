module shifter_nb #(parameter SHFT) (In, Cnt, Op, Out);

   // declare constant for size of inputs, outputs (N) and # bits to shift (C)
   parameter   N = 16;
   parameter   O = 2;

   input [N-1:0]   In;
   input           Cnt;
   input [O-1:0]   Op;
   output [N-1:0]  Out;

   wire [N-1:0] In_n;     // In-n = ~In
   wire [SHFT-1:0] lsb;   // assign lsb = Op[0] & In[N - 1]
   wire [SHFT-1:0] msb;   // assign lsb = Op[0] & In[N - 1]
   wire [N-1:0] shftd;    // assign shifted = Op[1] ? left : right;
   wire [N-1:0] shftd_lft;// assign shifted = Op[1] ? left : right;
   wire [N-1:0] shftd_rgt;// assign shifted = Op[1] ? left : right;

   // Opcode | Operation
   // 00     | Rotate left
   // 01     | Shift left
   // 10     | Shift right arithmetic
   // 11     | Shift right logical

   not1 not_In_n[N-1:0](In, In_n);
   nor2 nor_lsb[SHFT-1:0]({(SHFT){Op[0]}}, In_n[N-1:N-SHFT], lsb);
   assign msb = {SHFT{~Op[0]}} & In[SHFT-1:0];

   assign shftd_lft = {In[N-1-SHFT:0], lsb};
   assign shftd_rgt = {msb, In[N-1:SHFT]};

   mux2_1 mux_shftd[N-1:0](.InA(shftd_lft), .InB(shftd_rgt), .S(Op[1]), .Out(shftd));
   mux2_1 mux_Out[N-1:0](.InA(In), .InB(shftd), .S(Cnt), .Out(Out));

endmodule
