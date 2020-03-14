/*
   CS/ECE 552 Spring '20
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
module execute (oprnd_1,
                oprnd_2,
                sext_imm,
                alu_Cin,
                alu_op,
                alu_invA,
                alu_invB,
                alu_sign,
                PC_inc,
                br_cnd_sel,
                br_instr,
                jmp_instr,
                ofl,
                alu_out,
                zero,
                PC_src,
                PC_sext_imm,
                reg_sext_imm,
                ltz,
                lteq,
                err);

   // I/O
   input  [15:0] oprnd_1;
   input  [15:0] oprnd_2;
   input  [15:0] sext_imm;
   input         alu_Cin;
   input  [2:0]  alu_op;
   input         alu_invA;
   input         alu_invB;
   input         alu_sign;
   input  [15:0] PC_inc;
   input  [1:0]  br_cnd_sel;
   input         br_instr;
   input         jmp_instr;
   input         ofl;
   output [15:0] alu_out;
   output        zero;
   output        PC_src;      // High for for using PC_inc + PC_sext_imm
   output [15:0] PC_sext_imm;
   output [15:0] reg_sext_imm;
   output        ltz;
   output        lteq;
   output        err;

   wire take_br;
   wire br_eq;
   wire br_neq;
   wire br_lt;
   wire br_gteq;

   assign err = (^{oprnd_1, oprnd_2, alu_Cin, alu_op, alu_invA, alu_invB, alu_sign,
         PC_inc, br_cnd_sel, br_instr, jmp_instr, ofl} === 1'bX) ? 1'b1 : 1'b0;

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
           .Ofl(ofl),
           .lt(ltz),
           .lte(lteq),
           .gt(),
           .gte());

   // Branching logic
   assign br_eq = zero;
   assign br_neq = ~zero;
   assign br_lt = oprnd_1[15];
   assign br_gteq = ~oprnd_1[15];
   mux4_1 mux4_1_take_br(.InA(br_eq), .InB(br_neq), .InC(br_lt), .InD(br_gteq), .S(br_cnd_sel), .Out(take_br));

   // PC logic
   assign PC_src = jmp_instr | (br_instr & take_br);
   assign PC_sext_imm = PC_inc + (sext_imm << 1'b1);// TODO: Change addition logic.
   assign reg_sext_imm = PC_inc + oprnd_1;// TODO: Change addition logic.
   
endmodule
