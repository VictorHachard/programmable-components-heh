-- ============================================================
-- Testbench pour Compteur (compteur 24 bits)
-- ============================================================
-- Ce testbench génère une horloge continue à 10 MHz (période 100 ns).
-- Il n'y a pas de process de stimulus car le compteur n'a pas
-- d'autres entrées que l'horloge.
--
-- Pour voir les LEDs changer dans EPWave, il faut simuler
-- suffisamment longtemps. Avec clk=10 MHz :
--   bit 19 change toutes les 2^19 × 100 ns ≈ 52 ms de simulation
-- On lance généralement 5 ms ou plus pour voir quelques transitions.
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

-- Entité vide : obligatoire pour un testbench
entity Compteur_tb is
end Compteur_tb;

architecture testbench_arch of Compteur_tb is

    -- Déclaration du composant à tester
    component Compteur
        port (
            clk                          : in  std_logic;
            LED1, LED2, LED3, LED4, LED5 : out std_logic
        );
    end component;

    -- Signaux internes
    signal clks                               : std_logic := '0';
    signal LED1s, LED2s, LED3s, LED4s, LED5s : std_logic := '0';

begin

    -- Instanciation du composant (UUT)
    uut : Compteur
    port map (
        clk  => clks,
        LED1 => LED1s,
        LED2 => LED2s,
        LED3 => LED3s,
        LED4 => LED4s,
        LED5 => LED5s
    );

    -- Générateur d'horloge : période 100 ns (10 MHz)
    -- Boucle infinie : clk bas 50 ns, clk haut 50 ns => 50% duty cycle
    clock : process
    begin
        loop
            clks <= '0';
            wait for 50 ns;
            clks <= '1';
            wait for 50 ns;
        end loop;
    end process clock;

    -- Pas de process de stimulus : le compteur n'a pas d'autre entrée que l'horloge

end testbench_arch;
