module DMEM (
    input  logic        clk,        
    input  logic        rst_n,      
    input  logic        MemRead,    
    input  logic        MemWrite,   
    input  logic [31:0] addr,       
    input  logic [31:0] WriteData, 
    output logic [31:0] ReadData    
);

    logic [31:0] mem_array [0:255]; 

    // Đọc bộ nhớ đồng bộ (combinational)
    always_comb begin
        if (MemRead)
            ReadData = mem_array[addr[9:2]]; // Lấy word-aligned address
        else
            ReadData = 32'b0;
    end

    // Ghi bộ nhớ đồng bộ với clock và reset
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset: xóa toàn bộ vùng nhớ
            for (int i = 0; i < 256; i++)
                mem_array[i] <= 32'b0;
        end else if (MemWrite) begin
            // Ghi dữ liệu vào địa chỉ
            mem_array[addr[9:2]] <= WriteData;
        end
    end

    // Nạp dữ liệu khởi tạo từ file HEX
    initial begin
        if (!$readmemh("./mem/dmem_init2.hex", mem_array)) begin
            $display("dmem_init2.hex không tìm thấy, thử dùng dmem_init.hex...");
            $readmemh("./mem/dmem_init.hex", mem_array);
        end
    end

endmodule
