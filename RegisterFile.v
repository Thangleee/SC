module RegisterFile (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        RegWrite,        // cho phép ghi
    input  logic [4:0]  addrA,           // địa chỉ đọc 1 (rs1)
    input  logic [4:0]  addrB,           // địa chỉ đọc 2 (rs2)
    input  logic [4:0]  addrW,           // địa chỉ ghi (rd)
    input  logic [31:0] dataW,           // dữ liệu ghi
    output logic [31:0] dataA,           // dữ liệu đọc từ addrA
    output logic [31:0] dataB            // dữ liệu đọc từ addrB
);

    logic [31:0] registers [0:31];       // 32 thanh ghi

    // đọc bất đồng bộ, x0 luôn là 0
    assign dataA = (addrA != 0) ? registers[addrA] : 32'b0;
    assign dataB = (addrB != 0) ? registers[addrB] : 32'b0;

    // ghi đồng bộ ở cạnh lên
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < 32; i++) registers[i] <= 32'b0;
        end else if (RegWrite && addrW != 0) begin
            registers[addrW] <= dataW;
        end
    end

endmodule
