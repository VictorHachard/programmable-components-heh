-- ============================================================
-- Testbench pour BasculeD (bascule D)
-- ============================================================
-- IMPORTANT : dans ce testbench, clk est piloté MANUELLEMENT
-- (pas de process dédié à l'horloge). On change clk et D
-- ensemble dans le même process, toutes les 200 ns.
--
-- Séquence :
--   t=200 ns : clk=0, D=0 => pas de front, q inchangé
--   t=400 ns : clk=0, D=1 => pas de front, q inchangé (D change mais clk ne monte pas)
--   t=600 ns : clk=1, D=1 => FRONT MONTANT => q=1, nq=0
--   t=800 ns : clk=0, D=1 => pas de front, q garde 1
--   t=1000ns : clk=1, D=0 => FRONT MONTANT => q=0, nq=1
--   t=1200ns : clk=0, D=0 => pas de front, q garde 0
--   puis boucle repart
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

-- Entité vide : obligatoire pour un testbench
entity BasculeD_tb is
end BasculeD_tb;

architecture testbench_arch of BasculeD_tb is

    -- Déclaration du composant à tester
    component BasculeD
        port (
            clk, D : in  std_logic;
            q, nq  : out std_logic
        );
    end component;

    -- Signaux internes du testbench (nommés avec 's' pour "signal testbench")
    signal clks, Ds, qs, nqs : std_logic := '0';

begin

    -- Instanciation du composant (UUT = Unit Under Test)
    uut : BasculeD
    port map (
        clk => clks,
        D   => Ds,
        q   => qs,
        nq  => nqs
    );

    -- Process de stimulus : clk et D changent manuellement toutes les 200 ns
    -- On observe que q ne change QUE quand clk passe de 0 à 1
    SimuEntrees : process
    begin
        boucle : loop
            wait for 200 ns;
            clks <= '0'; Ds <= '0';     -- clk bas, D=0 : pas de capture
            wait for 200 ns;
            clks <= '0'; Ds <= '1';     -- clk bas, D=1 : D change mais q ne change pas
            wait for 200 ns;
            clks <= '1'; Ds <= '1';     -- FRONT MONTANT : q capture D=1 => q=1
            wait for 200 ns;
            clks <= '0'; Ds <= '1';     -- clk redescend : q garde 1
            wait for 200 ns;
            clks <= '1'; Ds <= '0';     -- FRONT MONTANT : q capture D=0 => q=0
            wait for 200 ns;
            clks <= '0'; Ds <= '0';     -- clk redescend : q garde 0
        end loop boucle;
    end process SimuEntrees;

end testbench_arch;
