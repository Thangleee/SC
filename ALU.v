module ALU (
    input  logic [31:0] dataA,
    input  logic [31:0] dataB,
    input  logic [3:0]  ALUOp,
    output logic [31:0] Result,
    output logic Zero
);
    always @(*) begin
        case (ALUOp)
            4'b0000: Result = dataA + dataB;
            4'b0001: Result = dataA - dataB;
            4'b0010: Result = dataA & dataB;
            4'b0011: Result = dataA | dataB;
            4'b0100: Result = dataA ^ dataB;
            4'b0101: Result = dataA << dataB[4:0];
            4'b0110: Result = dataA >> dataB[4:0];
            4'b0111: Result = $signed(dataA) >>> dataB[4:0];
            4'b1000: Result = ($signed(dataA) < $signed(dataB)) ? 1 : 0;
            4'b1001: Result = (dataA < dataB) ? 1 : 0;
            default: Result = 32'b0;
        endcase
    end
    assign Zero = (Result == 32'b0);
endmodule
