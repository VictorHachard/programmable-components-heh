-- ============================================================
-- Testbench pour Test1 (porte ET)
-- ============================================================
-- Pas de ports sur l'entité testbench : c'est la règle en VHDL.
-- On instancie le composant (UUT = Unit Under Test) et on
-- pilote ses entrées via des signaux internes.
--
-- Séquence de stimulus (intervalle 200 ns) :
--   t=200 ns : ENTREE1 <- 1  => SORTIE = 0 (car ENTREE2 = 0)
--   t=400 ns : ENTREE2 <- 1  => SORTIE = 1 (les deux = 1)
--   t=600 ns : ENTREE1 <- 0  => SORTIE = 0
--   t=800 ns : ENTREE2 <- X  => SORTIE = X (valeur inconnue)
--   puis le loop repart depuis t=1000 ns
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

-- Entité vide : un testbench n'a jamais de ports
entity Test1_tb is
end Test1_tb;

architecture testbench_arch of Test1_tb is

    -- Déclaration du composant à tester (doit correspondre exactement à l'entité)
    component Test1
        port (  ENTREE1, ENTREE2 : in std_logic;
                SORTIE : out std_logic);
    end component;

    -- Signaux internes qui connectent le testbench au composant
    -- Suffixe _in pour les entrées du composant, _out pour les sorties
    signal ENTREE1_in : std_logic := '0';   -- valeur initiale 0
    signal ENTREE2_in : std_logic := '0';
    signal SORTIE_out : std_logic := '0';

begin

    -- Instanciation du composant (UUT = Unit Under Test)
    -- "port map" connecte chaque port du composant à un signal du testbench
    uut : Test1
    port map (ENTREE1 => ENTREE1_in, ENTREE2 => ENTREE2_in, SORTIE => SORTIE_out);

    -- Process de stimulus : boucle infinie, change les entrées toutes les 200 ns
    -- "wait for" suspend le process pendant la durée indiquée
    SimuEntrees : process
    begin
        boucle : loop
            wait for 200 ns;
            ENTREE1_in <= '1';          -- E1=1, E2=0 => SORTIE=0
            wait for 200 ns;
            ENTREE2_in <= '1';          -- E1=1, E2=1 => SORTIE=1
            wait for 200 ns;
            ENTREE1_in <= '0';          -- E1=0, E2=1 => SORTIE=0
            wait for 200 ns;
            ENTREE2_in <= 'X';          -- X = valeur inconnue (test robustesse)
        end loop boucle;
    end process SimuEntrees;

end testbench_arch;
