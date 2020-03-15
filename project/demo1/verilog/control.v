module control (instr,
                br_cnd_sel,
                set_sel,
                wr_en,
                mem_wr_en,
                mem_en,
                wr_sel,
                wr_reg_sel,
                oprnd_sel,
                jmp_reg_instr,
                jmp_instr,
                br_instr,
                sext_op,
                alu_op,
                alu_invA,
                alu_invB,
                alu_Cin,
                alu_sign,
                pc_en,
                err);

   input [15:0] instr;
   output [1:0] br_cnd_sel;
   output [1:0] set_sel;
   output       wr_en;
   output       mem_wr_en;
   output       mem_en;
   output [2:0] wr_sel;
   output [1:0] wr_reg_sel;
   output       oprnd_sel;
   output       jmp_reg_instr;
   output       jmp_instr;
   output       br_instr;
   output [2:0] sext_op;
   output [2:0] alu_op;
   output       alu_invA;
   output       alu_invB;
   output       alu_Cin;
   output       alu_sign;
   output       pc_en;
   output       err;

   // Control outputs
   reg [1:0] case_br_cnd_sel;
   reg [1:0] case_set_sel;
   reg       case_wr_en;
   reg       case_mem_wr_en;
   reg       case_mem_en;
   reg [2:0] case_wr_sel;
   reg [1:0] case_wr_reg_sel;
   reg       case_oprnd_sel;
   reg       case_jmp_reg_instr;
   reg       case_jmp_instr;
   reg       case_br_instr;
   reg [2:0] case_sext_op;
   reg [2:0] case_alu_op;
   reg       case_alu_invA;
   reg       case_alu_invB;
   reg       case_alu_Cin;
   reg       case_alu_sign;
   reg       case_pc_en;
   reg       case_err;

   /*
    * Immediate extension operations.
    * Opcode | extension
    * 00     | zext(instr[4:0])
    * 01     | sext(instr[4:0])
    * 10     | sext(instr[7:0])
    * 11     | sext(instr[10:0])
    * TODO
    */

   always @(*) begin
      // Set defaults
      case_br_cnd_sel = 2'b00;
      case_set_sel = 2'b00;
      case_wr_en = 1'b0;        // High for writing back to register
      case_mem_wr_en = 1'b0;    // High for writing to memory
      case_mem_en = 1'b0;       // High for accessing memory
      case_wr_sel = 3'b000;      // High for selecting ALU output
      case_wr_reg_sel = 2'b00;   // High for instr[7:5] as wr_reg
      case_oprnd_sel = 1'b0;    // High for using immediate as operand
      case_jmp_reg_instr = 1'b0;// High for reg jump instructions
      case_jmp_instr = 1'b0;    // High for jump instructions
      case_br_instr = 1'b0;     // High for branch instructions
      case_sext_op = 3'b000;    // Sign extension opcode
      case_alu_op = 3'b000;     // Opcode for the ALU
      case_alu_invA = 1'b0;     // Invert input A of the ALU
      case_alu_invB = 1'b0;     // Invert input B of the ALU
      case_alu_Cin = 1'b0;      // Carry in for the ALU
      case_alu_sign = 1'b1;     // Treat operands as signed
      case_pc_en = 1'b1;        // High when PC can be updated
      case_err = 1'b0;          // High upon error

      case (instr[15:11])
         5'b00000: begin // HALT
            case_pc_en = 1'b0;
         end
         5'b00001: begin // NOP
            /**
            * Not writes to registers or memory should be performed except for
            * the PC.
            */
         end
         5'b01000: begin // ADDI
            case_wr_en = 1'b1;
            case_wr_reg_sel = 2'b01;
            case_oprnd_sel = 1'b1;
            case_sext_op = 3'b001;
            case_alu_op = 3'b100;
         end
         5'b01001: begin // SUBI
            case_wr_en = 1'b1;
            case_wr_reg_sel = 2'b01;
            case_oprnd_sel = 1'b1;
            case_sext_op = 3'b001;
            case_alu_op = 3'b100;
            case_alu_invA = 1'b1;
            case_alu_Cin = 1'b1;
         end
         5'b01010: begin // XORI
            case_wr_en = 1'b1;
            case_wr_reg_sel = 2'b01;
            case_oprnd_sel = 1'b1;
            case_alu_op = 3'b111;
         end
         5'b01011: begin // ANDNI
            case_wr_en = 1'b1;
            case_wr_reg_sel = 2'b01;
            case_oprnd_sel = 1'b1;
            case_alu_op = 3'b101;
            case_alu_invB = 1'b1;
         end
         5'b10100: begin // ROLI
            case_wr_en = 1'b1;
            case_wr_reg_sel = 2'b01;
            case_oprnd_sel = 1'b1;
            case_alu_op = 3'b000;
         end
         5'b10101: begin // SLLI
            case_wr_en = 1'b1;
            case_wr_reg_sel = 2'b01;
            case_oprnd_sel = 1'b1;
            case_alu_op = 3'b001;
         end
         5'b10110: begin // RORI
            case_wr_en = 1'b1;
            case_wr_reg_sel = 2'b01;
            case_oprnd_sel = 1'b1;
            case_alu_op = 3'b010;
         end
         5'b10111: begin // SRLI
            case_wr_en = 1'b1;
            case_wr_reg_sel = 2'b01;
            case_oprnd_sel = 1'b1;
            case_alu_op = 3'b011;
         end
         5'b10000: begin // ST
            case_mem_en = 1'b1;
            case_mem_wr_en = 1'b1;
            case_wr_reg_sel = 2'b01;
            case_oprnd_sel = 1'b1;
            case_sext_op = 3'b001;
            case_alu_op = 3'b100;
         end
         5'b10001: begin // LD
            case_mem_en = 1'b1;
            case_wr_en = 1'b1;
            case_wr_sel = 3'b001;
            case_wr_reg_sel = 2'b01;
            case_oprnd_sel = 1'b1;
            case_sext_op = 3'b001;
            case_alu_op = 3'b100;
         end
         5'b10011: begin // STU
            case_mem_en = 1'b1;
            case_wr_en = 1'b1;
            case_mem_wr_en = 1'b1;
            case_wr_reg_sel = 2'b10;
            case_oprnd_sel = 1'b1;
            case_sext_op = 3'b001;
            case_alu_op = 3'b100;
         end
         5'b11001: begin // BTR
            case_wr_en = 1'b1;
            case_alu_op = 3'b110;
         end
         5'b11011: begin // ADD, SUB, XOR, ANDN
            case_wr_en = 1'b1;
            case_alu_op = (instr[1] == 1'b0) ? 3'b100 :
                  (instr[0] == 1'b0) ? 3'b111 : 3'b101;
            case_alu_invA = ~instr[1] & instr[0];
            case_alu_invB = instr[1] & instr[0];
            case_alu_Cin = ~instr[1] & instr[0];
         end
         5'b11010: begin // ROL, SLL, ROR, SRL
            case_wr_en = 1'b1;
            case_alu_op = {1'b0, instr[1], instr[0]};
         end
         5'b11100: begin // SEQ
            case_wr_en = 1'b1;
            case_set_sel = 2'b01;
            case_wr_sel = 3'b011;
            case_alu_op = 3'b100;
            case_alu_invB = 1'b1;
            case_alu_Cin = 1'b1;
         end
         5'b11101: begin // SLT
            case_wr_en = 1'b1;
            case_set_sel = 2'b10;
            case_wr_sel = 3'b011;
            case_alu_op = 3'b100;
            case_alu_invB = 1'b1;
            case_alu_Cin = 1'b1;
         end
         5'b11110: begin // SLE
            case_wr_en = 1'b1;
            case_set_sel = 2'b11;
            case_wr_sel = 3'b011;
            case_alu_op = 3'b100;
            case_alu_invB = 1'b1;
            case_alu_Cin = 1'b1;
         end
         5'b11111: begin // SCO
            case_wr_en = 1'b1;
            // case_set_sel = 2'b00;
            case_wr_sel = 3'b011;
            case_alu_sign = 1'b0;
            case_alu_op = 3'b100;
         end
         5'b01100: begin // BEQZ
            // case_br_cnd_sel = 2'b00;
            case_br_instr = 1'b1;
            case_sext_op = 3'b010;
         end
         5'b01101: begin // BNEZ
            case_br_cnd_sel = 2'b01;
            case_br_instr = 1'b1;
            case_sext_op = 3'b010;
         end
         5'b01110: begin // BLTZ
            case_br_cnd_sel = 2'b10;
            case_br_instr = 1'b1;
            case_sext_op = 3'b010;
         end
         5'b01111: begin // BEGZ
            case_br_cnd_sel = 2'b11;
            case_br_instr = 1'b1;
            case_sext_op = 3'b010;
         end
         5'b11000: begin // LBI
            case_wr_en = 1'b1;
            case_wr_sel = 3'b100;
            case_wr_reg_sel = 2'b10;
         end
         5'b10010: begin // SLBI
            case_wr_en = 1'b1;
            case_wr_sel = 3'b101;
            case_wr_reg_sel = 2'b10;
         end
         5'b00100: begin // J
            case_jmp_instr = 1'b1;
            case_sext_op = 3'b011;
         end
         5'b00101: begin // JR
            case_jmp_reg_instr = 1'b1;
            case_jmp_instr = 1'b1;
            case_sext_op = 3'b010;
         end
         5'b00110: begin // JAL
            case_wr_en = 1'b1;
            case_wr_sel = 3'b010;
            case_wr_reg_sel = 2'b11;
            case_jmp_instr = 1'b1;
            case_sext_op = 3'b011;
         end
         5'b00111: begin // JALR
            case_wr_en = 1'b1;
            case_wr_sel = 3'b010;
            case_wr_reg_sel = 2'b11;
            case_jmp_reg_instr = 1'b1;
            case_jmp_instr = 1'b1;
            case_sext_op = 3'b010;
         end
         5'b00010: begin // siic
            // TODO: Produce illegal exception.
         end
         5'b00011: begin
            // TODO: NOP
         end
         default: begin
            case_err = 1'b1;
         end
      endcase
   end

   // Assign case outputs to module outputs
   assign err = ((^instr ^ case_err) === 1'bX) ? 1'b1 : 1'b0;
   assign br_cnd_sel = case_br_cnd_sel;
   assign set_sel = case_set_sel;
   assign wr_en = case_wr_en;
   assign mem_wr_en = case_mem_wr_en;
   assign mem_en = case_mem_en;
   assign wr_sel = case_wr_sel;
   assign wr_reg_sel = case_wr_reg_sel;
   assign oprnd_sel = case_oprnd_sel;
   assign jmp_reg_instr = case_jmp_reg_instr;
   assign jmp_instr = case_jmp_instr;
   assign br_instr = case_br_instr;
   assign sext_op = case_sext_op;
   assign alu_op = case_alu_op;
   assign alu_invA = case_alu_invA;
   assign alu_invB = case_alu_invB;
   assign alu_Cin = case_alu_Cin;
   assign alu_sign = case_alu_sign;
   assign pc_en = case_pc_en;
   
endmodule
