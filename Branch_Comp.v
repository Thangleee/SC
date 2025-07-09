module Branch_Comp (
    input  logic [31:0] dataA,      // toán hạng 1
    input  logic [31:0] dataB,      // toán hạng 2
    input  logic        Branch,     // tín hiệu nhảy
    input  logic [2:0]  funct3,     // loại lệnh nhảy
    output logic        BrTaken     // cờ quyết định nhảy
);
    always_comb begin
        BrTaken = 0;
        if (Branch) begin
            case (funct3)
                3'b000: BrTaken = (dataA == dataB);                    // beq
                3'b001: BrTaken = (dataA != dataB);                    // bne
                3'b100: BrTaken = ($signed(dataA) < $signed(dataB));  // blt
                3'b101: BrTaken = ($signed(dataA) >= $signed(dataB)); // bge
                3'b110: BrTaken = (dataA < dataB);                     // bltu
                3'b111: BrTaken = (dataA >= dataB);                    // bgeu
                default: BrTaken = 0;
            endcase
        end
    end
endmodule
