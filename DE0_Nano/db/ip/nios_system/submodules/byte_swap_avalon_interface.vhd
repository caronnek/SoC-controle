LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY byte_swap_avalon_interface IS
PORT (
    clock      : IN  STD_LOGIC;
    resetn     : IN  STD_LOGIC;
    read       : IN  STD_LOGIC;
    write      : IN  STD_LOGIC;
    chipselect : IN  STD_LOGIC;
    writedata  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    readdata   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END byte_swap_avalon_interface;

ARCHITECTURE Structure OF byte_swap_avalon_interface IS

SIGNAL to_reg   : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL from_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL sel_reg  : STD_LOGIC;

COMPONENT byte_swap_core
PORT (
    data_in  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    sel      : IN  STD_LOGIC;
    data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END COMPONENT;

BEGIN

    swap_instance : byte_swap_core
    PORT MAP (
        data_in  => to_reg,
        sel      => sel_reg,
        data_out => from_reg
    );

    process(clock, resetn)
    begin
        if resetn = '0' then
            to_reg  <= (others => '0');
            sel_reg <= '0';
        elsif rising_edge(clock) then
            if chipselect = '1' and write = '1' then
                to_reg  <= writedata(31 DOWNTO 0);
                sel_reg <= writedata(0);  -- bit 0 = sélection swap
            end if;
        end if;
    end process;

    process(clock, resetn)
    begin
        if resetn = '0' then
            readdata <= (others => '0');
        elsif rising_edge(clock) then
            if chipselect = '1' and read = '1' then
                readdata <= from_reg;
            end if;
        end if;
    end process;

END Structure;