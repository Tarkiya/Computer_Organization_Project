module top(
    input clkIn,
    input rst,
    input [4:0] button,
    input [7:0] switchLeft,
    input [7:0] switchRight,
    output [7:0] ledLeft,
    output [7:0] ledRight,
    output [7:0] segCtrl,//左侧段选信号
    output [7:0] segCtrr,//右侧段选信号
    output [7:0] chipSel //所有片选信号
);
    // 时钟调频
    /////////////////////////////////////////////////////////////
    wire [4:0] debutton;
    wire cpuClk;//cpu时钟
    wire deClk;//消抖时钟
    wire segClk;//数码管显示时钟
    clk_wiz_0 cpuclk1(
        .clk_in1(clkIn),
        .clk_out1(cpuClk)
    );
    clock_div slowclk(
        .clk_2ms(segClk),
        .clk_20ms(deClk)
    );
    
    // IFetch 模块
    /////////////////////////////////////////////////////////////
    wire [31:0] imm32;
    wire [31:0] inst;
    wire Result;
    wire Ecall;
    wire Branch,nBranch,Blt,Bge,Bltu,Bgeu;
    wire Lb;
    IFetch uIFetch(
        .clk(cpuClk),
        .rst(rst),
        .imm32(imm32),
        .Result(Result),
        .Ecall(Ecall),
        .Branch(Branch),
        .nBranch(nBranch),
        .Blt(Blt),
        .Bge(Bge),
        .Bltu(Bltu),
        .Bgeu(Bgeu),
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
    wire MemorIOtoReg;
    wire IORead;
    wire IOWrite;
    Controller uContrl (
        .inst(inst),
        .Alu_ResultHigh(ALUResult[31:10]),
        .button(debutton),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Ecall(Ecall),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .nBranch(nBranch),
        .Blt(Blt),
        .Bge(Bge),
        .Bltu(Bltu),
        .Bgeu(Bgeu),
        .Lb(Lb),
        .MemorIOtoReg(MemorIOtoReg),
        .IORead(IORead),
        .IOWrite(IOWrite)
    );
    
    // Decoder 模块
    /////////////////////////////////////////////////////////////
    wire [31:0] m_rdata;
    wire [31:0] m_wdata;
    wire [31:0] r_wdata;
    wire [31:0] io_rdata;
    wire [31:0] io_wdata;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    Decoder uDecoder(
        .clk(cpuClk),
        .rst(rst),
        .ecall(Ecall),
        .regWrite(RegWrite),
        .inst(inst),
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
        .Branch(Branch),
        .nBranch(nBranch),
        .Blt(Blt),
        .Bge(Bge),
        .Bltu(Bltu),
        .Bgeu(Bgeu),
        .ALUResult(ALUResult),
        .Result(Result)
    );
    
    // Memory 模块
    /////////////////////////////////////////////////////////////
    m_data udata(
        .clk(cpuClk),
        .rst(rst),
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
        .ecall(Ecall),
        .mRead(MemRead),
        .mWrite(MemWrite),
        .ioRead(IORead),
        .ioWrite(IOWrite),
        .Lb(Lb),
        .alu_data(ALUResult),
        .m_rdata(m_rdata),
        .r_rdata(ReadData2),
        .io_rdata(io_rdata),
        .m_wdata(m_wdata),
        .r_wdata(r_wdata),
        .io_wdata(io_wdata),
        .LEDCtrl(LEDCtrl),
        .SwitchCtrl(SwitchCtrl)
    );
    
    // 按键消抖
    /////////////////////////////////////////////////////////////
    debouncer debouncer0(
        .slowclk(deClk),
        .button(button[0]),
        .signal(debutton[0])
    );
    debouncer debouncer1(
        .slowclk(deClk),
        .button(button[1]),
        .signal(debutton[1])
    );
    debouncer debouncer2(
        .slowclk(deClk),
        .button(button[2]),
        .signal(debutton[2])
    );
    debouncer debouncer3(
        .slowclk(deClk),
        .button(button[3]),
        .signal(debutton[3])
    );
    debouncer debouncer4(
        .slowclk(deClk),
        .button(button[4]),
        .signal(debutton[4])
    );
    
    // switch输入
    /////////////////////////////////////////////////////////////
    switch uswitch(
        .en(SwitchCtrl),
        .switchLeft(switchLeft),
        .switchRight(switchRight),
        .io_rdata(io_rdata)
    );
    
    // 数码管显示
    /////////////////////////////////////////////////////////////
    seg useg(
        .rst(rst),
        .in(io_wdata),
        .en(LEDCtrl),
        .clk(segClk),
        .seg_ctrl(segCtrl),
        .seg_ctrr(segCtrr),
        .chip_sel(chipSel)
    );
    
    // LED显示
    /////////////////////////////////////////////////////////////
    led uled(
        .rst(rst),
        .in(io_wdata[15:0]),
        .en(LEDCtrl),
        .ledLeft(ledLeft),
        .ledRight(ledRight)
    );
endmodule
