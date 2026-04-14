library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity COUNT_ONES_ALL is
    port(
        clk : in std_logic;
        rst : in std_logic;
                --SBI interface
                chipselect : in std_logic;
                wr :in std_logic;
                rd : in std_logic;
                address : in std_logic;
                writedata : in std_logic_vector(31 downto 0);
                readdata : out std_logic_vector(31 downto 0)
        
    );
end entity COUNT_ONES_ALL;

architecture RTL of COUNT_ONES_ALL is


signal en :  std_logic;
signal value :  std_logic_vector(31 downto 0);
signal count :  std_logic_vector(5 downto 0);
signal done :  std_logic;


component COUNT_ONES_REG is
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
end component COUNT_ONES_REG;

component count_ones_hw is
    port(
        clk : in std_logic;
        rst : in std_logic;
        value :in std_logic_vector(31 downto 0);
        en : in std_logic;
        count : out std_logic_vector(5 downto 0);
        done : out std_logic
    );
end component;

begin

    COUNT_ONES_REG_inst : component COUNT_ONES_REG
        port map(
            clk        => clk,
            rst        => rst,
            chipselect => chipselect,
            wr         => wr,
            rd         => rd,
            address    => address,
            writedata  => writedata,
            readdata   => readdata,
            en         => en,
            value      => value,
            count      => count,
            done       => done
        );

        count_ones_hw_inst : component count_ones_hw
            port map(
                clk   => clk,
                rst   => rst,
                value => value,
                en    => en,
                count => count,
                done  => done
            );
        
    
end architecture RTL;
