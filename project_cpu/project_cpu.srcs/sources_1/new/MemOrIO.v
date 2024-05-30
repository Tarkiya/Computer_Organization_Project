module MemOrIO(
    input mRead,
    input mWrite,
    input ioRead,
    input ioWrite,
    
    input [31:0] addr_in,
    input [31:0] m_rdata,
    input [31:0] r_rdata,
    input [15:0] io_rdata
    ,
    output [31:0] addr_out,
    
    output reg [31:0] r_wdata,
    output reg [31:0] m_wdata,
    output reg [31:0] io_wdata,
    
    output LEDCtrl,
    output SwitchCtrl
);
    assign addr_out = addr_in;
    
    // lw ָ��� memory �� IO �������ݣ�д��Ĵ���
    always @(*) begin
        if(mRead == 1'b1) begin
            r_wdata = m_rdata;
        end
        else if(ioRead == 1'b1) begin
            r_wdata = {{16{1'b0}},io_rdata};
        end
    end
    
    assign LEDCtrl = ioWrite;
    assign SwitchCtrl = ioRead;
    
    // sw ָ��ӼĴ����������ݣ�д�� memory ���� io
    always @(*) begin
        if(mWrite == 1'b1) begin 
            m_wdata = r_rdata;
        end
        else if(ioWrite == 1'b1) begin
            io_wdata = r_rdata[15:0];
        end
        else begin
            m_wdata = 32'hZZZZZZZZ;
            io_wdata = 16'hZZZZ;
        end
    end
endmodule
