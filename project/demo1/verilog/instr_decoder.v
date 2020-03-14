/*
* Decodes an instruction to determine what values to pass into the register file.
*/
module instr_decoder (rd_reg_1, rd_reg_2, wr_reg, instr);
    output reg [2:0] rd_reg_1;
    output reg [2:0] rd_reg_2;
    output reg [2:0] wr_reg;
    output dump;
    output wr_en; 

    input [15:0] instr;

    always @(*) begin
        case (instr[15:11]) begin
            // for all instruction, RS is oprnd_1 for the ALU
            5'b00000: // HALT TODO
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end
            5'b00001: // NOP TODO
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end

            5'b01000: // ADDI
                begin
                    rd_reg_1 = instr[10:8];
                    rd_reg_2 = 3'b000;
                    wr_reg = instr[7:5];
                end
            5'b01001: // SUBI
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = instr[7:5];
                end
            5'b01010: // XORI
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = instr[7:5];
                end
            5'b01011: // ANDNI
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = instr[7:5];
                end
            5'b10100: // ROLI
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = instr[7:5];
                end
            5'b10101: // SLLI
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = instr[7:5];
                end
            5'b10110: // RORI
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = instr[7:5];
                end
            5'b10111: // SRLI
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = instr[7:5];
                end
            5'b10000: // ST TODO
                begin
                    rd_reg_1 = instr[7:5];
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end
            5'b10001: // LD
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = instr[7:5];
                end
            5'b10011: // STU
                begin
                    rd_reg_1 = instr[7:5];
                    rd_reg_2 = 3'b000;
                    wr_reg = instr[10:8];
                end

            5'b11001: // BTR
                begin
                    rd_reg_1 = instr[10:8];
                    rd_reg_2 = 3'b000;
                    wr_reg = instr[4:2];
                end
            5'b11011: // ADD (func 00)
                begin
                    rd_reg_1 = instr[10:8]; 
                    rd_reg_2 = instr[7:5];
                    wr_reg = instr[4:2];
                end
            5'b11011: // SUB (func 01)
                begin
                    rd_reg_1 = instr[10:8]; 
                    rd_reg_2 = instr[7:5];
                    wr_reg = instr[4:2];
                end
            5'b11011: // XOR (func 10)
                begin
                    rd_reg_1 = instr[10:8]; 
                    rd_reg_2 = instr[7:5];
                    wr_reg = instr[4:2];
                end
            5'b11011: // ANDN (func 11)
                begin
                    rd_reg_1 = instr[10:8]; 
                    rd_reg_2 = instr[7:5];
                    wr_reg = instr[4:2];
                end
            5'b11010: // ROL (func 00)
                begin
                    rd_reg_1 = instr[10:8]; 
                    rd_reg_2 = instr[7:5];
                    wr_reg = instr[4:2];
                end
            5'b11010: // SLL (func 01)
                begin
                    rd_reg_1 = instr[10:8]; 
                    rd_reg_2 = instr[7:5];
                    wr_reg = instr[4:2];
                end
            5'b11010: // ROR (func 10)
                begin
                    rd_reg_1 = instr[10:8]; 
                    rd_reg_2 = instr[7:5];
                    wr_reg = instr[4:2];
                end
            5'b11010: // SRL (func 11)
                begin
                    rd_reg_1 = instr[10:8]; 
                    rd_reg_2 = instr[7:5];
                    wr_reg = instr[4:2];
                end
            5'b11100: // SEQ
                begin
                    rd_reg_1 = instr[10:8]; 
                    rd_reg_2 = instr[7:5];
                    wr_reg = instr[4:2];
                end
            5'b11101: // SLT
                begin
                    rd_reg_1 = instr[10:8]; 
                    rd_reg_2 = instr[7:5];
                    wr_reg = instr[4:2];
                end
            5'b11110: // SLE
                begin
                    rd_reg_1 = instr[10:8]; 
                    rd_reg_2 = instr[7:5];
                    wr_reg = instr[4:2];
                end
            5'b11111: // SCO
                begin
                    rd_reg_1 = instr[10:8]; 
                    rd_reg_2 = instr[7:5];
                    wr_reg = instr[4:2];
                end

            5'b01100: // BEQZ
                begin
                    rd_reg_1 = instr[10:8];
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end
            5'b01101: // BNEZ
                begin
                    rd_reg_1 = instr[10:8];
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end
            5'b01110: // BLTZ
                begin
                    rd_reg_1 = instr[10:8];
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end
            5'b01111: // BGEZ
                begin
                    rd_reg_1 = instr[10:8];
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end
            5'b11000: // LBI
                begin
                    rd_reg_1 = instr[10:8];
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end
            5'b10010: // SLBI
                begin
                    rd_reg_1 = instr[10:8];
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end

            5'b00100: // J
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end
            5'b00101: // JR
                begin
                    rd_reg_1 = instr[10:8];
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end
            5'b00110: // JAL
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end
            5'b00111: // JALR
                begin
                    rd_reg_1 = instr[10:8];
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end

            5'b00010: // siic
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end
            5'b00011: // NOP / RTI
                begin
                    rd_reg_1 = 3'b000;
                    rd_reg_2 = 3'b000;
                    wr_reg = 3'b000;
                end
        endcase
    end

endmodule
