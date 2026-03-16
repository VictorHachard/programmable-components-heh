-- ============================================================
-- Testbench pour DemiAdd (demi-additionneur)
-- ============================================================
-- Couvre les 4 combinaisons possibles de deux entrées 1 bit.
-- Les résultats attendus sont :
--   E1=0 E2=0 => SORTIE=0 CARRY=0
--   E1=1 E2=0 => SORTIE=1 CARRY=0
--   E1=1 E2=1 => SORTIE=0 CARRY=1
--   E1=0 E2=1 => SORTIE=1 CARRY=0  (puis X pour test)
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

-- Entité vide : règle obligatoire pour un testbench
entity DemiAdd_tb is
end DemiAdd_tb;

architecture testbench_arch of DemiAdd_tb is

    -- Déclaration du composant à tester
    component DemiAdd
        port (  ENTREE1, ENTREE2 : in  std_logic;
                SORTIE, CARRY    : out std_logic);
    end component;

    -- Signaux internes du testbench
    signal ENTREE1_in : std_logic := '0';
    signal ENTREE2_in : std_logic := '0';
    signal SORTIE_out : std_logic := '0';
    signal CARRY_out  : std_logic := '0';

begin

    -- Instanciation : connexion du testbench au composant (UUT)
    uut : DemiAdd
    port map (
        ENTREE1 => ENTREE1_in,
        ENTREE2 => ENTREE2_in,
        SORTIE  => SORTIE_out,
        CARRY   => CARRY_out
    );

    -- Process de stimulus : parcourt plusieurs combinaisons toutes les 200 ns
    SimuEntrees : process
    begin
        boucle : loop
            wait for 200 ns;
            ENTREE1_in <= '1';          -- E1=1, E2=0 => SORTIE=1, CARRY=0
            wait for 200 ns;
            ENTREE2_in <= '1';          -- E1=1, E2=1 => SORTIE=0, CARRY=1
            wait for 200 ns;
            ENTREE1_in <= '0';          -- E1=0, E2=1 => SORTIE=1, CARRY=0
            wait for 200 ns;
            ENTREE2_in <= 'X';          -- valeur inconnue pour tester la robustesse
        end loop boucle;
    end process SimuEntrees;

end testbench_arch;
