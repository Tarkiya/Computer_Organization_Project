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
    wire Ecall;
    wire Branch;
    wire nBranch;
    IFetch uIFetch(
        .clk(cpuClk),
        .rst(rst),
        .imm32(imm32),
        .zero(zero),
        .Ecall(Ecall),
        .Branch(Branch),
        .nBranch(nBranch),
        .inst(inst)
    );
    
    // Controller 模块
    /////////////////////////////////////////////////////////////
    wire [31:0] ALUResult;
    wire [1:0] ALUOp;
    wire ALUSrc;
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire MemtoReg;
    wire MemorIOtoReg;
    wire IORead;
    wire IOWrite;
    Controller uContrl (
        .inst(inst),
        .Alu_resultHigh(ALUResult[31:10]),
        .button(button),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Ecall(Ecall),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .nBranch(nBranch),
        .MemtoReg(MemtoReg),  
        .MemorIOtoReg(MemorIOtoReg),
        .IORead(IORead),
        .IOWrite(IOWrite)
    );
    
    // Decoder 模块
    /////////////////////////////////////////////////////////////
//    wire [31:0] WriteData;
    wire [31:0] m_rdata;
    wire [31:0] m_wdata;
    wire [31:0] r_wdata;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    Decoder uDecoder(
        .clk(cpuClk),
        .rst(rst),
        .inst(inst),
        .regWrite(RegWrite),
        .writeData(r_wdata),
        .rs1Data(ReadData1),
        .rs2Data(ReadData2),
        .imm32(imm32)
    );
    
    // ALU 模块
    /////////////////////////////////////////////////////////////
    ALU uAlu(
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
    
    // Memory 模块
    /////////////////////////////////////////////////////////////
    m_data udata(
        .clk(cpuClk),
        .MemWrite(MemWrite),
        .addr(ALUResult),
        .din(ReadData2),
        .dout(m_rdata)
    );
    
    // IO 模块
    /////////////////////////////////////////////////////////////
    wire LEDCtrl;
    wire SwitchCtrl;
    MemOrIO uMemOrIO(
        .mRead(MemRead),
        .mWrite(MemWrite),
        .ioRead(IORead),
        .ioWrite(IOWrite),
        .addr_in(ALUResult),
        .m_rdata(m_rdata),
        .r_rdata(ReadData2),
        .io_rdata({switchLeft,switchRight}),
        .m_wdata(m_wdata),
        .r_wdata(r_wdata),
        .io_wdata({ledLeft,ledRight}),
        .LEDCtrl(LEDCtrl),
        .SwitchCtrl(SwitchCtrl)
    );
    
    // 按键消抖
    /////////////////////////////////////////////////////////////
    
    
    // 拨码开关输入
    /////////////////////////////////////////////////////////////
    
    
    // 数码管显示
    /////////////////////////////////////////////////////////////
    seg seg(
        .rst(rst),
        .in({{16{ledLeft[7]}},ledLeft,ledRight}),
        .en(LEDCtrl),
        .clk(segClk),
        .segCtrl(segCtrl),
        .segCtrr(segCtrr),
        .chipSel(chipSel)
    );
    
    // LED显示
    /////////////////////////////////////////////////////////////
    
endmodule
