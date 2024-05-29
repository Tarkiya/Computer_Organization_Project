module MemOrIO(
    input mRead,
    input mWrite,
    input ioRead,
    input ioWrite,
    input[31:0] addr_in,
    input[31:0] m_rdata,
    input[15:0] io_rdata,
    input[31:0] r_rdata,
    output[31:0] addr_out,
    output[31:0] r_wdata,
    output reg[31:0] write_data,
    output LEDCtrl,
    output SwitchCtrl
);
//    assign addr_out = addr_in;
//    assign LEDCtrl= £¿£¿£¿
//    assign SwitchCtrl= £¿£¿£¿
//    always @(*) begin
//        if((mWrite==1)||(ioWrite==1)) write_data = £¿£¿£¿
//        else write_data = 32'hZZZZZZZZ;
//    end
endmodule
