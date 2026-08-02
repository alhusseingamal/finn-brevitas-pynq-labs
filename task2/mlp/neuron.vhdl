library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity neuron is
    generic (
        INPUT_WIDTH   : integer     := 8;  -- Input data width (how many inputs)
        INPUT_BITS    : integer     := 1;  -- bits per input
        WEIGHT_BITS   : integer     := 1;  -- bits per weight
        THRESHOLD     : integer     := 4
    );
    port (
        clk          : in std_logic;               
        reset        : in std_logic;               
        start        : in std_logic;               
        input        : in std_logic_vector(INPUT_BITS * INPUT_WIDTH - 1 downto 0) := (others => '0');
        weights      : in std_logic_vector(INPUT_WIDTH * WEIGHT_BITS - 1 downto 0) := (others => '0');
        weighted_sum : out integer := 0;
        done         : out std_logic := '0';
        output       : out std_logic := '0'        
    );
end neuron;

architecture Behavioral of neuron is
    signal product       : integer := 0;
    signal wsum          : integer := 0; 
    signal index         : integer range 0 to INPUT_WIDTH := 0;
    signal xnor_prod : std_logic_vector(INPUT_WIDTH - 1 downto 0) := (others=>'0');
    
    type state is (idle, mult, sum, act);
    signal current_state, next_state : state := idle;

    function popcount(v : std_logic_vector) return integer is
        variable cnt : integer := 0;
    begin
        for i in v'range loop
            if v(i) = '1' then
                cnt := cnt + 1;
            end if;
        end loop;
        return cnt;
    end function;

begin
    -- Clocked Process (Handles State Updates AND Registers)
    fsm_lower: process(clk, reset)
    begin
        if reset = '1' then
            current_state <= idle;
            wsum          <= 0;
            index         <= 0;
            product       <= 0;
            output        <= '0';
            done          <= '0';
            weighted_sum  <= 0;
        elsif rising_edge(clk) then
            current_state <= next_state;

            case current_state is
                when idle =>
                    done <= '0'; -- Clear done pulse from previous execution
                    if start = '1' then
                        -- Start of new network pass: Clear accumulators
                        wsum    <= 0;
                        index   <= 0;
                        product <= 0;
                        -- Note: We deliberately do NOT clear 'output' or 'weighted_sum' here; They must hold their values for the next layer to read
                    end if;

                when mult =>
                    if INPUT_BITS = 1 or WEIGHT_BITS = 1 then
                        xnor_prod <= input xnor weights;
                    else
                        product <= to_integer(unsigned(input((INPUT_BITS * (index + 1) - 1) downto INPUT_BITS * index))) * 
                                   to_integer(signed(weights(WEIGHT_BITS * (index + 1) - 1 downto WEIGHT_BITS * index)));
                    end if;

                when sum =>
                    if INPUT_BITS = 1 and WEIGHT_BITS = 1 then
                        wsum <= popcount(xnor_prod);
                    else
                        wsum <= wsum + product;
                        index <= index + 1;
                        if index >= INPUT_WIDTH - 1 then
                            index <= 0;
                        end if;
                    end if;

                when act =>
                    -- Lock in outputs so they stay stable during 'idle'
                    weighted_sum <= wsum;
                    if wsum >= THRESHOLD then
                        output <= '1';
                    else
                        output <= '0';
                    end if;
                    done <= '1'; -- Trigger next layer
            end case;
        end if;
   end process fsm_lower;
   
    -- =========================================================================
    -- FSM UPPER: Purely Combinational (Handles ONLY Next State Logic)
    -- =========================================================================
    fsm_upper: process(all)
    begin
        next_state <= current_state; -- Default to prevent latches

        case current_state is
            when idle =>
                if start = '1' then
                    next_state <= mult;
                end if;

            when mult =>
                next_state <= sum;

            when sum =>
                if INPUT_BITS = 1 and WEIGHT_BITS = 1 then
                    next_state <= act;
                else
                    if index >= INPUT_WIDTH - 1 then
                        next_state <= act;
                    else
                        next_state <= mult;
                    end if;
                end if;

            when act =>
                next_state <= idle;
        end case;
    end process fsm_upper;

end Behavioral;