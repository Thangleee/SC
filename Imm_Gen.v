module Imm_Gen (
    input  logic [31:0] inst,
    output logic [31:0] imm_out
);
    logic [6:0] opcode;
    assign opcode = inst[6:0];

    always_comb begin
        case (opcode)
            // I-type: lw, addi, jalr
            7'b0000011, 7'b0010011, 7'b1100111:
                imm_out = {{20{inst[31]}}, inst[31:20]};

            // S-type: sw
            7'b0100011:
                imm_out = {{20{inst[31]}}, inst[31:25], inst[11:7]};

            // B-type: beq, bne, blt, bge...
            7'b1100011:
                imm_out = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};

            // U-type: lui, auipc
            7'b0010111, 7'b0110111:
                imm_out = {inst[31:12], 12'd0};

            // J-type: jal
            7'b1101111:
                imm_out = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};

            default:
                imm_out = 32'd0;
        endcase
    end
endmodule
