module m_data(
    input clk,
    input rst,
    input MemWrite,
    input [31:0] inst,
    input [31:0] addr,
    input [31:0] din,
    output [31:0] dout
);
    reg MemWriteonce=1'b1;
    always @(posedge clk) begin
        if(inst==32'h73) begin
            if(MemWriteonce) MemWriteonce<=1'b0;
        end
        else begin
            MemWriteonce<=1'b1;
        end
    end
    data_memory udata(
        .clka(~clk),
        .wea(MemWrite&&MemWriteonce),
        .addra(addr[15:2]),
        .dina(din),
        .douta(dout)
    );
endmodule