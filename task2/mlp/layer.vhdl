use work.array_types.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity layer is
  generic (
    NUM_NEURONS   : integer := 8;   -- Number of neurons in the layer
    INPUT_WIDTH   : integer := 8;   -- Input data width (e.g. first layer = 4)
    INPUT_BITS    : integer := 1;   -- Bits per input
    WEIGHT_BITS   : integer := 1;   -- Weight data width
    THRESHOLD     : integer := 4    -- Threshold for activation
  );
  port (
    clk     : in std_logic;                   -- Clock
    reset   : in std_logic;                   -- Reset signal
    start   : in std_logic;                   -- Signals the neuron to start computation
    input   : in std_logic_vector(INPUT_BITS * INPUT_WIDTH - 1 downto 0) := (others => '0');  -- Input data
    weights : in WeightArray; -- Weight data for each input of the neuron
    weighted_sum : out WeightedSumArray(NUM_NEURONS -1 downto 0) := (others=>0); -- Weighted sum of the neurons, used for class label selection in output layer
    outputs : out std_logic_vector(NUM_NEURONS - 1 downto 0) := (others => '0'); -- Neuron outputs
    done    : out std_logic := '0'
  );
end layer;

architecture Behavioral of layer is
    signal neuron_done : std_logic_vector(NUM_NEURONS - 1 downto 0);
begin   
  

  -- Neuron generation using the generate statement
  neuron_gen: for i in 0 to NUM_NEURONS - 1 generate
    -- Instantiate Neuron for each neuron in the layer
    neuron_inst: entity work.Neuron
      generic map (
        INPUT_WIDTH  => INPUT_WIDTH,
        INPUT_BITS   => INPUT_BITS,
        WEIGHT_BITS => WEIGHT_BITS,
        THRESHOLD    => THRESHOLD
      )
      port map ( --TODO: Connect open ports to the right signals
        clk             => clk,   -- Clock signal
        reset           => reset,   -- Reset signal
        input           => input,   -- Input data
        start           => start,   -- Signal the neuron to start computation
        output          => outputs(NUM_NEURONS - 1 - i),   -- Assign in reservse order (e.g. i=0, NUM_NEURONS=8 => outputs(7)
        weights         => weights(NUM_NEURONS - 1 - i),   -- Assign in reservse order
        weighted_sum    => weighted_sum(NUM_NEURONS - 1 - i),   -- Assign in reservse order
        done            => neuron_done(NUM_NEURONS - 1 - i)    -- Assign in reservse order
      );
  end generate neuron_gen;
  
  -- TODO: Set done to '1' when all neurons are done
  done <= '1' when neuron_done = (NUM_NEURONS - 1 downto 0 => '1') else '0';
end Behavioral;