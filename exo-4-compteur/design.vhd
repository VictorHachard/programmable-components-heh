-- ============================================================
-- Exercice 4 : Compteur 24 bits avec affichage sur LEDs
-- ============================================================
-- But : compter les impulsions d'horloge sur 24 bits et afficher
--       les 5 bits de poids fort sur des LEDs.
--
-- Principe du ralentissement visible :
--   Si clk = 50 MHz (période = 20 ns), le compteur Leds s'incrémente
--   50 000 000 fois par seconde. Les LEDs sont connectées aux bits
--   19..23 (les plus hauts), donc elles changent à des fréquences
--   beaucoup plus lentes, visibles à l'œil nu :
--     LED5 (bit 19) : change toutes les 2^19 cycles ≈ 10 fois/s
--     LED4 (bit 20) : ≈ 5 fois/s
--     LED3 (bit 21) : ≈ 2,4 fois/s
--     LED2 (bit 22) : ≈ 1,2 fois/s
--     LED1 (bit 23) : ≈ 0,6 fois/s  (une fois toutes les ~1,7 s)
--
-- Compteur sur 24 bits : valeurs 0 à 16 777 215, puis retour à 0.
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;   -- permet l'addition sur std_logic_vector
use ieee.numeric_std.all;        -- types unsigned/signed (bonne pratique)

-- Déclaration de l'entité
entity Compteur is
    port (
        clk                          : in  std_logic;          -- horloge principale
        LED1, LED2, LED3, LED4, LED5 : out std_logic := '0'   -- sorties vers LEDs
    );
end entity;

architecture ArchCompteur of Compteur is

    -- Registre interne 24 bits : stocke la valeur courante du compteur
    -- Initialisé implicitement à 0 au démarrage de la simulation
    signal Leds : std_logic_vector (23 downto 0);

begin

    -- Affectations concurrentes : chaque LED est connectée à un bit du compteur.
    -- On prend les bits de poids fort pour obtenir un clignotement lent.
    -- (bit 23 = le plus lent, bit 19 = le plus rapide parmi les 5)
    LED1 <= Leds(23);   -- fréquence la plus basse (change le moins souvent)
    LED2 <= Leds(22);
    LED3 <= Leds(21);
    LED4 <= Leds(20);
    LED5 <= Leds(19);   -- fréquence la plus haute parmi les 5 LEDs

    -- Process synchrone : s'exécute sur chaque front montant de clk
    proc : process (clk)
    begin
        if (clk'event and clk = '1') then
            Leds <= Leds + 1;   -- incrément du compteur à chaque coup d'horloge
            -- Au débordement (16777215 + 1), le compteur repasse à 0 automatiquement
        end if;
    end process proc;

end ArchCompteur;
