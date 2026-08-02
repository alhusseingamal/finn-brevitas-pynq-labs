library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

package array_types is
    type WeightArray is array(natural range <>) of std_logic_vector;
    type LayerOutputArray is array(natural range <>) of std_logic_vector;
    type LayerArray is array (natural range <>) of WeightArray;
    type ThresholdArray is array (natural range <>) of integer;
    type WeightedSumArray is array (natural range <>) of integer;
end package array_types;