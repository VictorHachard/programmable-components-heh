-- ============================================================
-- Exercice 0 : Porte ET (AND gate)
-- ============================================================
-- But : circuit combinatoire minimal.
--       SORTIE = 1 seulement si ENTREE1 = 1 ET ENTREE2 = 1.
--
-- Table de vérité :
--   ENTREE1 | ENTREE2 | SORTIE
--   --------|---------|-------
--      0    |    0    |   0
--      0    |    1    |   0
--      1    |    0    |   0
--      1    |    1    |   1   <-- seul cas vrai
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;   -- bibliothèque standard VHDL pour std_logic

-- Déclaration de l'entité : définit les ports (= les "pattes") du composant
entity Test1 is
    port (
        ENTREE1, ENTREE2 : in  std_logic;   -- deux entrées 1 bit
        SORTIE           : out std_logic    -- une sortie 1 bit
    );
end entity;

-- Architecture comportementale : on décrit le comportement logique directement
architecture arc of Test1 is
begin
    -- Affectation concurrente (pas dans un process) :
    -- SORTIE est recalculée automatiquement dès qu'une entrée change.
    -- "and" = opérateur ET logique bit à bit en VHDL.
    SORTIE <= ENTREE1 and ENTREE2;
end arc;
