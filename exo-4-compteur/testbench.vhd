library ieee;
use ieee.std_logic_1164.all;

entity Compteur_tb is
end Compteur_tb;

architecture testbench_arch of Compteur_tb is

    component Compteur
        port (
            clk                          : in  std_logic;
            LED1, LED2, LED3, LED4, LED5 : out std_logic
        );
    end component;

    signal clks                          : std_logic := '0';
    signal LED1s, LED2s, LED3s, LED4s, LED5s : std_logic := '0';

    begin

    uut : Compteur
    port map (
        clk  => clks,
        LED1 => LED1s,
        LED2 => LED2s,
        LED3 => LED3s,
        LED4 => LED4s,
        LED5 => LED5s
    );

    clock : process
        begin
            loop
                clks <= '0';
                wait for 50ns;
                clks <= '1';
                wait for 50ns;
            end loop;
        end process clock;

end testbench_arch;
