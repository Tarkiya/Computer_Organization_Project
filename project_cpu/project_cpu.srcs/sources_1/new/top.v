module top(
    input clkIn,
    input rst
);
    wire cpuClk;
    
    wire [31:0] inst;
    wire [31:0] instAddr;
    wire [3:0]  ALUInst = {inst[30],inst[14:12]};
    
    wire [31:0] ReadData;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] WriteData;
    wire [31:0] imm32;
    
    wire [3:0] ALUControl;
    wire [31:0] ALUResult;
    wire zero;
    
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire [1:0] ALUOp;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    
    clk_wiz_0 clk1(clkIn,cpuClk);
    IFetch uIFetch(
        .clk(cpuClk),
        .rst(rst),
        .imm32(imm32),
        .branch(Branch),
        .zero(zero),
        .inst(inst)
    );
    Controller uContrl (
        .inst(inst[6:0]),  
        .Branch(Branch),  
        .MemRead(MemRead),  
        .MemtoReg(MemtoReg),  
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),  
        .ALUSrc(ALUSrc),  
        .RegWrite(RegWrite)  
    );  
    Decoder decoder(
        .clk(cpuClk),
        .rst(rst),
        .inst(inst),
        .regWrite(RegWrite),
        .writeData(WriteData),
        .rs1Data(ReadData1),
        .rs2Data(ReadData2),
        .imm32(imm32)
    );
    ALU uut (
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .imm32(imm32),
        .ALUOp(ALUOp), 
        .funct3(inst[14:12]), 
        .funct7(inst[31:25]), 
        .ALUSrc(ALUSrc), 
        .ALUResult(ALUResult),
        .zero(zero)
    );
    m_data udata(
        .clk(cpuClk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .ALUResult(ALUResult),
        .din(ReadData2),
        .dout(WriteData)
    );
    
endmodule
