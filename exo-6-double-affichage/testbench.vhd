library ieee;
use ieee.std_logic_1164.all;

entity DoubleAffichage_tb is
end DoubleAffichage_tb;

architecture testbench_arch of DoubleAffichage_tb is

    component DoubleAffichage
        port (
            clk, reset               : in  std_logic;
            DP, G, F, E, D, C, B, A : out std_logic
        );
    end component;

    signal clks, resets              : std_logic := '0';
    signal DPs, Gs, Fs, Es, Ds, Cs, Bs, As : std_logic := '0';

    begin

    uut : DoubleAffichage
    port map (
        clk    => clks,
        reset  => resets,
        DP     => DPs,
        G      => Gs,
        F      => Fs,
        E      => Es,
        D      => Ds,
        C      => Cs,
        B      => Bs,
        A      => As
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

    SimuEntrees : process
        begin
            resets <= '0'; -- reset actif-bas : remise a zero
            wait for 500ns;
            resets <= '1'; -- liberation : le compteur commence
            wait;
        end process SimuEntrees;

end testbench_arch;
