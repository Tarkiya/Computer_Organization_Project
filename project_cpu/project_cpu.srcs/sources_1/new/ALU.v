module ALU(
    input signed [31:0] ReadData1,
    input signed [31:0] ReadData2,
    input [31:0] Imm32,
    input [1:0] ALUOp,
    input [2:0] Funct3,
    input [6:0] Funct7,
    input ALUSrc,
    input Branch,nBranch,Blt,Bge,Bltu,Bgeu,
    output reg [31:0] ALUResult,
    output reg Result
    );
    reg [3:0] ALUControl;
    reg [31:0] ALUData;
        
    always@(*) begin
        case (ALUOp)
          2'b00: ALUControl=4'b0010;
          2'b01: ALUControl=4'b0110;
          2'b10: begin
            case ({Funct7[5],Funct3[2:0]})
              4'b0000: ALUControl=4'b0010;
              4'b1000: ALUControl=4'b0110;
              4'b0111: ALUControl=4'b0000;
              4'b0110: ALUControl=4'b0001; 
              4'b0001: ALUControl=4'b1111; // SLL
              4'b0101: ALUControl=4'b1110; // SRL
              default: ALUControl=4'b0000;
            endcase
          end
          default: ALUControl=4'b0000;
        endcase
      end
      
    always @(*) begin
        if(ALUSrc == 1'b0) 
            ALUData = ReadData2;
        else 
            ALUData = Imm32;
    end
    
    always @(*) begin
        case(ALUControl) 
            4'b0010: ALUResult = ReadData1 + ALUData;
            4'b0110: ALUResult = ReadData1 - ALUData;
            4'b0000: ALUResult = ReadData1 & ALUData;
            4'b0001: ALUResult = ReadData1 | ALUData;  
            4'b1111: ALUResult = ReadData1 << ALUData;  
            4'b1110: ALUResult = ReadData1 >> ALUData;  
            default: ALUResult = 32'b0;
        endcase
    end
    
    always @(*) begin
        if (Bltu) 
            Result = ($unsigned(ReadData1) < $unsigned(ALUData));
        else if (Bgeu) 
            Result = ($unsigned(ReadData1) >= $unsigned(ALUData));
        else if (Blt) 
            Result = (ReadData1 < ALUData);
        else if (Bge) 
            Result = (ReadData1 >= ALUData);
        else if (nBranch) 
            Result = (ALUResult != 32'b0);
        else if (Branch)
            Result = (ALUResult == 32'b0);
    end
endmodule
