// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module top(clkIn, rst, button, switchLeft, switchRight, 
  ledLeft, ledRight, segCtrl, segCtrr, chipSel);
  input clkIn;
  input rst;
  input [4:0]button;
  input [7:0]switchLeft;
  input [7:0]switchRight;
  output [7:0]ledLeft;
  output [7:0]ledRight;
  output [7:0]segCtrl;
  output [7:0]segCtrr;
  output [7:0]chipSel;
endmodule
