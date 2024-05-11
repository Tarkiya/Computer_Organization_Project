module MUX2(
    input MemtoReg,
    input [31:0] RData,
    input [31:0] ALUResult,
    output reg [31:0] WData
);
    always @(*)
      begin
        if(MemtoReg == 1'b0)WData = ALUResult;
        else WData = RData;
      end
endmodule
