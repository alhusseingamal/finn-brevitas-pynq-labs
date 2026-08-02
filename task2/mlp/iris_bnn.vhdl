---------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/28/2023 03:50:22 PM
-- Design Name: 
-- Module Name: iris_bnn - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.array_types.all;
use std.textio.all;
use IEEE.math_real.all;
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity iris_bnn is
    Generic (
        NUM_LAYERS      : integer := 1;  -- Number of HIDDEN layers in the network (excluding first and last layer!)
        NUM_NEURONS     : integer := 8;  -- Number of neurons in each layer
        INPUT_WIDTH     : integer := 4;  -- Input data width
        INPUT_BITS      : integer := 8;  -- Bits per input: Total = 8*4 = 32 bits
        OUTPUT_WIDTH    : integer := 3;  -- One hot output, 1 bit per class, 3 classes = 3 bits
        threshold_array : ThresholdArray(0 to NUM_LAYERS + 1)  := (0, 4, 4)
    );
end iris_bnn;

architecture Behavioral of iris_bnn is
    component NeuralNetwork is
    generic (
        NUM_LAYERS   : integer := 1;  -- Number of HIDDEN layers in the network (excluding first and last layer!)
        NUM_NEURONS  : integer := 8;  -- Number of neurons in each layer
        INPUT_WIDTH  : integer := 4;  -- Input data width
        INPUT_BITS   : integer := 8;  -- Bits per input: Total = 8*4 = 32 bits
        OUTPUT_WIDTH : integer := 3;  -- One hot output, 1 bit per class, 3 classes = 3 bits
        ACT_BITS     : integer := 1;  -- Activation bits
        thresholds   : ThresholdArray(0 to NUM_LAYERS + 1) --Neuron activation thresholds
    );
    port (
        clk                 : in std_logic;                   -- Clock
        reset               : in std_logic;                   -- Reset signal
        start               : in std_logic;                   -- Start signal
        weights             : in LayerArray(0 to NUM_LAYERS - 1)(NUM_NEURONS - 1 downto 0)(NUM_NEURONS - 1 downto 0);
        first_layer_weights : in WeightArray(0 to NUM_NEURONS - 1)(INPUT_WIDTH * 2 - 1 downto 0);
        last_layer_weights  : in WeightArray(0 to OUTPUT_WIDTH - 1)(NUM_NEURONS - 1 downto 0);
        input               : in std_logic_vector(INPUT_BITS * INPUT_WIDTH - 1 downto 0) := (others => '0');  -- Input data
        outputs             : out std_logic_vector(OUTPUT_WIDTH - 1 downto 0) := (others => '0');     -- Final output from the network
        done                : out std_logic
    );
    end component;
    
    signal hidden_weights       : LayerArray(0 to NUM_LAYERS - 1)(NUM_NEURONS - 1 downto 0)(NUM_NEURONS - 1 downto 0) := (others=>(others=>(others=>'0')));
    signal first_layer_weights  : WeightArray(0 to NUM_NEURONS - 1)(INPUT_WIDTH * 2 - 1 downto 0) := (others=>(others=>'0'));
    signal last_layer_weights   : WeightArray(0 to OUTPUT_WIDTH - 1)(NUM_NEURONS - 1 downto 0) := (others=>(others=>'0'));
    signal input                : std_logic_vector(INPUT_WIDTH*INPUT_BITS - 1 downto 0) := (others =>'0');
    signal reset                : std_logic := '1';
    signal clock                : std_logic := '0';
    signal start                : std_logic := '0';
    signal done                 : std_logic := '0';
    signal output               : std_logic_vector(OUTPUT_WIDTH - 1 downto 0);
    --type InputArray is array(natural range <>) of std_logic_vector;
    --signal data                 : InputArray(0 to 30)(31 downto 0) := (X"55b4040a", X"3db40d0a", X"0069040a", X"f769f1e8", X"2d005d67", X"c177aeff", X"26770d00", X"4cef0421", X"550f7474", X"5d3c868a", X"005a090a", X"35a40d0a", X"b2779ba1", X"ff2dffff", X"55007c8a", X"b296c9e8");
    
    attribute dont_touch : string;
    attribute dont_touch of hidden_weights : signal is "true";
    attribute dont_touch of first_layer_weights : signal is "true";
    attribute dont_touch of last_layer_weights : signal is "true";
    
    -- attribute keep_hierarchy : string;
    -- attribute keep_hierarchy of iris_bnn : entity is "yes";

begin
    clock <= not clock after 10 ns;
    
    --improve this by reading weights from a file
    first_layer_weights(7) <= "01110111";
    first_layer_weights(6) <= "11010111";
    first_layer_weights(5) <= "11111111";
    first_layer_weights(4) <= "11011101";
    first_layer_weights(3) <= "01110111";
    first_layer_weights(2) <= "11011111";
    first_layer_weights(1) <= "01010111";
    first_layer_weights(0) <= "01111101";
    
    hidden_weights(0)(7) <= "11100001";
    hidden_weights(0)(6) <= "11101000";
    hidden_weights(0)(5) <= "11111100";
    hidden_weights(0)(4) <= "00100000";
    hidden_weights(0)(3) <= "11111000";
    hidden_weights(0)(2) <= "11010100";
    hidden_weights(0)(1) <= "01011011";
    hidden_weights(0)(0) <= "10110101";
    
    last_layer_weights(2) <= "00100101";
    last_layer_weights(1) <= "11001101";
    last_layer_weights(0) <= "10010101";
    
    bnn : NeuralNetwork
    generic map (
        NUM_LAYERS => NUM_LAYERS,
        NUM_NEURONS => NUM_NEURONS,
        INPUT_WIDTH => INPUT_WIDTH,
        INPUT_BITS => INPUT_BITS,
        OUTPUT_WIDTH => OUTPUT_WIDTH,
        thresholds => threshold_array
    )
    port map(
        clk => clock,
        reset => reset,
        start => start,
        weights => hidden_weights,
        first_layer_weights => first_layer_weights,
        last_layer_weights => last_layer_weights,
        input => input,
        outputs => output,
        done => done
    );
    
    
    -- Generate the test stimulus
	stimulus: process
	-- TODO: Add absolute path to the test data file here!
	file FileIn        : text open read_mode is  "/mnt/data1/KIT/studies/CDNC/NN_Acc/ss26/tasks/task2/mlp/iris_test_X.txt";
	variable LineIn    : line;
	variable InputTmp  : std_logic_vector(31 downto 0);
	begin
	    while (not endfile(FileIn)) loop
	       wait on clock until clock = '1';
	       reset <= '1';
	       start <= '0';
	       wait on clock until clock = '1';
	       readline(FileIn, LineIn);
	       hread(LineIn, InputTmp);
	       input <= InputTmp;
	       reset <= '0';
	       start <= '1';
	       wait on done until done='1';
	       report "Predicted label: " & integer'image(integer(log2(real(to_integer(unsigned(output))))));
	    end loop;
	    wait;
    end process stimulus;
    
end Behavioral;
