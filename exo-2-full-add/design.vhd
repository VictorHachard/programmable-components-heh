-- ============================================================
-- Exercice 2 : Additionneur complet (Full Adder) — architecture structurelle
-- ============================================================
-- Ce fichier contient DEUX entités dans l'ordre suivant :
--   1. HalfAdd  : demi-additionneur (sous-composant)
--   2. FullAdd  : additionneur complet, construit à partir de 2× HalfAdd
--
-- RÈGLE IMPORTANTE en VHDL :
--   Un sous-composant doit être déclaré AVANT l'entité qui l'utilise
--   dans le même fichier. C'est pourquoi HalfAdd est en premier.
--
-- Principe du Full Adder :
--   SUM   = A XOR B XOR Cin
--   CARRY = (A AND B) OR ((A XOR B) AND Cin)
--
--   Construction avec deux HalfAdd :
--     HA1 : additionne A + B     => somme partielle S1, retenue C1
--     HA2 : additionne S1 + Cin  => somme finale SUM, retenue C2
--     CARRY final = C1 OR C2     (les deux retenues possibles)
--
-- Table de vérité complète :
--   A | B | Cin | SUM | CARRY
--   --|---|-----|-----|------
--   0 | 0 |  0  |  0  |   0
--   0 | 0 |  1  |  1  |   0
--   0 | 1 |  0  |  1  |   0
--   0 | 1 |  1  |  0  |   1
--   1 | 0 |  0  |  1  |   0
--   1 | 0 |  1  |  0  |   1
--   1 | 1 |  0  |  0  |   1
--   1 | 1 |  1  |  1  |   1
-- ============================================================

-- ------------------------------------------------------------
-- Entité 1 : HalfAdd (demi-additionneur, sans retenue entrante)
-- ------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity HalfAdd is
    port (
        A, B  : in  std_logic;   -- les deux bits à additionner
        SUM   : out std_logic;   -- bit de somme = A XOR B
        CARRY : out std_logic    -- retenue de sortie = A AND B
    );
end entity;

-- Architecture comportementale du HalfAdd
architecture arc of HalfAdd is
begin
    SUM   <= A xor B;    -- XOR : somme sans retenue
    CARRY <= A and B;    -- AND : retenue (1 seulement si A=1 ET B=1)
end architecture;

-- ------------------------------------------------------------
-- Entité 2 : FullAdd (additionneur complet avec retenue entrante)
-- Architecture STRUCTURELLE : on instancie deux HalfAdd
-- ------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity FullAdd is
    port (
        A, B, Cin : in  std_logic;   -- deux bits + retenue entrante
        SUM       : out std_logic;   -- bit de somme finale
        CARRY     : out std_logic    -- retenue de sortie finale
    );
end entity;

architecture structural of FullAdd is

    -- Déclaration du composant HalfAdd à utiliser (doit correspondre à l'entité)
    component HalfAdd
        port (
            A, B   : in  std_logic;
            SUM    : out std_logic;
            CARRY  : out std_logic
        );
    end component;

    -- Signaux internes pour connecter les deux HalfAdd entre eux
    signal S1  : std_logic;   -- somme intermédiaire (sortie SUM de HA1)
    signal C1  : std_logic;   -- retenue intermédiaire de HA1 (A AND B)
    signal C2  : std_logic;   -- retenue intermédiaire de HA2 (S1 AND Cin)

begin

    -- Instance 1 : additionne A et B
    --   SUM  = A XOR B  -> stocké dans S1 (signal interne)
    --   CARRY = A AND B -> stocké dans C1
    HA1 : HalfAdd
        port map (
            A     => A,
            B     => B,
            SUM   => S1,    -- résultat partiel transmis à HA2
            CARRY => C1     -- première retenue possible
        );

    -- Instance 2 : additionne la somme partielle S1 avec la retenue entrante Cin
    --   SUM   = S1 XOR Cin -> c'est la somme finale
    --   CARRY = S1 AND Cin -> deuxième retenue possible
    HA2 : HalfAdd
        port map (
            A     => S1,
            B     => Cin,
            SUM   => SUM,   -- sortie finale
            CARRY => C2     -- deuxième retenue possible
        );

    -- Retenue de sortie finale : vaut 1 si au moins une des deux retenues vaut 1
    -- (C1 et C2 ne peuvent pas être 1 simultanément, donc OR = XOR ici)
    CARRY <= C1 or C2;

end architecture;
