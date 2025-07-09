module IMEM (
    input  logic [31:0] addr,
    output logic [31:0] Instruction
);
    logic [31:0] instr_mem [0:255];

    // Giới hạn SC1: nếu vượt quá 128 lệnh, trả về HALT (beq x0, x0, 0)
    assign Instruction = (addr[11:2] < 7'd128) ? instr_mem[addr[11:2]] : 32'h00000063;

    // Load từ file .hex
    initial begin
        if (!$readmemh("./mem/imem2.hex", instr_mem)) begin
            $display("imem2.hex not found. Falling back to imem.hex...");
            $readmemh("./mem/imem.hex", instr_mem);
        end
    end
endmodule
