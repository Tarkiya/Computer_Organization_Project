module ALU(
    input [31:0] ReadData1,
    input [31:0] ReadData2,
    input [31:0] imm32,
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    input ALUSrc,
    input blt,
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
              4'b0001: ALUControl=4'b1111;//����
              4'b0101: ALUControl=4'b1110;//�߼�����
              default: ALUControl=1'b0;
            endcase
          end
        endcase
      end
      
    always @(*) begin
        if(ALUSrc == 1'b0)ALUData = ReadData2;
        else ALUData = imm32;
      end
    
    always @(*) begin
          case(ALUControl) 
            4'b0010: ALUResult = ReadData1 + ALUData;
            4'b0110: ALUResult = ReadData1 - ALUData;
            4'b0000: ALUResult = ReadData1 & ALUData;
            4'b0001: ALUResult = ReadData1 | ALUData;  
            4'b1111: ALUResult = ReadData1 << ALUData;  
            4'b1110: ALUResult = ReadData1 >> ALUData;  
            default: ALUResult = 1'b0;
          endcase
      end
    
    always @(*) begin
        if (ALUResult == 32'b0|| nBranch && ALUResult != 32'b0|| blt && ALUResult<0) zero = 1'b1;
        else zero = 1'b0;
    end
endmodule