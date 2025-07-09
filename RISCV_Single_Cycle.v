module RISCV_Single_Cycle(
    input  logic        clk,
    input  logic        rst_n,
    output logic [31:0] pc_out,     // PC xuất ra top
    output logic [31:0] instr_out   // Lệnh xuất ra top
);

    logic [31:0] PC_next;

    // Trích xuất các trường của instruction
    logic [4:0] rs1, rs2, rd;
    logic [2:0] funct3;
    logic [6:0] opcode, funct7;

    // Immediate
    logic [31:0] Imm;

    // Register File
    logic [31:0] ReadData1, ReadData2, WriteData;

    // ALU
    logic [31:0] ALU_in2, ALU_result;
    logic ALUZero;

    // Data Memory
    logic [31:0] MemReadData;

    // Control signals
    logic [1:0] ALUSrc;
    logic [3:0] ALUCtrl;
    logic Branch, MemRead, MemWrite, MemToReg;
    logic RegWrite, PCSel;

    // PC update
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc_out <= 32'b0;
        else
            pc_out <= PC_next;
    end

    // Instruction Memory
    IMEM imem_inst(
        .dataA(pc_out),
        .dataOut(instr_out)
    );

    // Decode fields
    assign opcode = instr_out[6:0];
    assign rd     = instr_out[11:7];
    assign funct3 = instr_out[14:12];
    assign rs1    = instr_out[19:15];
    assign rs2    = instr_out[24:20];
    assign funct7 = instr_out[31:25];

    // Immediate Generator
    Imm_Gen imm_gen(
        .inst(instr_out),
        .imm_out(Imm)
    );

    // Register File
    RegisterFile Reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // ALU input 2 chọn giữa ReadData2 hoặc Immediate
    assign ALU_in2 = (ALUSrc[0]) ? Imm : ReadData2;

    // ALU
    ALU alu_inst(
        .A(ReadData1),
        .B(ALU_in2),
        .ALUOp(ALUCtrl),
        .Result(ALU_result),
        .Zero(ALUZero)
    );

    // Data Memory
    DMEM dmem_inst(
        .clk(clk),
        .rst_n(rst_n),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(ALU_result),
        .WriteData(ReadData2),
        .ReadData(MemReadData)
    );

    // WB mux
    assign WriteData = (MemToReg) ? MemReadData : ALU_result;

    // Control Unit
    control_unit ctrl_inst(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUCtrl),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .RegWrite(RegWrite)
    );

    // Branch Comparator
    Branch_Comp br_cmp(
        .dataA(ReadData1),
        .dataB(ReadData2),
        .Branch(Branch),
        .funct3(funct3),
        .BrTaken(PCSel)
    );

    // Next PC
    assign PC_next = (PCSel) ? pc_out + Imm : pc_out + 4;

endmodule
