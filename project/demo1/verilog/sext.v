/*
* Sign-extends a given immediate to 16 bits based on the instruction.
*/
module sext(instr, imm);
    input [15:0] instr;
    output reg [15:0] imm;

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

    always @ (*) begin
        case (instr[15:11])
            // I1 format instructions
            5'b01000:  imm = {{11{instr[4]}}, instr[4:0]};   // addi
            5'b01001:  imm = {{11{instr[4]}}, instr[4:0]};   // subi
            5'b01010:  imm = {{11{1'b0}}, instr[4:0]};       // xori
            5'b01011:  imm = {{11{1'b0}}, instr[4:0]};       // andni
            5'b10000:  imm = {{11{instr[4]}}, instr[4:0]};   // st
            5'b10001:  imm = {{11{instr[4]}}, instr[4:0]};   // ld
            5'b10011:  imm = {{11{instr[4]}}, instr[4:0]};   // stu

            // I2 format instructions
            5'b01100:  imm = {{8{instr[7]}}, instr[7:0]};    // beqz
            5'b01101:  imm = {{8{instr[7]}}, instr[7:0]};    // bnez
            5'b01110:  imm = {{8{instr[7]}}, instr[7:0]};    // bltz
            5'b01111:  imm = {{8{instr[7]}}, instr[7:0]};    // bgez
            5'b11000:  imm = {{8{instr[7]}}, instr[7:0]};    // lbi
            5'b10010:  imm = {{8{1'b0}}, instr[7:0]};        // slbi
            5'b00101:  imm = {{8{instr[7]}}, instr[7:0]};    // jr
            5'b00111:  imm = {{8{instr[7]}}, instr[7:0]};    // jalr

            // J format instructions
            5'b00100:  imm = {{5{instr[10]}}, instr[10:0]};  // j
            5'b00110:  imm = {{5{instr[10]}}, instr[10:0]};  // jal
        endcase
    end
endmodule
