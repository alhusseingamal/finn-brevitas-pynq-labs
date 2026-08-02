use work.array_types.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity NeuralNetwork is
    generic (
        NUM_LAYERS   : integer := 1;  -- Number of HIDDEN layers in the network (excluding first and last layer!)
        NUM_NEURONS  : integer := 8;  -- Number of neurons in each layer
        INPUT_WIDTH  : integer := 4;  -- Input data width
        INPUT_BITS   : integer := 8;  -- Bits per input
        OUTPUT_WIDTH : integer := 3;  -- 
        ACT_BITS     : integer := 1;  -- Activation bit width
        thresholds   : ThresholdArray(0 to NUM_LAYERS + 1) -- Activation thresholds
    );
    port (
        clk                 : in std_logic;                   -- Clock
        reset               : in std_logic;                   -- Reset signal
        start               : in std_logic;                   -- Start signal
        weights             : in LayerArray(0 to NUM_LAYERS - 1)(NUM_NEURONS - 1 downto 0)(NUM_NEURONS - 1 downto 0) := (others=>(others=>(others=>'0')));
        first_layer_weights : in WeightArray(0 to NUM_NEURONS - 1)(INPUT_WIDTH * 2 - 1 downto 0) := (others=>(others=>'0'));
        last_layer_weights  : in WeightArray(0 to OUTPUT_WIDTH - 1)(NUM_NEURONS - 1 downto 0) := (others=>(others=>'0'));
        input               : in std_logic_vector(INPUT_BITS * INPUT_WIDTH - 1 downto 0) := (others => '0');    -- Input data
        outputs             : out std_logic_vector(OUTPUT_WIDTH - 1 downto 0) := (others => '0');               -- Final output from the network
        done                : out std_logic := '0'
    );
end NeuralNetwork;


architecture Behavioral of NeuralNetwork is
    signal layer_done       : std_logic_vector(NUM_LAYERS + 1 downto 0) := (others => '0');                                 -- Vector for done signals
    signal layer_outputs    : LayerOutputArray(0 to NUM_LAYERS + 1)(NUM_NEURONS - 1 downto 0) := (others=>(others => '0')); -- Last layer outputs to output port
    signal weighted_sum     : WeightedSumArray(0 to OUTPUT_WIDTH -1) := (others => 0);                                      -- Array of weighted sums for the output layer

    -- In case you want to run an implementation of the design without the testbench, we do not want the tools to optimize our design
    -- The tools would otherwise remove all instances as no clock and inputs are connected
    -- attribute keep_hierarchy : string;
    -- attribute dont_touch : string;
    -- attribute keep_hierarchy of NeuralNetwork : entity is "yes";
    -- attribute dont_touch of NeuralNetwork     : entity is "yes";
    
    -- Get the index of WeightedSum with maximum value
    -- This will return the predicted class label
    function argmax(a : WeightedSumArray) return integer is
        variable index : integer := 0;      -- Index of the maximum value
        variable foundmax : integer := 0;   -- Maximum value
    begin
        -- TODO: Implement argmax, e.g. with a for-loop (for i in 0 to a'high loop)
        for i in 0 to a'high loop
            if a(i) > foundmax then
                foundmax := a(i);
                index := i;
            end if;
        end loop;
        return index;
    end function;
begin

    -- TODO: assign open ports
    first_layer_inst: entity work.layer
        generic map (
            NUM_NEURONS   => NUM_NEURONS,
            INPUT_WIDTH   => INPUT_WIDTH,
            INPUT_BITS    => INPUT_BITS,
            THRESHOLD     => thresholds(0), -- Activation threshold of first layer
            WEIGHT_BITS   => 2     -- In the first layer we use bipolar representation and ignore 0
        )
        port map (
            clk     => clk, -- Clock signal
            reset   => reset, -- Reset signal
            start   => start, -- Start signal
            -- Provide the correct input to each layer
            input   => input, -- 32
            done    => layer_done(0), -- '1' when layer is done
            -- Connect weights of first layer
            weights => first_layer_weights,
            -- Connect outputs of the layer
            outputs => layer_outputs(0),
            weighted_sum => open    -- may remain open, only needed for output layer
        );

    -- Instantiate layers using the generate statement
    -- Notice that we start with index 1
    layer_gen: for i in 1 to NUM_LAYERS generate
        -- Instantiate Layer for each layer in the network
        -- TODO: assign open ports
        layer_inst: entity work.layer
            generic map (
                NUM_NEURONS   => NUM_NEURONS,
                INPUT_WIDTH   => NUM_NEURONS,
                INPUT_BITS    => ACT_BITS,
                THRESHOLD     => thresholds(i)   -- Activation threshold of layer i
            )
            port map (
                clk     => clk, -- Clock signal
                reset   => reset, -- Reset signal
                start   => layer_done(i-1), -- Start after previous layer finishes
                input   => layer_outputs(i - 1)(NUM_NEURONS - 1 downto 0), -- Provide the correct input to each layer
                done    => layer_done(i), -- '1' when layer is done
                -- Connect weights to each layer as needed
                -- For example, weights(0) are the weights for the first HIDDEN layer, weights(1) for the second, and so on
                weights => weights(i-1),
                -- Connect outputs of the layer
                outputs => layer_outputs(i),
                weighted_sum => open    -- may remain open, only needed for output layer
            );

    end generate;
    
    -- TODO: assign open ports
    last_layer_inst: entity work.layer
        generic map (
            NUM_NEURONS   => OUTPUT_WIDTH,
            INPUT_WIDTH   => NUM_NEURONS,
            INPUT_BITS    => ACT_BITS,
            THRESHOLD     => thresholds(NUM_LAYERS + 1) -- Activation threshold of last layer
        )
        port map (
            clk     => clk,    -- Clock signal
            reset   => reset,    -- Reset signal
            start   => layer_done(NUM_LAYERS),    -- Start after previous layer finishes
            input   => layer_outputs(NUM_LAYERS)(NUM_NEURONS - 1 downto 0),    -- Provide the correct input to each layer
            done    => layer_done(NUM_LAYERS+1),    -- Done signal of the last layer means the whole NN is done computing
            -- Connect weights to each layer as needed
            weights => last_layer_weights,
            -- Connect outputs of the layer
            outputs => open, -- This may remain open for the last layer as the activation value is not required
            weighted_sum => weighted_sum
        );
    
    update_outputs: process(clk, reset)
        variable max_idx : integer := 0;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- TODO: Reset outputs and done signal
                outputs <= (others => '0');
                done    <= '0';
            elsif layer_done(NUM_LAYERS + 1) = '1' then
                -- TODO: Assign output using argmax. Assign done signal 
                max_idx := argmax(weighted_sum);
                -- Output is one hot => set index of class to '1'
                outputs <= (others => '0');
                if max_idx >= 0 and max_idx < OUTPUT_WIDTH then
                    outputs(max_idx) <= '1';
                end if;
                done <= '1';
            end if;
        end if;
    end process;


end Behavioral;