module clock_div(
    input clk,
    output reg clk_2ms,
    output reg clk_20ms
    );

    reg [31:0] cnt_2ms=0;
    reg [31:0] cnt_20ms=0;

    always@(posedge clk)//2ms
      begin
        if(cnt_2ms==31'd100000)
        begin
          clk_2ms<=~clk_2ms;
          cnt_2ms<=0;
        end
      else cnt_2ms<=cnt_2ms+1;
      end

    always@(posedge clk)//20ms
      begin
        if(cnt_20ms==31'd1000000)
          begin
            clk_20ms<=~clk_20ms;
            cnt_20ms<=0;
          end
        else cnt_20ms<=cnt_20ms+1;
      end

endmodule