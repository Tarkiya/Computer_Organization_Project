module ALU(
    input [31:0] RData1,
    input [31:0] ALUData,
    input [3:0] ALUControl,
    output reg [31:0] ALUResult,
    output reg zero
    );
    always @(*)
      begin
          case(ALUControl) 
            4'b0010: ALUResult = RData1 + ALUData;
            4'b0110: 
              begin
                ALUResult = RData1 - ALUData;
                if (ALUResult == 32'b0)zero=1'b1;
              end
            4'b0000: ALUResult = RData1 & ALUData;
            4'b0001: ALUResult = RData1 | ALUData;  
            default: ALUResult = 1'b0;   
          endcase
      end
endmodule