module ALUControlPort (
  input [1:0] ALUOp,
  input [3:0] instruction,
  output reg [3:0] ALUControl
);
  always@(*) begin
    case (ALUOp)
      2'b00: ALUControl=4'b0010;
      2'b01: ALUControl=4'b0110;
      2'b10: begin
        case (instruction)
          4'b0000: ALUControl=4'b0010;
          4'b1000: ALUControl=4'b0110;
          4'b0111: ALUControl=4'b0000;
          4'b0110: ALUControl=4'b0001; 
          default: ALUControl=1'b0;
        endcase
      end
    endcase
  end
endmodule