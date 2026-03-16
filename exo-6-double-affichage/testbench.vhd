-- ============================================================
-- Testbench pour DoubleAffichage
-- ============================================================
-- Deux process :
--   1. clock       : génère une horloge 10 MHz (période 100 ns)
--   2. SimuEntrees : active le reset puis le libère
--
-- Séquence :
--   t=0 à 500 ns : reset='0' (actif-bas) => compteur bloqué à 0
--   t=500 ns     : reset='1' (inactif)   => compteur commence à s'incrémenter
--   puis "wait" sans argument => le process se suspend définitivement
--   (l'horloge continue, on observe le compteur dans EPWave)
--
-- Pour voir les bits hauts changer dans EPWave, simuler au moins 1 ms.
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

-- Entité vide : obligatoire pour un testbench
entity DoubleAffichage_tb is
end DoubleAffichage_tb;

architecture testbench_arch of DoubleAffichage_tb is

    -- Déclaration du composant à tester
    component DoubleAffichage
        port (
            clk, reset               : in  std_logic;
            DP, G, F, E, D, C, B, A : out std_logic
        );
    end component;

    -- Signaux internes du testbench
    signal clks, resets                      : std_logic := '0';
    signal DPs, Gs, Fs, Es, Ds, Cs, Bs, As  : std_logic := '0';

begin

    -- Instanciation du composant (UUT)
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

    -- Générateur d'horloge : période 100 ns (10 MHz), boucle infinie
    clock : process
    begin
        loop
            clks <= '0';
            wait for 50 ns;
            clks <= '1';
            wait for 50 ns;
        end loop;
    end process clock;

    -- Process de stimulus : gestion du reset
    SimuEntrees : process
    begin
        resets <= '0';       -- reset ACTIF (actif-bas) : compteur forcé à 0
        wait for 500 ns;     -- maintenir le reset pendant 500 ns
        resets <= '1';       -- libération du reset : le compteur commence à compter
        wait;                -- "wait" sans durée = suspension définitive du process
                             -- (l'horloge continue à tourner indéfiniment)
    end process SimuEntrees;

end testbench_arch;
