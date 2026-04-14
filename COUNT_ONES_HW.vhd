library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity count_ones_hw is
    port(
        clk : in std_logic;
        rst : in std_logic;
        value :in std_logic_vector(31 downto 0);
        en : in std_logic;
        count : out std_logic_vector(5 downto 0);
        done : out std_logic
    );
end entity;

architecture RTL of count_ones_hw is

    signal shift_reg : std_logic_vector(31 downto 0);
    signal couter_int : integer range 0 to 32;
    signal bit_count : integer range 0 to 31;
    type state is (s_idle,s_count);
    signal tilstand : state := s_idle;
begin

    p_count: process(clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    couter_int <= 0;
                    bit_count <= 0;
                    done <= '0';
                    tilstand <= s_idle;
                    shift_reg <= (others => '0');
                else
                    case tilstand is
                    when s_idle =>
                        if en = '1' then
                            tilstand <= s_count;
                            done <='1';
                            couter_int <= 0;
                            bit_count <= 0;
                            shift_reg <= value;
                        end if;
                    when s_count =>
                        couter_int <= couter_int + to_integer(unsigned'('0' & shift_reg(0)));
                        shift_reg <= '0' & shift_reg(31 downto 1);
                        if bit_count = 31 then
                            tilstand <= s_idle;
                            done <= '1';
                        else
                            bit_count <= bit_count +1;
                        end if;
                    end case;
                end if;
            end if;
        end process;
        count <= std_logic_vector(to_unsigned(couter_int,6));
    end architecture;

    
    