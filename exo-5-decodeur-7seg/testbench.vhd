-- ============================================================
-- Testbench pour Decodeur7Seg
-- ============================================================
-- Parcourt les 16 valeurs possibles (0..F) en changeant les
-- boutons toutes les 200 ns.
--
-- LOGIQUE D'ENTRÉE :
--   Les boutons sont ACTIFS-BAS : BP='0' = touche enfoncée.
--   Le design fait "with NOT Boutons select", donc :
--     pour afficher le chiffre N, il faut NOT Boutons = binaire(N)
--     ce qui donne Boutons = NOT(binaire(N))
--     ce qui donne chaque BPx = inverse du bit correspondant de N
--
--   Exemple : afficher 0 (binaire 0000)
--     NOT Boutons = "0000" → Boutons = "1111" → BP0=1 BP1=1 BP2=1 BP3=1
--     (= aucun bouton enfoncé = valeur 0, logique active-bas)
--
--   Exemple : afficher 1 (binaire 0001)
--     NOT Boutons = "0001" → Boutons = "1110" → BP0=0 BP1=1 BP2=1 BP3=1
--     (= seulement BP0 enfoncé)
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
    -- Initialisés à '1' : aucun bouton enfoncé = affiche 0 au démarrage
    signal BP0s, BP1s, BP2s, BP3s            : std_logic := '1';
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
    -- Règle : BP = NOT(binaire du chiffre à afficher)
    --   BP0 = bit 0 (poids faible), BP3 = bit 3 (poids fort)
    --   BP='0' = bit à 1 dans la valeur (bouton enfoncé)
    --   BP='1' = bit à 0 dans la valeur (bouton relâché)
    SimuEntrees : process
    begin
        boucle : loop
            -- chiffre : BP3 BP2 BP1 BP0  (BP = inverse du bit)
            wait for 200 ns; BP3s<='1'; BP2s<='1'; BP1s<='1'; BP0s<='1'; -- affiche 0  (0000)
            wait for 200 ns; BP3s<='1'; BP2s<='1'; BP1s<='1'; BP0s<='0'; -- affiche 1  (0001)
            wait for 200 ns; BP3s<='1'; BP2s<='1'; BP1s<='0'; BP0s<='1'; -- affiche 2  (0010)
            wait for 200 ns; BP3s<='1'; BP2s<='1'; BP1s<='0'; BP0s<='0'; -- affiche 3  (0011)
            wait for 200 ns; BP3s<='1'; BP2s<='0'; BP1s<='1'; BP0s<='1'; -- affiche 4  (0100)
            wait for 200 ns; BP3s<='1'; BP2s<='0'; BP1s<='1'; BP0s<='0'; -- affiche 5  (0101)
            wait for 200 ns; BP3s<='1'; BP2s<='0'; BP1s<='0'; BP0s<='1'; -- affiche 6  (0110)
            wait for 200 ns; BP3s<='1'; BP2s<='0'; BP1s<='0'; BP0s<='0'; -- affiche 7  (0111)
            wait for 200 ns; BP3s<='0'; BP2s<='1'; BP1s<='1'; BP0s<='1'; -- affiche 8  (1000)
            wait for 200 ns; BP3s<='0'; BP2s<='1'; BP1s<='1'; BP0s<='0'; -- affiche 9  (1001)
            wait for 200 ns; BP3s<='0'; BP2s<='1'; BP1s<='0'; BP0s<='1'; -- affiche A  (1010)
            wait for 200 ns; BP3s<='0'; BP2s<='1'; BP1s<='0'; BP0s<='0'; -- affiche b  (1011)
            wait for 200 ns; BP3s<='0'; BP2s<='0'; BP1s<='1'; BP0s<='1'; -- affiche C  (1100)
            wait for 200 ns; BP3s<='0'; BP2s<='0'; BP1s<='1'; BP0s<='0'; -- affiche d  (1101)
            wait for 200 ns; BP3s<='0'; BP2s<='0'; BP1s<='0'; BP0s<='1'; -- affiche E  (1110)
            wait for 200 ns; BP3s<='0'; BP2s<='0'; BP1s<='0'; BP0s<='0'; -- affiche F  (1111)
        end loop boucle;
    end process SimuEntrees;

end testbench_arch;
