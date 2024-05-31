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
    output Branch,nBranch,// Ϊ 1 ������Beq,Bneָ��
    output MemorIOtoReg,  // Ϊ 1 ������Ҫ�Ӵ洢���� I/O �����ݵ��Ĵ��� 
    output IORead,        // Ϊ 1 ������ I/O �� 
    output IOWrite        // Ϊ 1 ������ I/O д 
);
    wire Lw;// Ϊ 1 ��ʾ��lwָ��
    wire Sw;// Ϊ 1 ��ʾ��swָ��
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