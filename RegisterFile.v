module RegisterFile (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        RegWrite,
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,
    input  logic [31:0] WriteData,
    output logic [31:0] ReadData1,
    output logic [31:0] ReadData2
);
    logic [31:0] regs [0:31];

    // Read ports (combinational)
    assign ReadData1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
    assign ReadData2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

    // Write port (sequential)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            foreach (regs[i]) begin
                regs[i] <= 32'd0;
            end
        end else if (RegWrite && rd != 5'd0) begin
            regs[rd] <= WriteData;
        end
    end
endmodule
