module control (
    input [31:0] inst,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
);

always @* begin
    case(inst[6:0])
        7'b1100011: 
            begin
            Branch = 1'b1; 
            MemRead = 1'b0; 
            MemtoReg = 1'b0; 
            ALUOp = 2'b01; 
            MemWrite = 1'b0; 
            ALUSrc = 1'b0; 
            RegWrite = 1'b0; //B  bne
            end
        7'b0110011: 
            begin
            Branch = 1'b0; 
            MemRead = 1'b0; 
            MemtoReg = 1'b0; 
            ALUOp = 2'b10; 
            MemWrite = 1'b0; 
            ALUSrc = 1'b0; 
            RegWrite = 1'b1; //R  add
            end
        7'b0010011: 
            begin
            Branch = 1'b0; 
            MemRead = 1'b1; 
            MemtoReg = 1'b1; 
            ALUOp = 2'b00; 
            MemWrite = 1'b0; 
            ALUSrc = 1'b1; 
            RegWrite = 1'b1; //I   lw  addi
            end
        7'b0100011: 
            begin
            Branch = 1'b0; 
            MemRead = 1'b0; 
            MemtoReg = 1'b1; 
            ALUOp = 2'b00; 
            MemWrite = 1'b1; 
            ALUSrc = 1'b1; 
            RegWrite = 1'b0; //S   sw
            end
        7'b0110111: 
            begin
            Branch = 1'b0; 
            MemRead = 1'b0; 
            MemtoReg = 1'b0; 
            ALUOp = 2'b00; 
            MemWrite = 1'b0; 
            ALUSrc = 1'b0; 
            RegWrite = 1'b1; //U   lui
            end
        7'b1101111: 
            begin
            Branch = 1'b1; 
            MemRead = 1'b0; 
            MemtoReg = 1'b0; 
            ALUOp = 2'b00; 
            MemWrite = 1'b0; 
            ALUSrc = 1'b0; 
            RegWrite = 1'b1; //J   jal
            end
        default:
            begin
            Branch = 1'b1; 
            MemRead = 1'b0; 
            MemtoReg = 1'b0; 
            ALUOp = 2'b00; 
            MemWrite = 1'b0; 
            ALUSrc = 1'b0; 
            RegWrite = 1'b1; //J   jal
            end
    endcase
end

endmodule