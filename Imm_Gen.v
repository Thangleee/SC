module Imm_Gen (
    input  logic [31:0] inst,       
    output logic [31:0] imm_out     
);

    logic [6:0] opcode;
    assign opcode = inst[6:0];

    logic [31:0] imm_i, imm_s, imm_b, imm_u, imm_j;

    // Tạo từng loại immediate riêng biệt
    assign imm_i = {{20{inst[31]}}, inst[31:20]};                                // I-type
    assign imm_s = {{20{inst[31]}}, inst[31:25], inst[11:7]};                    // S-type
    assign imm_b = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0}; // B-type
    assign imm_u = {inst[31:12], 12'b0};                                         // U-type (lui, auipc)
    assign imm_j = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0}; // J-type (jal)

    always_comb begin
        unique case (opcode)
            7'b0000011,    // I-type: load
            7'b0010011,    // I-type: ALU immediate
            7'b1100111:    // I-type: jalr
                imm_out = imm_i;

            7'b0100011:    // S-type: store
                imm_out = imm_s;

            7'b1100011:    // B-type: branch
                imm_out = imm_b;

            7'b0010111,    // U-type: auipc
            7'b0110111:    // U-type: lui
                imm_out = imm_u;

            7'b1101111:    // J-type: jal
                imm_out = imm_j;

            default:       // Không hợp lệ
                imm_out = 32'b0;
        endcase
    end

endmodule
