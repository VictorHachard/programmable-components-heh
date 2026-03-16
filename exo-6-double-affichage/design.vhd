-- ============================================================
-- Exercice 6 : Double affichage — compteur 24 bits + 7 segments
-- ============================================================
-- Ce fichier contient DEUX entités (dans l'ordre d'utilisation) :
--   1. SSegments       : décodeur 7 segments (réutilisé de l'exo 5)
--   2. DoubleAffichage : circuit principal (instancie SSegments)
--
-- Principe général :
--   Un compteur 24 bits s'incrémente à chaque front montant de clk.
--   Les bits [23:20] du compteur sont passés (inversés) à SSegments
--   pour afficher un chiffre qui change lentement à l'écran.
--   Le reset actif-bas remet le compteur à zéro.
--
-- Pourquoi bits 20..23 ?
--   Avec clk=50 MHz, bit 20 change toutes les 2^20 / 50e6 ≈ 21 ms
--   => l'affichage change environ 47 fois par seconde (visible à l'œil)
-- ============================================================

-- ============================================================
-- Entité 1 : SSegments (décodeur 7 segments, logique actif-bas)
-- ============================================================
-- Identique à l'exo 5 mais renommé SSegments pour être instancié
-- en tant que composant dans DoubleAffichage.
-- ============================================================
library ieee;
use ieee.std_logic_1164.all;

entity SSegments is
    port (
        BP0, BP1, BP2, BP3       : in  std_logic;   -- 4 bits d'entrée (actifs-bas)
        DP, G, F, E, D, C, B, A : out std_logic    -- 8 segments de sortie (actifs-bas)
    );
end entity;

architecture ArchSSegments of SSegments is

    -- Vecteur interne pour les 8 segments (SS(0)=A ... SS(7)=DP)
    signal SS      : std_logic_vector (7 downto 0);

    -- Regroupement des 4 entrées en vecteur
    signal Boutons : std_logic_vector (3 downto 0);

begin

    -- Connexion du vecteur SS vers les ports de sortie individuels
    A  <= SS(0);
    B  <= SS(1);
    C  <= SS(2);
    D  <= SS(3);
    E  <= SS(4);
    F  <= SS(5);
    G  <= SS(6);
    DP <= SS(7);

    -- Regroupement des entrées
    Boutons(0) <= BP0;
    Boutons(1) <= BP1;
    Boutons(2) <= BP2;
    Boutons(3) <= BP3;

    -- Table de décodage 7 segments.
    -- NOT Boutons : les entrées sont actives-bas (0 = touche enfoncée)
    -- NOT "..." sur les constantes : les segments sont actifs-bas (0 = allumé)
    with NOT Boutons select
        SS <=   NOT "00111111" when "0000",   -- 0
                NOT "00000110" when "0001",   -- 1
                NOT "01011011" when "0010",   -- 2
                NOT "01001111" when "0011",   -- 3
                NOT "01100110" when "0100",   -- 4
                NOT "01101101" when "0101",   -- 5
                NOT "01111101" when "0110",   -- 6
                NOT "00000111" when "0111",   -- 7
                NOT "01111111" when "1000",   -- 8
                NOT "01101111" when "1001",   -- 9
                NOT "01110111" when "1010",   -- A (10)
                NOT "01011110" when "1011",   -- b (11)
                NOT "00111001" when "1100",   -- C (12)
                NOT "01111100" when "1101",   -- d (13)
                NOT "01111001" when "1110",   -- E (14)
                NOT "01110001" when "1111",   -- F (15)
                "00000000"     when others;   -- tous éteints

end ArchSSegments;

-- ============================================================
-- Entité 2 : DoubleAffichage (circuit principal)
-- ============================================================
-- Instancie SSegments (architecture STRUCTURELLE).
-- Contient un compteur 24 bits et une remise à zéro synchrone.
-- ============================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;   -- permet "NBRE + 1" sur std_logic_vector
use ieee.numeric_std.all;

entity DoubleAffichage is
    port (
        clk, reset               : in  std_logic;          -- horloge + reset actif-bas
        DP, G, F, E, D, C, B, A : out std_logic := '0'   -- segments vers l'afficheur
    );
end entity;

architecture ArchDoubleAffichage of DoubleAffichage is

    -- Déclaration du composant SSegments (défini plus haut dans ce même fichier)
    component SSegments is
        port (
            BP0, BP1, BP2, BP3       : in  std_logic;
            DP, G, F, E, D, C, B, A : out std_logic
        );
    end component SSegments;

    -- Compteur interne 24 bits (0 à 16 777 215)
    signal NBRE : std_logic_vector (23 downto 0);

begin

    -- Process synchrone : compteur avec reset actif-bas
    proc : process (clk, reset)
    begin
        if reset = '0' then
            -- Reset ASYNCHRONE actif-bas : remet NBRE à 0 immédiatement
            -- (pas besoin d'attendre un front d'horloge)
            NBRE <= "000000000000000000000000";
        elsif (clk'event and clk = '1') then
            -- Front montant de clk : incrémentation du compteur
            NBRE <= NBRE + 1;
        end if;
    end process proc;

    -- Instanciation du décodeur 7 segments.
    -- On passe 4 bits consécutifs du compteur (inversés car actifs-bas).
    --
    -- CHOIX DES BITS :
    --   Simulation  (clk testbench ≈ 10 MHz, période 100 ns) :
    --     bits 3-6  => bit 3 change toutes les 800 ns  : visible dans EPWave
    --   Vrai matériel (clk FPGA = 50 MHz) :
    --     bits 19-22 => bit 19 change toutes les ~21 ms : visible à l'oeil nu
    --
    -- Ici réglé sur bits 3-6 pour que la simulation fonctionne.
    -- Pour la synthèse sur carte, remplacer par NBRE(19..22) ou NBRE(20..23).
    inst_SSegments : SSegments port map (
        NOT NBRE(3),    -- BP0 reçoit l'inverse du bit 3
        NOT NBRE(4),    -- BP1 reçoit l'inverse du bit 4
        NOT NBRE(5),    -- BP2 reçoit l'inverse du bit 5
        NOT NBRE(6),    -- BP3 reçoit l'inverse du bit 6 (poids fort)
        DP, G, F, E, D, C, B, A   -- sorties vers les segments
    );

end ArchDoubleAffichage;
