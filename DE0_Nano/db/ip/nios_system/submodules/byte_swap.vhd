LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY byte_swap_core IS
PORT (
    data_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    sel      : IN  STD_LOGIC;  -- 0 = swap1, 1 = swap2
    data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END byte_swap_core;

ARCHITECTURE Structure OF byte_swap_core IS

SIGNAL swap1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL swap2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    -- Swap1 : [Octet3|Octet2|Octet1|Octet0] -> [Octet0|Octet1|Octet2|Octet3]
    swap1 <= data_in(7  DOWNTO  0) &
             data_in(15 DOWNTO  8) &
             data_in(23 DOWNTO 16) &
             data_in(31 DOWNTO 24);

    -- Swap2 : [Octet3|Octet2|Octet1|Octet0] -> [Octet1|Octet0|Octet3|Octet2]
    swap2 <= data_in(23 DOWNTO 16) &
             data_in(31 DOWNTO 24) &
             data_in(7  DOWNTO  0) &
             data_in(15 DOWNTO  8);

    -- Sélection du résultat
    data_out <= swap1 WHEN sel = '0' ELSE swap2;

END Structure;