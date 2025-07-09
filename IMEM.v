module IMEM (
    input  logic [31:0] addr,           
    output logic [31:0] Instruction    
);

    logic [31:0] mem_array [0:255];     

    // Đọc lệnh từ bộ nhớ. Nếu vượt quá 128 dòng => trả về lệnh halt
    always_comb begin
        if (addr[11:2] < 128)
            Instruction = mem_array[addr[11:2]];          // Word-aligned address
        else
            Instruction = 32'h00000063;                  // Halt (beq x0, x0, 0)
    end

    // Nạp dữ liệu từ file khởi tạo
    initial begin
        if (!$readmemh("./mem/imem2.hex", mem_array)) begin
            $display("imem2.hex không tồn tại, thử nạp imem.hex...");
            $readmemh("./mem/imem.hex", mem_array);
        end
    end

endmodule
