module Decoder(
    input clk,rst,
    input ecall,
    input regWrite,
    input [31:0] inst,
    input [31:0] writeData,
    output [31:0] rs1Data,
    output [31:0] rs2Data,
    output reg [31:0] imm32
);
    integer i;
    reg [31:0] register[0:31];
    wire [6:0] opcode;
//    reg [4:0] rs1;
//    reg [4:0] rs2;
//    reg [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    
    assign opcode = inst[6:0];
    assign rs1 = (inst[31:0] == 32'h00000073) ? 5'b10001 : inst[24:20];
    assign rs2 = (inst[31:0] == 32'h00000073) ? 5'b01010 : inst[19:15];
    assign rd = (inst[31:0] == 32'h00000073) ? 5'b01010 : inst[11:7];
//    always @(*) begin
//        if(inst[31:0] == 32'h00000073) begin
//            rs1 = 5'b10001;
//            rs2 = 5'b01010;
//            if(register[17][4:0] == 4'b0001) rd = 5'bZZZZZ;
//            else rd  = 5'b01010;
//        end
//        else begin
//            rs1 = inst[24:20];
//            rs2 = inst[19:15];
//            rd  = inst[11:7];
//        end
//    end
    
    always @(*) 
      begin
        if(rst)
          begin
            case(opcode)
                7'b0110011: imm32 = 1'b0; // R-type
                7'b0010011,
                7'b0000011: imm32 = { {20{inst[31]}}, inst[31:20] }; // I-type
                7'b0100011: imm32 = { {20{inst[31]}}, inst[31:25], inst[11:7]}; // S-type 
                7'b1100011: imm32 = { {19{inst[31]}}, inst[31],inst[7],inst[30:25],inst[11:8],1'b0 }; // B-type
                7'b0110111,
                7'b0010111: imm32 = { {12{inst[31]}}, inst[31:12] }; // U-type
                7'b1101111: imm32 = { {11{inst[31]}}, inst[31],inst[19:12] ,inst[20],inst[30:21],1'b0}; // J-type
                default: imm32 = 32'b0; // default value
              endcase
            end
          end
    
    assign rs1Data = register[rs1];
    assign rs2Data = register[rs2];
    
    always @(posedge clk) begin
        if(~rst) begin
            for(i=0;i<32;i=i+1)begin
                register[i]<=1'b0;
            end
          end
        else 
          begin
//            rs1Data <= register[rs1];
//            rs2Data <= register[rs2];
            if(regWrite && rd!=0) register[rd] <= writeData;
          end
      end
endmodule