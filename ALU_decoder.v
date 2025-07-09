module ALU_decoder (
    input  logic [1:0] alu_op,
    input  logic [2:0] funct3,
    input  logic       funct7b5,
    output logic [3:0] alu_control
);
    always_comb begin
        unique case (alu_op)
            2'b00: alu_control = 4'b0010; // Load/Store → ADD
            2'b01: alu_control = 4'b0110; // Branch → SUB
            2'b10: begin
                unique case (funct3)
                    3'b000: alu_control = (funct7b5 == 1'b1) ? 4'b0110 : 4'b0010; // SUB or ADD
                    3'b111: alu_control = 4'b0000; // AND
                    3'b110: alu_control = 4'b0001; // OR
                    3'b010: alu_control = 4'b0111; // SLT
                    default: alu_control = 4'b1111; // Unknown → dùng giá trị đặc biệt
                endcase
            end
            default: alu_control = 4'b1111;
        endcase
    end
endmodule
