-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
  Port ( 
    clkIn : in STD_LOGIC;
    rst : in STD_LOGIC;
    button : in STD_LOGIC_VECTOR ( 4 downto 0 );
    switchLeft : in STD_LOGIC_VECTOR ( 7 downto 0 );
    switchRight : in STD_LOGIC_VECTOR ( 7 downto 0 );
    ledLeft : out STD_LOGIC_VECTOR ( 7 downto 0 );
    ledRight : out STD_LOGIC_VECTOR ( 7 downto 0 );
    segCtrl : out STD_LOGIC_VECTOR ( 7 downto 0 );
    segCtrr : out STD_LOGIC_VECTOR ( 7 downto 0 );
    chipSel : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );

end top;

architecture stub of top is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
begin
end;
