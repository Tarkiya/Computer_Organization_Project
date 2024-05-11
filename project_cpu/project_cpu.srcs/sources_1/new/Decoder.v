module Decoder(
    input clk,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input RegWrite, 
    input [31:0] WData,
    output [31:0] RData1,
    output [31:0] RData2
);
    reg [31:0] register[0:31];
    assign RData1 = register[rs1];
    assign RData2 = register[rs2];
    always @(posedge clk)
      begin
        if(RegWrite == 1'b1) register[rd] <= WData;
      end
endmodule
