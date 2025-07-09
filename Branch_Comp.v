module Branch_Comp (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic        Branch,
    input  logic [2:0]  funct3,
    output logic        BrTaken
);
    always_comb begin
        logic taken;
        taken = 1'b0;

        if (Branch) begin
            unique case (funct3)
                3'b000: taken = (A == B);                             // beq
                3'b001: taken = (A != B);                             // bne
                3'b100: taken = ($signed(A) < $signed(B));            // blt
                3'b101: taken = ($signed(A) >= $signed(B));           // bge
                3'b110: taken = (A < B);                              // bltu
                3'b111: taken = (A >= B);                             // bgeu
                default: taken = 1'b0;
            endcase
        end

        BrTaken = taken;
    end
endmodule
