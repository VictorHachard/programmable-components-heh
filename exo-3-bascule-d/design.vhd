-- ============================================================
-- Exercice 3 : Bascule D (D Flip-Flop)
-- ============================================================
-- But : mémoriser un bit. C'est le premier circuit SÉQUENTIEL
--       (la sortie dépend du passé, pas seulement des entrées actuelles).
--
-- Comportement :
--   Sur chaque FRONT MONTANT de clk :
--     Q  <= D         (Q prend la valeur de D)
--     NQ <= NOT D     (NQ est toujours l'inverse de Q)
--
--   Entre deux fronts, Q garde sa valeur : c'est la mémoire.
--
-- Chronogramme exemple :
--   clk :  ___|‾|_|‾|_|‾|_
--   D   :  ___0_____1_____
--   Q   :  ___0_____0__1__   <- Q change UNIQUEMENT au front montant
--   NQ  :  ___1_____1__0__
--
-- Syntaxe VHDL pour le front montant :
--   clk'event and clk = '1'   (équivalent à rising_edge(clk))
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

-- Déclaration de l'entité : bascule D simple
entity BasculeD is
    port (
        clk : in  std_logic;              -- horloge (front montant actif)
        D   : in  std_logic;              -- donnée à mémoriser
        q   : out std_logic := '0';       -- sortie normale (initialisée à 0)
        nq  : out std_logic := '0'        -- sortie complémentée (NOT q)
    );
end entity;

-- Architecture : un seul process synchrone sur l'horloge
architecture ArchBasculeD of BasculeD is

begin
    -- Process sensible à clk uniquement (pas besoin de D dans la liste de sensibilité
    -- car on ne lit D que sur front montant)
    proc : process (clk)
    begin
        -- "clk'event and clk = '1'" = détection du front MONTANT de clk
        -- C'est la façon classique d'écrire ce que fait rising_edge(clk)
        if (clk'event and clk = '1') then
            q  <= D;        -- mémoriser D dans q
            nq <= not D;    -- nq est toujours l'inverse de q
        end if;
        -- Si pas de front montant : q et nq conservent leurs valeurs (mémoire)
    end process proc;

end ArchBasculeD;
