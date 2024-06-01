module switch(
    input en,
    input [7:0] switchLeft,
    input [7:0] switchRight,
    output reg [31:0] io_rdata
    );
    always @(*) begin
        if(en == 1'b1) begin
            io_rdata = {{16{switchLeft[7]}},switchLeft,switchRight};
        end
    end
endmodule
