module m_inst(clk,addr,dout);
    input clk;
    input [13:0] addr;
    output [31:0] dout;
    inst_memory inst_rom(.clka(clk),.addra(addr),.douta(dout));
endmodule
