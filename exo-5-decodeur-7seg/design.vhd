-- ============================================================
-- Exercice 5 : Décodeur 7 segments
-- ============================================================
-- But : convertir un nombre 4 bits (0..15) en commandes pour
--       un afficheur 7 segments à logique INVERSÉE (actif-bas).
--
-- Double inversion :
--   1. Les boutons poussoirs BP0..BP3 sont ACTIFS-BAS sur la carte :
--      BP=0 signifie "enfoncé" => on inverte en entrée (NOT Boutons)
--      pour que Boutons(3:0) = 0000 signifie le chiffre 0.
--   2. Les segments A..G, DP sont ACTIFS-BAS sur la carte :
--      segment = 0 signifie "allumé" => on applique NOT sur les constantes.
--
-- Disposition des segments sur l'afficheur :
--         _
--        |_|   A=haut, B=droite-haut, C=droite-bas
--        |_|   D=bas,  E=gauche-bas,  F=gauche-haut, G=milieu
--              DP=point décimal
--
-- Format du vecteur SS (7 downto 0) AVANT inversion :
--   SS = DP G F E D C B A
--   bit 7=DP, bit 6=G, bit 5=F, bit 4=E, bit 3=D, bit 2=C, bit 1=B, bit 0=A
--
-- Exemple pour chiffre 0 : segments A B C D E F allumés, G éteint
--   Code positif : "00111111"  (A=1 B=1 C=1 D=1 E=1 F=1 G=0 DP=0)
--   Code envoyé  : NOT "00111111" = "11000000"  (actif-bas => 0 allume)
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

-- Déclaration de l'entité
entity Decodeur7Seg is
    port (
        BP0, BP1, BP2, BP3       : in  std_logic;   -- boutons (actifs-bas)
        DP, G, F, E, D, C, B, A : out std_logic    -- segments (actifs-bas)
    );
end entity;

architecture ArchDecodeur7Seg of Decodeur7Seg is

    -- Vecteur interne 8 bits pour les segments (avant affectation aux ports)
    -- SS(0)=A SS(1)=B SS(2)=C SS(3)=D SS(4)=E SS(5)=F SS(6)=G SS(7)=DP
    signal SS      : std_logic_vector (7 downto 0);

    -- Regroupement des 4 boutons en vecteur pour le select
    signal Boutons : std_logic_vector (3 downto 0);

begin

    -- Affectation des segments depuis le vecteur SS vers les ports de sortie
    A  <= SS(0);
    B  <= SS(1);
    C  <= SS(2);
    D  <= SS(3);
    E  <= SS(4);
    F  <= SS(5);
    G  <= SS(6);
    DP <= SS(7);

    -- Regroupement des boutons (BP0 = bit 0 = poids faible)
    Boutons(0) <= BP0;
    Boutons(1) <= BP1;
    Boutons(2) <= BP2;
    Boutons(3) <= BP3;

    -- Décodage : "with ... select" = multiplexeur
    -- NOT Boutons : inversion car boutons actifs-bas (BP=0 => touche enfoncée)
    -- NOT "..." sur les constantes : inversion car segments actifs-bas
    -- Les constantes sont les codes "positifs" des segments (1=allumé avant inversion)
    with NOT Boutons select
        SS <=   NOT "00111111" when "0000",   -- 0 : A B C D E F allumés
                NOT "00000110" when "0001",   -- 1 : B C allumés
                NOT "01011011" when "0010",   -- 2 : A B D E G allumés
                NOT "01001111" when "0011",   -- 3 : A B C D G allumés
                NOT "01100110" when "0100",   -- 4 : B C F G allumés
                NOT "01101101" when "0101",   -- 5 : A C D F G allumés
                NOT "01111101" when "0110",   -- 6 : A C D E F G allumés
                NOT "00000111" when "0111",   -- 7 : A B C allumés
                NOT "01111111" when "1000",   -- 8 : tous allumés
                NOT "01101111" when "1001",   -- 9 : A B C D F G allumés
                NOT "01110111" when "1010",   -- A (10) : A B C E F G
                NOT "01011110" when "1011",   -- b (11) : C D E F G
                NOT "00111001" when "1100",   -- C (12) : A D E F
                NOT "01111100" when "1101",   -- d (13) : B C D E G
                NOT "01111001" when "1110",   -- E (14) : A D E F G
                NOT "01110001" when "1111",   -- F (15) : A E F G
                "00000000"     when others;   -- tous éteints (cas impossible)

end ArchDecodeur7Seg;
