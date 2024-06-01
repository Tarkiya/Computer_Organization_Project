module tb_top();
reg clk;
reg [15:0] addr;
wire [31:0] dout;

inst_memory uinst(
    .clka(clk),
    .addra(addr>>2),
    .douta(dout)
);

initial begin
    clk = 1'b0;
    forever #4 clk = ~clk;
end

initial begin
    addr = 14'h0;
    repeat(16) #8 addr = addr + 4 ;
    #4 $finish;
end

endmodule
