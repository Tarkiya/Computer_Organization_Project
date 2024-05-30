module top(
    input clkIn,
    input rst,
    input [7:0] switchLeft,
    input [7:0] switchRight,
    input [4:0] button,
    output [7:0] ledLeft,
    output [7:0] ledRight,
    output [7:0] segCtrl,//左侧段选信号
    output [7:0] segCtrr,//右侧段选信号
    output [7:0] chipSel //所有片选信号
);
    // 时钟调频
    /////////////////////////////////////////////////////////////
    wire cpuClk;//cpu时钟
    wire segClk;//数码管显示时钟
    clk_wiz_0 cpuclk1(
        .clk_in1(clkIn),
        .clk_out1(cpuClk)
    );
    segclk segclk1(
        .clk_in1(clkIn),
        .clk_out1(segClk)
    );
    
    // IFetch 模块
    /////////////////////////////////////////////////////////////
    wire [31:0] imm32;
    wire [31:0] inst;
    wire zero;
    wire Branch;
    IFetch uIFetch(
        .clk(cpuClk),
        .rst(rst),
        .imm32(imm32),
        .zero(zero),
        .branch(Branch),
        .inst(inst)
    );
    
    // Controller 模块
    /////////////////////////////////////////////////////////////
    wire MemRead;
    wire MemtoReg;
    wire [1:0] ALUOp;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
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
    wire [31:0] instAddr;
    wire [3:0]  ALUInst = {inst[30],inst[14:12]};
    
    wire [31:0] ReadData;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] WriteData;
    
    
    wire [3:0] ALUControl;
    wire [31:0] ALUResult;
    
    
    
    
    wire IoRead;//等待Controller添加
    wire IoWrite;//等待Controller添加
    
    
    
    
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
    MemOrIO uMemOrIO(
        .mRead(MemRead),
        .mWrite(MemWrite),
        .ioRead(IoRead),
        .ioWrite(IoWrite),
        .addr_in(),
        .m_rdata(),
        .io_rdata({switchLeft,switchRight}),
        .r_rdata()
        );
    seg seg(
        .rst(rst),
        .in(),
        .en(),
        .clk(segClk),
        .segCtrl(segCtrl),
        .segCtrr(segCtrr),
        .chipSel(chipSel)
    );
   
endmodule
