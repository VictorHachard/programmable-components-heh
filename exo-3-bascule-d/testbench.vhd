library ieee;
use ieee.std_logic_1164.all;

entity BasculeD_tb is
end BasculeD_tb;

architecture testbench_arch of BasculeD_tb is

    component BasculeD
        port (
            clk, D : in std_logic;
            q, nq : out std_logic
        );
    end component;

    signal clks, Ds, qs, nqs : std_logic := '0';

    begin

    uut : BasculeD
    port map (
        clk => clks,
        D   => Ds,
        q   => qs,
        nq  => nqs
    );

    SimuEntrees : process
        begin
            boucle : loop
                wait for 200ns;
                clks <= '0'; Ds <= '0';
                wait for 200ns;
                clks <= '0'; Ds <= '1';
                wait for 200ns;
                clks <= '1'; Ds <= '1';
                wait for 200ns;
                clks <= '0'; Ds <= '1';
                wait for 200ns;
                clks <= '1'; Ds <= '0';
                wait for 200ns;
                clks <= '0'; Ds <= '0';
            end loop boucle;
        end process SimuEntrees;

end testbench_arch;
