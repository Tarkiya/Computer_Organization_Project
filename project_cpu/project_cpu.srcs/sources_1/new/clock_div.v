module clock_div(
    input clk,
    output reg clk_2ms
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

endmodule