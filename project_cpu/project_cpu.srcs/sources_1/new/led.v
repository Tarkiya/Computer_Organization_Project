module led(
    input rst,
    input [15:0] in,
    input en,
    output reg [7:0] ledLeft,
    output reg [7:0] ledRight
    );
    always @(*) begin
        if(~rst) begin
            ledLeft = 7'b0000000;
            ledRight = 7'b000000;
        end
        else if(en == 1'b1) begin
            ledLeft = in[15:8];
            ledRight = in[7:0];
        end
        else begin
            ledLeft = ledLeft;
            ledRight = ledRight;
        end
    end
endmodule
