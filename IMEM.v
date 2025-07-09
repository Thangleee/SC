module IMEM (
    input  [31:0] addr,
    output [31:0] Instruction
);
    reg [31:0] memory [0:255];

    assign Instruction = (addr[11:2] < 128) ? memory[addr[11:2]] : 32'h00000063;

    initial begin
        $readmemh("./mem/imem2.hex", memory);
    end
endmodule
