module ALU(
    input signed [31:0] ReadData1,
    input signed [31:0] ReadData2,
    input [31:0] imm32,
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    input ALUSrc,
    input blt,
    input bge,
    input bltu,
    input bgeu,
    input nBranch,
    output reg [31:0] ALUResult,
    output reg zero
    );
    reg [3:0] ALUControl;
    reg [31:0] ALUData;
        
    always@(*) begin
        case (ALUOp)
          2'b00: ALUControl=4'b0010;
          2'b01: ALUControl=4'b0110;
          2'b10: begin
            case ({funct7[5],funct3[2:0]})
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
            ALUData = imm32;
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
        if (bltu) 
            zero = ($unsigned(ReadData1) < $unsigned(ALUData));
        else if (bgeu) 
            zero = ($unsigned(ReadData1) >= $unsigned(ALUData));
        else if (blt) 
            zero = (ReadData1 < ALUData);
        else if (bge) 
            zero = (ReadData1 >= ALUData);
        else if (nBranch) 
            zero = (ALUResult != 32'b0);
        else 
            zero = (ALUResult == 32'b0);
    end
endmodule
