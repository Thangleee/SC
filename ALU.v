module ALU (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0]  ALUOp,
    output logic [31:0] Result,
    output logic        Zero
);

    always_comb begin
        case (ALUOp)
            4'd0:  Result = A + B;                                   // Addition
            4'd1:  Result = A - B;                                   // Subtraction
            4'd2:  Result = A & B;                                   // Bitwise AND
            4'd3:  Result = A | B;                                   // Bitwise OR
            4'd4:  Result = A ^ B;                                   // Bitwise XOR
            4'd5:  Result = A << B[4:0];                             // Logical shift left
            4'd6:  Result = A >> B[4:0];                             // Logical shift right
            4'd7:  Result = ($signed(A)) >>> B[4:0];                 // Arithmetic shift right
            4'd8:  Result = ($signed(A) < $signed(B)) ? 32'h1 : 32'h0; // Signed less-than
            4'd9:  Result = (A < B) ? 32'h1 : 32'h0;                 // Unsigned less-than
            default: Result = 32'hBEEF_DEAD;                         // Debug default
        endcase

        // Tín hiệu Zero: Result có bằng 0 không?
        Zero = (Result == 32'd0);
    end

endmodule
