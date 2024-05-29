module m_data(
    input clk,
    input MemRead,
    input MemWrite,
    input MemtoReg,
    input [31:0] ALUResult,
    input [31:0] din,
    output reg [31:0] dout
);
    wire [31:0] readData;
    data_memory udata(
        .clka(clk),
        .wea(MemWrite),
        .addra(ALUResult[13:0]),
        .dina(din),
        .douta(readData)
    );
    always @(*)
      begin
        if(MemtoReg==1'b0) dout = ALUResult;
        else dout = readData;
      end
endmodule