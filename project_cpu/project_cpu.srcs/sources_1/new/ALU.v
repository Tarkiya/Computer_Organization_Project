module ALU(
    input [31:0]readData1,
    input [31:0] readData2,
    input [31:0] imm,
    input ALUSrc,
    input [3:0] ALUControl,
    output reg [31:0] ALUResult,
    output reg zero
    );
    always@(*) begin
        //readdata1 and imm
        if(ALUSrc) begin
          case(ALUControl) 
            4'b0010: ALUResult=readData1+imm;
            4'b0110: begin
              ALUResult=readData1-imm;
              if (ALUResult==32'b0) begin
                zero=1'b1;
              end
            end
            4'b0000: ALUResult=readData1 & imm;
            4'b0001: ALUResult=readData1 | imm;
            default: ALUResult=1'b0;     
          endcase      
        end

        //readdata2 and readdata1
        else begin
          case(ALUControl) 
            4'b0010: ALUResult=readData1+readData2;
            4'b0110: begin
              ALUResult=readData1-readData2;
              if (ALUResult==32'b0) begin
                zero=1'b1;
              end
            end
            4'b0000: ALUResult=readData1 & readData2;
            4'b0001: ALUResult=readData1 | readData2;  
            default: ALUResult=1'b0;   
          endcase  
        end
    end
endmodule