module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic [1:0] selSrc,       // chọn ngõ vào ALU
    output logic [3:0] ALUOp,        // điều khiển ALU
    output logic       Branch,       // nhảy có điều kiện
    output logic       MemRead,      // đọc bộ nhớ
    output logic       MemWrite,     // ghi bộ nhớ
    output logic       MemToReg,     // chọn WB từ bộ nhớ
    output logic       RegWrite      // ghi thanh ghi
);

    always_comb begin
        // Default values
        selSrc    = 2'b00;
        ALUOp     = 4'b0000;
        Branch    = 0;
        MemRead   = 0;
        MemWrite  = 0;
        MemToReg  = 0;
        RegWrite  = 0;

        case (opcode)
            7'b0110011: begin // R-type
                selSrc = 2'b00;
                RegWrite = 1;
                case ({funct7, funct3})
                    10'b0000000000: ALUOp = 4'b0000; // add
                    10'b0100000000: ALUOp = 4'b0001; // sub
                    10'b0000000111: ALUOp = 4'b0010; // and
                    10'b0000000110: ALUOp = 4'b0011; // or
                    10'b0000000100: ALUOp = 4'b0100; // xor
                    10'b0000000001: ALUOp = 4'b0101; // sll
                    10'b0000000101: ALUOp = 4'b0110; // srl
                    10'b0100000101: ALUOp = 4'b0111; // sra
                    10'b0000000010: ALUOp = 4'b1000; // slt
                    10'b0000000011: ALUOp = 4'b1001; // sltu
                    default: ALUOp = 4'b0000;
                endcase
            end
            7'b0010011: begin // I-type
                selSrc = 2'b01;
                RegWrite = 1;
                case (funct3)
                    3'b000: ALUOp = 4'b0000; // addi
                    3'b111: ALUOp = 4'b0010; // andi
                    3'b110: ALUOp = 4'b0011; // ori
                    3'b100: ALUOp = 4'b0100; // xori
                    3'b001: ALUOp = 4'b0101; // slli
                    3'b101: ALUOp = (funct7 == 7'b0000000) ? 4'b0110 : 4'b0111; // srli/srai
                    3'b010: ALUOp = 4'b1000; // slti
                    3'b011: ALUOp = 4'b1001; // sltiu
                    default: ALUOp = 4'b0000;
                endcase
            end
            7'b0000011: begin // Load
                selSrc    = 2'b01;
                MemRead   = 1;
                MemToReg  = 1;
                RegWrite  = 1;
                ALUOp     = 4'b0000;
            end
            7'b0100011: begin // Store
                selSrc    = 2'b01;
                MemWrite  = 1;
                ALUOp     = 4'b0000;
            end
            7'b1100011: begin // Branch
                Branch = 1;
                ALUOp  = 4'b0001; // sub để so sánh
            end
            7'b1101111,         // jal
            7'b1100111: begin   // jalr
                selSrc    = 2'b01;
                RegWrite  = 1;
                MemToReg  = 0;
                ALUOp     = 4'b0000;
            end
            default: ; // giữ giá trị mặc định
        endcase
    end

endmodule
