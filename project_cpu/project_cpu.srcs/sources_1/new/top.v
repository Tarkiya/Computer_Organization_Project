module top(
    input clkIn,
    input rst,
    input [7:0] switchLeft,
    input [7:0] switchRight,
    input [4:0] button,
    output [7:0] ledLeft,
    output [7:0] ledRight,
    output [7:0] segCtrl,//����ѡ�ź�
    output [7:0] segCtrr,//�Ҳ��ѡ�ź�
    output [7:0] chipSel //����Ƭѡ�ź�
);
    // ʱ�ӵ�Ƶ
    /////////////////////////////////////////////////////////////
    wire cpuClk;//cpuʱ��
    wire segClk;//�������ʾʱ��
    clk_wiz_0 cpuclk1(
        .clk_in1(clkIn),
        .clk_out1(cpuClk)
    );
    segclk segclk1(
        .clk_in1(clkIn),
        .clk_out1(segClk)
    );
    
    // IFetch ģ��
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
    
    // Controller ģ��
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
    
    // Decoder ģ��
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
    
    // ALU ģ��
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
    
    // Memory ģ��
    /////////////////////////////////////////////////////////////
    m_data udata(
        .clk(cpuClk),
        .MemWrite(MemWrite),
        .addr(ALUResult),
        .din(ReadData2),
        .dout(m_rdata)
    );
    
    // IO ģ��
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
    
    // ��������
    /////////////////////////////////////////////////////////////
    
    
    // ���뿪������
    /////////////////////////////////////////////////////////////
    
    
    // �������ʾ
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
    
    // LED��ʾ
    /////////////////////////////////////////////////////////////
    
endmodule
