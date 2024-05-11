module top(
    input clkIn
);
    wire cpuClk;
    
    wire [31:0] instAddr;
    wire [31:0] instruction;
    wire [3:0]  ALUInst = {instruction[30],instruction[14:12]};
    
    wire [31:0] WData;//需要写一个MUX
    wire [31:0] RData;
    wire [31:0] RData1;
    wire [31:0] RData2;
    wire [31:0] immediate;
    wire [31:0] ALUData;
    
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
    m_inst minst_instance(
        .clk(cpuClk),
        .addr(instAddr),
        .instruction(instruction)
    );
    control ctrl_instance (  
        .instruction(instruction[6:0]),  
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
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd (instruction[11:7]),
        .RegWrite(RegWrite),
        .WData(WData),
        .RData1(RData1),
        .RData2(RData2)
    );
    ImmGen immgen(
        .instruction(instruction),
        .immediate(immediate)
    );
    MUX1 mux1(
        .ALUSrc(ALUSrc),
        .RData2(RData2),
        .immediate(immediate),
        .ALUData(ALUData)
    );
    ALUControlPort aluControlPort (
        .ALUOp(ALUOp),
        .instruction({instruction[30],instruction[14:12]}),
        .ALUControl(ALUControl)
        );
    ALU alu (
        .RData1(RData1),
        .ALUData(ALUData),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult)
    );
    m_data mdata_instance(
        .clk(cpuClk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(ALUResult),
        .din(RData2),
        .dout(RData)
    );
    MUX2 mux2(
        .MemtoReg(MemtoReg),
        .RData(RData),
        .ALUResult(ALUResult),
        .WData(WData)
    );
    
endmodule
