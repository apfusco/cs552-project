/*
* Sign-extends a given immediate to 16 bits based on the instruction.
*/
module sext(instr, ext_op, imm, err);
    input      [15:0] instr;
    input      [1:0]  ext_op;
    output reg [15:0] imm;
    output reg err;

    /* here are all the instructions that need sign extension:
    * 
    * I1 format instructions
    * 01000 (addi)
    * 01001 (subi)
    * 01010 (xori)
    * 01011 (andni)
    * 10000 (st)
    * 10001 (ld)
    * 10011 (stu)
    *
    * I2 format instructions
    * 01100 (beqz)
    * 01101 (bnez)
    * 01110 (bltz)
    * 01111 (bgez)
    * 11000 (lbi)
    * 10010 (slbi)
    * 00101 (jr)
    * 00111 (jalr)
    *
    * J format instructions
    * 00100 (j)
    * 00110 (jal) 
    *
    * 
    * I format 1: [15:11] = opcode, [10:8] = Rs, [7:5] = Rd, [4:0] = imm
    *   - logical instructions are zero extended
    *   - arithmetic instructions are sign extended
    *
    * I format 2: [15:11] = opcode, [10:8] = Rs, [7:0] = imm
    *   - slbi is zero extended
    *   - everything else is sign extended
    *
    * J format: [15:11] = opcode, [10:0] = displ
    *   - all are sign extended
    */

   /*
    * Immediate extension operations.
    * Opcode | extension
    * 00     | zext(instr[4:0])
    * 01     | sext(instr[4:0])
    * 10     | sext(instr[7:0])
    * 11     | sext(instr[10:0])
    */
    always @ (*) begin
        err = 1'b0;
        case (ext_op)
            2'b00: imm = {{11{1'b0}}, instr[4:0]};
            2'b01: imm = {{11{instr[4]}}, instr[4:0]};
            2'b10: imm = {{8{instr[7]}}, instr[7:0]};
            2'b11: imm = {{5{instr[10]}}, instr[10:0]};
            default: err = 1'b1;
        endcase
    end
endmodule
