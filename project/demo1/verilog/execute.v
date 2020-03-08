/*
   CS/ECE 552 Spring '20
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
module execute (oprnd_1,
                oprnd_2,
                alu_op,
                alu_invA,
                alu_invB,
                alu_sign,
                PC_inc,
                alu_out,
                zero,
                PC_src,
                PC_sext_imm,
                reg_sext_imm,
                err);

   // I/O
   input  [15:0] oprnd_1;
   input  [15:0] oprnd_2;
   input         alu_Cin;
   input  [2:0]  alu_op;
   input         alu_invA;
   input         alu_invB;
   input         alu_sign;
   input  [15:0] PC_inc;
   input  [1:0]  br_cnd_sel;
   output [15:0] alu_out;
   output        zero;
   output        PC_src;      // High for for using PC_inc + PC_sext_imm
   output [15:0] PC_sext_imm;
   output [15:0] reg_sext_imm;
   output        take_br;
   output        err;

   wire eq;
   wire neq;
   wire lt;
   wire gteq;

   // TODO: Needs to be updated for changed inputs.
   assign err = ({^{^oprnd_1, ^oprnd_2, ^alu_op, ^alu_invA, ^alu_invB,
                    ^alu_sign, ^PC_inc, ^alu_out}} == 1'bX) ? 1'b1 : 1'b0;

   // ALU logic
   alu alu(.InA(oprnd_1),
           .InB(oprnd_2),
           .Cin(alu_Cin),
           .Op(alu_op),
           .invA(alu_invA),
           .invB(alu_invB),
           .sign(alu_sign),
           .Out(alu_out),
           .Zero(zero),
           .Ofl(alu_ofl));

   // Branching logic
   assign eq = zero;
   assign neq = ~zero;
   assign lt = oprnd_1[15];
   assign gteq = zero | oprnd[15];
   mux4_1 mux4_1_take_br(.InA(eq), .InB(neq), .InC(lt), .InD(gteq), .S(br_cnd_sel), .Out(take_br));

   // PC logic
   assign PC_src = jmp_instr | (br_instr & take_br);
   assign PC_sext_imm = PC_inc + (oprnd_2 << 1'b1);// TODO: oprnd_2 should be sext_imm. Change addition logic.
   assign reg_sext_imm = PC_inc + oprnd_1;// TODO: Change addition logic.
   
endmodule
