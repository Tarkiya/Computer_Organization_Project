module m_data(
    input clk,
    input rst,
    input MemWrite,
    input [31:0] addr,
    input [31:0] din,
    output [31:0] dout
);
    data_memory udata(
        .clka(~clk),
        .wea(MemWrite),
        .addra(addr[15:2]),
        .dina(din),
        .douta(dout)
    );
endmodule