module tb_top;
  reg clkIn;
  reg rst;
  reg [4:0] button;
  reg [7:0] switchLeft;
  reg [7:0] switchRight;
  wire [7:0] ledLeft;
  wire [7:0] ledRight;
  wire [7:0] segCtrl;
  wire [7:0] segCtrr;
  wire [7:0] chipSel;
  top uut (
    .clkIn(clkIn),
    .rst(rst),
    .button(button),
    .switchLeft(switchLeft),
    .switchRight(switchRight),
    .ledLeft(ledLeft),
    .ledRight(ledRight),
    .segCtrl(segCtrl),
    .segCtrr(segCtrr),
    .chipSel(chipSel)
  );
  initial begin
    clkIn = 0;
    forever #5000 clkIn = ~clkIn; // 100 MHz clock
  end
  initial begin
    rst = 0;
    button = 0;
    switchLeft = 0;
    switchRight = 0;
    #3000000 rst = 1;
    #1000000000 $finish;
  end

endmodule