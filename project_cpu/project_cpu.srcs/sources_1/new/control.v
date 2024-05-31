module Controller (
    input [31:0] inst,
    input [21:0] Alu_resultHigh,
    input [4:0] button,
    output reg [1:0]ALUOp,
    output reg ALUSrc,
    output reg RegWrite,
    output Ecall,
    output MemRead,
    output MemWrite,
    output Branch,nBranch,// 为 1 表明是Beq,Bne指令
    output MemorIOtoReg,  // 为 1 表明需要从存储器或 I/O 读数据到寄存器 
    output IORead,        // 为 1 表明是 I/O 读 
    output IOWrite        // 为 1 表明是 I/O 写 
);
    wire Lw;// 为 1 表示是lw指令
    wire Sw;// 为 1 表示是sw指令
    assign Branch = (inst[6:0] == 7'b1100011 && inst[14:12] == 3'b0);
    assign nBranch = (inst[6:0] == 7'b1100011 && inst[14:12] == 3'b1);
    assign Lw = (inst[6:0] == 7'b0010011 && inst[14:12] == 3'b10);
    assign Sw = (inst[6:0] == 7'b0100011);
    assign Ecall = (button[0]==1'b0 && inst[31:0] == 32'h00000073);
    assign MemRead  = (inst[6:0] == 7'b0010011);
    assign MemWrite = ((Sw == 1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0;
    assign MemorIOtoReg = (IORead || MemRead);
    assign IORead = (Lw && Alu_resultHigh[21:0] == 22'h3FFFFF);
    assign IOWrite = (Sw && Alu_resultHigh[21:0] == 22'h3FFFFF);

always @* begin
    case(inst[6:0])
        7'b1100011:
            begin
            ALUOp = 2'b01;
            ALUSrc = 1'b0;
            RegWrite = 1'b0; //B bne
            end
        7'b0110011: 
            begin
            ALUOp = 2'b10;
            ALUSrc = 1'b0;
            RegWrite = 1'b1; //R add
            end
        7'b0010011: 
            begin
            ALUOp = 2'b00; 
            ALUSrc = 1'b1; 
            RegWrite = 1'b1; //I addi
            end
        7'b0000011:
            begin
            ALUOp = 2'b00;
            ALUSrc = 1'b1;
            RegWrite = 1'b1; //I lw
            end
        7'b0100011: 
            begin
            ALUOp = 2'b00;
            ALUSrc = 1'b1;
            RegWrite = 1'b0; //S sw
            end
        7'b0110111: 
            begin
            ALUOp = 2'b00;
            ALUSrc = 1'b0;
            RegWrite = 1'b1; //U lui
            end
        7'b1101111: 
            begin
            ALUOp = 2'b00;
            ALUSrc = 1'b0;
            RegWrite = 1'b1; //J jal
            end
        default:
            begin
            ALUOp = 2'b00;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            end
    endcase
end

endmodule