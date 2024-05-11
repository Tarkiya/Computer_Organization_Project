module m_data(clk,MemRead,MemWrite,addr,din,dout);
input clk;
input MemRead,MemWrite;
input [31:0] addr;
input [31:0] din;
output [31:0] dout;
data_memory data_memory(.clka(clk),.wea(MemWrite),.addra(addr[13:0]),.dina(din),.douta(dout));
endmodule
