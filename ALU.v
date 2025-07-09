module ALU (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0]  ALUOp,
    output logic [31:0] Result,
    output logic Zero
);

    logic [31:0] sum, diff, and_op, or_op, xor_op;
    logic [31:0] sll, srl, sra;
    logic [31:0] slt_signed, slt_unsigned;

    assign sum          = A + B;
    assign diff         = A - B;
    assign and_op       = A & B;
    assign or_op        = A | B;
    assign xor_op       = A ^ B;
    assign sll          = A << B[4:0];
    assign srl          = A >> B[4:0];
    assign sra          = $signed(A) >>> B[4:0];
    assign slt_signed   = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
    assign slt_unsigned = (A < B) ? 32'd1 : 32'd0;

    always_comb begin
        case (ALUOp)
            4'b0000: Result = sum;
            4'b0001: Result = diff;
            4'b0010: Result = and_op;
            4'b0011: Result = or_op;
            4'b0100: Result = xor_op;
            4'b0101: Result = sll;
            4'b0110: Result = srl;
            4'b0111: Result = sra;
            4'b1000: Result = slt_signed;
            4'b1001: Result = slt_unsigned;
            default: Result = 32'b0;
        endcase
    end

    assign Zero = (Result == 32'b0);

endmodule
