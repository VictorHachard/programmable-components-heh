-- ============================================================
-- Testbench pour Decodeur7Seg
-- ============================================================
-- Parcourt les 16 valeurs possibles (0..F) en changeant les
-- boutons toutes les 200 ns.
--
-- RAPPEL : les boutons sont ACTIFS-BAS sur la carte physique.
--   Dans ce testbench, BP=0 = touche enfoncée = valeur prise en compte.
--   La logique d'inversion est dans le design (NOT Boutons).
--
-- Exemple de lecture des résultats dans EPWave :
--   Quand BP0=0 BP1=0 BP2=0 BP3=0 => affiche 0
--   (code envoyé aux segments : NOT "00111111" = "11000000")
--   Les segments A='0' B='0' C='0' D='0' E='0' F='0' = allumés
--   Les segments G='1' DP='1' = éteints
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

-- Entité vide : obligatoire pour un testbench
entity Decodeur7Seg_tb is
end Decodeur7Seg_tb;

architecture testbench_arch of Decodeur7Seg_tb is

    -- Déclaration du composant à tester
    component Decodeur7Seg
        port (
            BP0, BP1, BP2, BP3       : in  std_logic;
            DP, G, F, E, D, C, B, A : out std_logic
        );
    end component;

    -- Signaux internes (suffixe 's')
    signal BP0s, BP1s, BP2s, BP3s            : std_logic := '0';
    signal DPs, Gs, Fs, Es, Ds, Cs, Bs, As  : std_logic := '0';

begin

    -- Instanciation du composant (UUT)
    uut : Decodeur7Seg
    port map (
        BP0 => BP0s, BP1 => BP1s, BP2 => BP2s, BP3 => BP3s,
        DP  => DPs,  G   => Gs,   F   => Fs,   E   => Es,
        D   => Ds,   C   => Cs,   B   => Bs,   A   => As
    );

    -- Process de stimulus : teste les 16 chiffres hex (0..F)
    -- BP0 = bit 0 (poids faible), BP3 = bit 3 (poids fort)
    -- Tous les boutons à 0 = valeur sélectionnée (logique active-bas)
    SimuEntrees : process
    begin
        boucle : loop
            wait for 200 ns; BP0s<='0'; BP1s<='0'; BP2s<='0'; BP3s<='0'; -- affiche 0
            wait for 200 ns; BP0s<='1'; BP1s<='0'; BP2s<='0'; BP3s<='0'; -- affiche 1
            wait for 200 ns; BP0s<='0'; BP1s<='1'; BP2s<='0'; BP3s<='0'; -- affiche 2
            wait for 200 ns; BP0s<='1'; BP1s<='1'; BP2s<='0'; BP3s<='0'; -- affiche 3
            wait for 200 ns; BP0s<='0'; BP1s<='0'; BP2s<='1'; BP3s<='0'; -- affiche 4
            wait for 200 ns; BP0s<='1'; BP1s<='0'; BP2s<='1'; BP3s<='0'; -- affiche 5
            wait for 200 ns; BP0s<='0'; BP1s<='1'; BP2s<='1'; BP3s<='0'; -- affiche 6
            wait for 200 ns; BP0s<='1'; BP1s<='1'; BP2s<='1'; BP3s<='0'; -- affiche 7
            wait for 200 ns; BP0s<='0'; BP1s<='0'; BP2s<='0'; BP3s<='1'; -- affiche 8
            wait for 200 ns; BP0s<='1'; BP1s<='0'; BP2s<='0'; BP3s<='1'; -- affiche 9
            wait for 200 ns; BP0s<='0'; BP1s<='1'; BP2s<='0'; BP3s<='1'; -- affiche A (10)
            wait for 200 ns; BP0s<='1'; BP1s<='1'; BP2s<='0'; BP3s<='1'; -- affiche b (11)
            wait for 200 ns; BP0s<='0'; BP1s<='0'; BP2s<='1'; BP3s<='1'; -- affiche C (12)
            wait for 200 ns; BP0s<='1'; BP1s<='0'; BP2s<='1'; BP3s<='1'; -- affiche d (13)
            wait for 200 ns; BP0s<='0'; BP1s<='1'; BP2s<='1'; BP3s<='1'; -- affiche E (14)
            wait for 200 ns; BP0s<='1'; BP1s<='1'; BP2s<='1'; BP3s<='1'; -- affiche F (15)
        end loop boucle;
    end process SimuEntrees;

end testbench_arch;
