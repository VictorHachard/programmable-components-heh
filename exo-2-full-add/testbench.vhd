-- ============================================================
-- Testbench pour FullAdd (additionneur complet)
-- ============================================================
-- Teste 7 des 8 combinaisons possibles (A, B, Cin ∈ {0,1}).
-- Le cas (0,0,0) correspond à l'état initial des signaux.
--
-- Résultats attendus :
--   A=0 B=0 Cin=1 => SUM=1 CARRY=0   (0+0+1=1)
--   A=0 B=1 Cin=0 => SUM=1 CARRY=0   (0+1+0=1)
--   A=0 B=1 Cin=1 => SUM=0 CARRY=1   (0+1+1=10)
--   A=1 B=0 Cin=0 => SUM=1 CARRY=0   (1+0+0=1)
--   A=1 B=0 Cin=1 => SUM=0 CARRY=1   (1+0+1=10)
--   A=1 B=1 Cin=0 => SUM=0 CARRY=1   (1+1+0=10)
--   A=1 B=1 Cin=1 => SUM=1 CARRY=1   (1+1+1=11)
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

-- Entité vide obligatoire pour un testbench
entity FullAdd_tb is
end FullAdd_tb;

architecture testbench_arch of FullAdd_tb is

    -- Déclaration du composant à tester
    component FullAdd
        port (
            A, B, Cin  : in  std_logic;
            SUM, CARRY : out std_logic
        );
    end component;

    -- Signaux internes : suffixe _in pour les entrées, _out pour les sorties
    signal A_in      : std_logic := '0';
    signal B_in      : std_logic := '0';
    signal Cin_in    : std_logic := '0';
    signal SUM_out   : std_logic := '0';
    signal CARRY_out : std_logic := '0';

begin

    -- Instanciation du composant (UUT = Unit Under Test)
    uut : FullAdd
    port map (
        A     => A_in,
        B     => B_in,
        Cin   => Cin_in,
        SUM   => SUM_out,
        CARRY => CARRY_out
    );

    -- Process de stimulus : boucle infinie, une combinaison par tranche de 200 ns
    SimuEntrees : process
    begin
        boucle : loop
            wait for 200 ns;
            A_in <= '0'; B_in <= '0'; Cin_in <= '1';   -- 0+0+1 = 01
            wait for 200 ns;
            A_in <= '0'; B_in <= '1'; Cin_in <= '0';   -- 0+1+0 = 01
            wait for 200 ns;
            A_in <= '0'; B_in <= '1'; Cin_in <= '1';   -- 0+1+1 = 10
            wait for 200 ns;
            A_in <= '1'; B_in <= '0'; Cin_in <= '0';   -- 1+0+0 = 01
            wait for 200 ns;
            A_in <= '1'; B_in <= '0'; Cin_in <= '1';   -- 1+0+1 = 10
            wait for 200 ns;
            A_in <= '1'; B_in <= '1'; Cin_in <= '0';   -- 1+1+0 = 10
            wait for 200 ns;
            A_in <= '1'; B_in <= '1'; Cin_in <= '1';   -- 1+1+1 = 11
        end loop boucle;
    end process SimuEntrees;

end testbench_arch;
