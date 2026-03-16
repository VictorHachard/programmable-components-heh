-- ============================================================
-- Exercice 1 : Demi-additionneur (Half Adder)
-- ============================================================
-- But : additionner deux bits A et B sans retenue entrante.
--       Produit deux sorties :
--         SORTIE = bit de somme  (A XOR B)
--         CARRY  = retenue de sortie (A AND B)
--
-- Table de vérité :
--   ENTREE1 | ENTREE2 | SORTIE (somme) | CARRY (retenue)
--   --------|---------|----------------|----------------
--      0    |    0    |       0        |       0
--      0    |    1    |       1        |       0
--      1    |    0    |       1        |       0
--      1    |    1    |       0        |       1   <-- 1+1 = 10 en binaire
--
-- Note : SORTIE utilise l'expression booléenne du XOR développée :
--        XOR = (NOT A AND B) OR (A AND NOT B)
--        On aurait aussi pu écrire directement : SORTIE <= ENTREE1 xor ENTREE2;
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;   -- bibliothèque standard VHDL

-- Déclaration de l'entité : ports du demi-additionneur
entity DemiAdd is
    port (
        ENTREE1, ENTREE2 : in  std_logic;   -- les deux bits à additionner
        SORTIE           : out std_logic;   -- bit de somme (résultat)
        CARRY            : out std_logic    -- retenue de sortie
    );
end entity;

-- Architecture comportementale : expressions logiques directes
architecture arc of DemiAdd is
begin
    -- Somme = XOR écrit sous forme développée :
    --   (NOT E1 AND E2) => cas 0+1
    --   (E1 AND NOT E2) => cas 1+0
    --   OR entre les deux car les deux cas donnent SORTIE=1
    SORTIE <= ((not ENTREE1 and ENTREE2) or (ENTREE1 and not ENTREE2));

    -- Retenue = AND : vaut 1 seulement si les deux entrées valent 1
    CARRY <= (ENTREE1 and ENTREE2);
end arc;
