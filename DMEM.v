module DMEM (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        MemRead,
    input  logic        MemWrite,
    input  logic [31:0] addr,
    input  logic [31:0] WriteData,
    output logic [31:0] ReadData
);
    // 1KB bộ nhớ: 256 từ, mỗi từ 32-bit
    logic [31:0] mem_array [0:255];

    // Đọc bộ nhớ (combinational)
    assign ReadData = (MemRead) ? mem_array[addr[9:2]] : 32'd0;

    // Ghi bộ nhớ (sequential)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < 256; i++) begin
                mem_array[i] <= 32'd0;
            end
        end else if (MemWrite) begin
            mem_array[addr[9:2]] <= WriteData;
        end
    end

    // Khởi tạo từ file hex
    initial begin
        if (!$readmemh("./mem/dmem_init2.hex", mem_array)) begin
            $display("dmem_init2.hex not found. Trying dmem_init.hex...");
            $readmemh("./mem/dmem_init.hex"_
