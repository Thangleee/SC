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

    // Đọc thanh ghi: x0 luôn trả về 0
    assign ReadData1 = (rs1 == 0) ? 32'b0 : regs[rs1];
    assign ReadData2 = (rs2 == 0) ? 32'b0 : regs[rs2];

    // Ghi thanh ghi: chỉ ghi nếu RegWrite và rd ≠ 0 (x0 luôn là 0)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < 32; i++) begin
                regs[i] <= 32'b0;     // Reset tất cả thanh ghi về 0
            end
        end else if (RegWrite && rd != 0) begin
            regs[rd] <= WriteData;   // Ghi dữ liệu vào thanh ghi rd
        end
    end

endmodule
