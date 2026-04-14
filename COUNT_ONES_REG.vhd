library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity COUNT_ONES_REG is
    port(
        clk : in std_logic;
        rst : in std_logic;
        --SBI interface
        chipselect : in std_logic;
        wr :in std_logic;
        rd : in std_logic;
        address : in std_logic;
        writedata : in std_logic_vector(31 downto 0);
        readdata : out std_logic_vector(31 downto 0);
        -- interface mot COUNT_ONES_HW
        en : out std_logic;
        value : out std_logic_vector(31 downto 0);
        count : in std_logic_vector(5 downto 0);
        done : in std_logic
    );
end entity COUNT_ONES_REG;

architecture RTL of COUNT_ONES_REG is
    signal value_int : std_logic_vector(31 downto 0);
begin

    p_EN : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                EN <= '0';
            elsif chipselect = '1' and wr = '1' and address = '1'then
                EN <= writedata(0);
            else
                EN <= '0';
            end if;
        end if;
    end process p_EN;

    pValue : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                value_int <= ((others => '0'));
            elsif chipselect = '1' and wr = '1' and address = '0' then
                value_int <= writedata;
            end if;
        end if;
    end process pValue;
    
    pRead : process(chipselect,rd,address,value_int,count,done) is
    begin
        if (chipselect = '1') and rd = '1' then
            if address = '0' then
                readdata <= value_int;
            elsif address = '1' then
                readdata <=x"000000" & count & done & "0";
            else 
                readdata <= (others => '0');
            end if;
        else
            readdata <= (others => '0');
        end if;
    end process pRead;
    
    value <= value_int;
end architecture RTL;
