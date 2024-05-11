module MUX1(
    input ALUSrc,
    input [31:0] RData2,
    input [31:0] immediate,
    output reg [31:0] ALUData
);
    always @(*)
      begin
        if(ALUSrc == 1'b0)ALUData = RData2;
        else ALUData = immediate;
      end
endmodule
