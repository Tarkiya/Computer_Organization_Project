module tb_top;
  reg clkIn;
  reg rst;
  reg [4:0] button;
  reg [15:0] switch;
  wire [15:0] led;
  top uut (
    .clkIn(clkIn),
    .rst(rst),
    .button(button),
    .switchLeft(switch[15:8]),
    .switchRight(switch[7:0]),
    .ledLeft(led[15:8]),
    .ledRight(led[7:0])
  );
  initial begin
      clkIn = 0;
      forever #5000 clkIn = ~clkIn; // 100 MHz clock
    end
  initial begin
    rst = 0;
    button = 5'b00000;
    switch = 16'hff0f;
    #3000000 rst = 1;
    #220000 button = 5'b00001;
    #50000 button = 5'b00000;
    #100000 switch = 16'habcd;
    #1000000 button = 5'b00001;
    #1000000 button = 5'b00000;
    #1000000000 $finish;
  end

endmodule