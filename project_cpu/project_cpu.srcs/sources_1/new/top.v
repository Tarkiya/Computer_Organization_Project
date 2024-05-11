module top(
    input clkIn
);
    wire cpuClk;
    wire [31:0]readData1;
    wire [31:0] readData2;
    wire [31:0] imm;
    wire ALUSrc;
    wire [1:0] ALUOp;
    wire [31:0] instruction;//指的是指令的30 和14-12 传入alucontrolport 命名会产生冲突！！！！！
    wire [3:0] ALUControl;
    wire [31:0] ALUResult;
    wire zero;
    wire [31:0] inst;
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire MemWrite;
    wire RegWrite;
    
    clk_wiz_0 clk1(clkIn,cpuClk);
    ALUControlPort acp (ALUOp,instruction,ALUControl);
    ALU alu (readData1,readData2,imm,ALUSrc,ALUControl,ALUResult);
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
endmodule
