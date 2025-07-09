module Branch_Comp (
    input  logic [31:0] A,         
    input  logic [31:0] B,         
    input  logic        Branch,    
    input  logic [2:0]  funct3,    
    output logic        BrTaken    
);

    logic take_branch;

    always_comb begin
        
        take_branch = 1'b0;

        if (Branch) begin
            unique case (funct3)
                3'b000: take_branch = (A == B);                          // beq
                3'b001: take_branch = (A != B);                          // bne
                3'b100: take_branch = ($signed(A) < $signed(B));         // blt
                3'b101: take_branch = ($signed(A) >= $signed(B));        // bge
                3'b110: take_branch = (A < B);                           // bltu
                3'b111: take_branch = (A >= B);                          // bgeu
                default: take_branch = 1'b0;
            endcase
        end

        BrTaken = take_branch;
    end

endmodule
