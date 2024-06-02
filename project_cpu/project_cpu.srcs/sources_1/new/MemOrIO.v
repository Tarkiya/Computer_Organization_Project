module MemOrIO(
    input mRead,
    input mWrite,
    input ioRead,
    input ioWrite,
    input memIOtoReg,
    input Lb,
    input Lbu,

    input [31:0] alu_data,
    input [31:0] m_rdata,
    input [31:0] r_rdata,
    input [31:0] io_rdataswitchesleft,
    input [31:0] io_rdataswitchesright,
    input [31:0] io_rdatabuttons,
    input [7:0] address,
    
    output reg [31:0] m_wdata,
    output reg [31:0] r_wdata,
    output reg [31:0] io_wdata,
    
    output LEDCtrl,
    output SwitchCtrl
);
    
    // 从 memory 或 IO 读入数据，写入寄存器
    always @(*) begin
        if(memIOtoReg == 1'b0) begin
            r_wdata = alu_data;
        end
        else begin
            if(mRead == 1'b1) begin  
                r_wdata = m_rdata;  
            end  
            else if(ioRead == 1'b1) begin
                if(Lb == 1'b1) begin
                    if(address[5:2]==4'b0) begin
                        r_wdata = {{24{io_rdataswitchesleft[7]}},io_rdataswitchesleft[7:0]};
                    end
                    else if(address[5:2]==4'b1) begin
                        r_wdata = {{24{io_rdataswitchesright[7]}},io_rdataswitchesright[7:0]};
                    end
                    else if(address[5:2]==4'b10) begin
                        r_wdata = {{27{io_rdatabuttons[4]}},io_rdatabuttons[4:0]};
                    end
                end
                else if (Lbu == 1'b1) begin
                    if(address[5:2]==4'b0) begin
                            r_wdata = {{24{1'b0}},io_rdataswitchesleft[7:0]};
                    end
                    else if(address[5:2]==4'b1) begin
                        r_wdata = {{24{1'b0}},io_rdataswitchesright[7:0]};
                    end
                    else if(address[5:2]==4'b10) begin
                        r_wdata = {{27{1'b0}},io_rdatabuttons[4:0]};
                    end
                end
                else begin//load word
                    if(address[5:2]==4'b0) begin
                        r_wdata = {{24{io_rdataswitchesleft[7]}},io_rdataswitchesleft[7:0]};
                    end
                    else if(address[5:2]==4'b1) begin
                        r_wdata = {{24{io_rdataswitchesright[7]}},io_rdataswitchesright[7:0]};
                    end
                    else if(address[5:2]==4'b10) begin
                        r_wdata = io_rdatabuttons;
                    end
                end
            end  
        end
    end
    
    assign LEDCtrl = ioWrite;
    assign SwitchCtrl = ioRead;
    
    // 从寄存器读入数据，写入 memory 或者 io
    always @(*) begin
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
endmodule
