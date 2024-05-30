module seg(
    input [31:0] in,
    input en,
    input clk,
    output reg [7:0] seg_ctrl,
    output reg [7:0] seg_ctrr,
    output reg [7:0] chip_sel
);
reg[2:0]count=3'b000;
reg [3:0] curdata=4'b0;
    always @(posedge clk) begin
        //数码管上显示数据
        if (en) begin
            case(count)
                3'b000:begin
                    count<=count+1;
                    chip_sel<=8'b0000_0001;
                    curdata<=in[3:0];
                end
                3'b001:begin
                    count<=count+1;
                    chip_sel<=8'b0000_0010;
                    curdata<=in[7:4];
                end
                3'b010:begin
                    count<=count+1;
                    chip_sel<=8'b0000_0100;
                    curdata<=in[11:8];
                end
                3'b011:begin
                    count<=count+1;
                    chip_sel<=8'b0000_1000;
                    curdata<=in[15:12];
                end
                3'b100:begin
                    count<=count+1;
                    chip_sel<=8'b0001_0000;
                    curdata<=in[19:16];
                end
                3'b101:begin
                    count<=count+1;
                    chip_sel<=8'b0010_0000;
                    curdata<=in[23:20];
                end
                3'b110:begin
                    count<=count+1;
                    chip_sel<=8'b0100_0000;
                    curdata<=in[27:24];
                end
                3'b111:begin
                    count<=1'b0;
                    chip_sel<=8'b1000_0000;
                    curdata<=in[31:28];
                end
                default:begin
                    count<=1'b0;
                    chip_sel<=1'b0;
                end
            endcase
        end
        //使能信号不为1，数码管上不能有显示
        else begin
            chip_sel=1'b0;
        end
    end

    always @(chip_sel) begin
        if (chip_sel==8'b0000_0001||chip_sel==8'b0000_0010||chip_sel==8'b0000_0100||chip_sel==8'b0000_1000) begin
            case (curdata)
                4'b0000:seg_ctrr=8'b1111_1100;//0
                4'b0001:seg_ctrr=8'b0110_0000;//1
                4'b0010:seg_ctrr=8'b1101_1010;//2
                4'b0011:seg_ctrr=8'b1111_0010;//3
                4'b0100:seg_ctrr=8'b0110_0110;//4
                4'b0101:seg_ctrr=8'b1011_0110;//5
                4'b0110:seg_ctrr=8'b1011_1110;//6
                4'b0111:seg_ctrr=8'b1110_0000;//7
                4'b1000:seg_ctrr=8'b1111_1110;//8
                4'b1001:seg_ctrr=8'b1111_0110;//9
                4'b1010:seg_ctrr=8'b1110_1110;//A
                4'b1011:seg_ctrr=8'b1111_1110;//B
                4'b1100:seg_ctrr=8'b1001_1100;//C
                4'b1010:seg_ctrr=8'b0111_1010;//d
                4'b1010:seg_ctrr=8'b1001_1110;//E
                default:seg_ctrr=8'b1111_1111;
            endcase
        end
        else if (chip_sel==8'b0001_0000||chip_sel==8'b0010_0000||chip_sel==8'b0100_0000||chip_sel==8'b1000_0000) begin
            case (curdata)
                4'b0000:seg_ctrl=8'b1111_1100;//0
                4'b0001:seg_ctrl=8'b0110_0000;//1
                4'b0010:seg_ctrl=8'b1101_1010;//2
                4'b0011:seg_ctrl=8'b1111_0010;//3
                4'b0100:seg_ctrl=8'b0110_0110;//4
                4'b0101:seg_ctrl=8'b1011_0110;//5
                4'b0110:seg_ctrr=8'b1011_1110;//6
                4'b0111:seg_ctrl=8'b1110_0000;//7
                4'b1000:seg_ctrl=8'b1111_1110;//8
                4'b1001:seg_ctrl=8'b1111_0110;//9
                4'b1010:seg_ctrl=8'b1110_1110;//A
                4'b1011:seg_ctrl=8'b1111_1110;//B
                4'b1100:seg_ctrl=8'b1001_1100;//C
                4'b1010:seg_ctrl=8'b0111_1010;//d
                4'b1010:seg_ctrl=8'b1001_1110;//E
                default:seg_ctrl=8'b1111_1111;
            endcase
        end
    end
endmodule