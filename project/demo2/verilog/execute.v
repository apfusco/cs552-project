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
                set_sel,
                PC_inc,
                br_cnd_sel,
                br_instr,
                jmp_instr,
                jmp_reg_instr,
                ex_fwd_Rs,
                ex_fwd_Rt,
                mem_fwd_Rs,
                mem_fwd_Rt,
                ex_Rs_val,
                ex_Rt_val,
                mem_Rs_val,
                mem_Rt_val,
                ofl,
                alu_out,
                zero,
                PC_sext_imm,
                reg_sext_imm,
                ltz,
                lteq,
                take_new_PC,
                new_PC,
                set,
                LBI,
                SLBI,
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
   input  [1:0]  set_sel;
   input  [15:0] PC_inc;
   input  [1:0]  br_cnd_sel;
   input         br_instr;
   input         jmp_instr;
   input         jmp_reg_instr;
   input         ex_fwd_Rs;
   input         ex_fwd_Rt;
   input         mem_fwd_Rs;
   input         mem_fwd_Rt;
   input [15:0]  ex_Rs_val;
   input [15:0]  ex_Rt_val;
   input [15:0]  mem_Rs_val;
   input [15:0]  mem_Rt_val;

   output        ofl;
   output [15:0] alu_out;
   output        zero;
   output [15:0] PC_sext_imm;
   output [15:0] reg_sext_imm;
   output        ltz;
   output        lteq;
   output        take_new_PC;
   output [15:0] new_PC;
   output        set;
   output [15:0] LBI;
   output [15:0] SLBI;
   output        err;

   wire take_br;
   wire br_eq;
   wire br_neq;
   wire br_lt;
   wire br_gteq;

   wire [15:0] fwd_op_1;
   wire [15:0] fwd_op_2;

   assign fwd_op_1 = (ex_fwd_Rs == 1'b1) ? ex_Rs_val :
                        (mem_fwd_Rs == 1'b1) ? mem_Rs_val :
                        oprnd_1;
   assign fwd_op_2 = (ex_fwd_Rt == 1'b1) ? ex_Rt_val :
                        (mem_fwd_Rt == 1'b1) ? mem_Rt_val :
                        oprnd_2;

   assign err = (^{oprnd_1, oprnd_2, alu_Cin, alu_op, alu_invA, alu_invB,
         alu_sign, fwd_op_1, fwd_op_2, PC_inc, br_cnd_sel, br_instr, 
         jmp_instr, jmp_reg_instr} === 1'bX) ?
         1'b1 : 1'b0;

   // (S)LBI logic
   assign LBI = sext_imm;
   assign SLBI = {oprnd_1[7:0], sext_imm[7:0]};

   // ALU logic
   alu alu(.InA(fwd_op_1),
           .InB(fwd_op_2),
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
   assign br_lt = fwd_op_1[15];
   assign br_gteq = ~fwd_op_1[15];
   mux4_1 mux4_1_take_br(.InA(br_eq), .InB(br_neq), .InC(br_lt), .InD(br_gteq), .S(br_cnd_sel), .Out(take_br));

   // PC logic
   assign take_new_PC = jmp_instr | jmp_reg_instr | (br_instr & take_br);

   cla_16b add_PC_sext_imm(.A(PC_inc), .B(sext_imm), .C_in(1'b0), .S(PC_sext_imm), .C_out());
   // TODO: Remove this adder //cla_16b add_reg_sext_imm(.A(oprnd_1), .B(sext_imm), .C_in(1'b0), .S(reg_sext_imm), .C_out());

   // determines branching behavior based on result flags
   mux4_1 mux(.InA(ofl), .InB(zero), .InC(ltz), .InD(lteq), .S(set_sel), .Out(set));

   mux2_1 mux2_1_new_PC [15:0](.InA(PC_sext_imm), .InB(alu_out), .S(jmp_reg_instr), .Out(new_PC));
   
endmodule
