module decoder3_8(Input, Output);

   input  [2:0] Input;
   output [7:0] Output;

   assign Output = { Input[2] &  Input[1] &  Input[0],
                     Input[2] &  Input[1] & ~Input[0],
                     Input[2] & ~Input[1] &  Input[0],
                     Input[2] & ~Input[1] & ~Input[0],
                    ~Input[2] &  Input[1] &  Input[0],
                    ~Input[2] &  Input[1] & ~Input[0],
                    ~Input[2] & ~Input[1] &  Input[0],
                    ~Input[2] & ~Input[1] & ~Input[0]};

endmodule
