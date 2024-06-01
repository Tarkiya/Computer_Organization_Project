module MemOrIO(
    input ecall,
    input mRead,
    input mWrite,
    input ioRead,
    input ioWrite,
    input Lb,
    
    input [31:0] alu_data,
    input [31:0] m_rdata,
    input [31:0] r_rdata,
    input [31:0] io_rdata,
    
    output reg [31:0] m_wdata,
    output reg [31:0] r_wdata,
    output reg [31:0] io_wdata,
    
    output LEDCtrl,
    output SwitchCtrl
);
    
    // lw 指令，从 memory 或 IO 读入数据，写入寄存器
    always @(*) begin
        if(ecall == 1'b1) begin
            case(alu_data[3:0])
                4'b0101: r_wdata = io_rdata;
            endcase
        end
        else begin  
            if(mRead) begin  
                r_wdata = m_rdata;  
            end  
            else if(ioRead && ~Lb) begin  
                r_wdata = io_rdata;  
            end  
            else if(ioRead && Lb) begin 
                r_wdata = {{24{1'b0}}, io_rdata[15:8]};  
            end  
        end
    end
    
    assign LEDCtrl = ioWrite;
    assign SwitchCtrl = ioRead;
    
    // sw 指令，从寄存器读入数据，写入 memory 或者 io
    always @(*) begin
        if(ecall == 1'b1) begin
            case(alu_data[3:0])
                4'b0001: io_wdata = r_rdata;
//                4'b0010:
            endcase
        end
        else begin
            if(mWrite == 1'b1) begin 
                m_wdata = r_rdata;
            end
            else if(ioWrite == 1'b1) begin
                io_wdata = r_rdata;
            end
            else begin
                m_wdata = 32'hZZZZZZZZ;
                io_wdata = 32'hZZZZZZZZ;
            end
        end
    end
endmodule
