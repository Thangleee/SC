module RISCV_Single_Cycle (
    input  logic        clk,              
    input  logic        rst_n,            
    output logic [31:0] PC_out_top,       
    output logic [31:0] Instruction_out_top 
);

    // ========== Program Counter ==========
    logic [31:0] PC_next;                 

    // ========== Instruction Fields ==========
    logic [4:0]  rs1, rs2, rd;
    logic [2:0]  funct3;
    logic [6:0]  opcode, funct7;

    // ========== Immediate ==========
    logic [31:0] Imm;

    // ========== Register File ==========
    logic [31:0] ReadData1, ReadData2, WriteData;

    // ========== ALU ==========
    logic [31:0] ALU_in2, ALU_result;
    logic        ALUZero;

    // ========== Data Memory ==========
    logic [31:0] MemReadData;

    // ========== Control Signals ==========
    logic [1:0]  ALUSrc;
    logic [3:0]  ALUCtrl;
    logic        Branch, MemRead, MemWrite, MemToReg;
    logic        RegWrite, PCSel;

    // ========== PC Update ==========
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            PC_out_top <= 32'b0;           // Reset PC về 0
        else
            PC_out_top <= PC_next;         // Cập nhật PC mới
    end

    // ========== Instruction Memory ==========
    IMEM IMEM_inst (
        .addr(PC_out_top),
        .Instruction(Instruction_out_top)
    );

    // ========== Decode Instruction ==========
    assign opcode = Instruction_out_top[6:0];
    assign rd     = Instruction_out_top[11:7];
    assign funct3 = Instruction_out_top[14:12];
    assign rs1    = Instruction_out_top[19:15];
    assign rs2    = Instruction
