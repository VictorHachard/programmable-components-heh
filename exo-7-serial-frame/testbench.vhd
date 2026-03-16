-- ============================================================
-- Testbench pour SerialFrameGen (générateur de trame série)
-- ============================================================
-- Deux process :
--   1. clk_proc  : horloge continue à 50 MHz (période 20 ns)
--   2. stim_proc : pilote GO et les données, boucle infinie
--
-- Pour chaque vecteur de test, la séquence est :
--   200 ns : mise en place des données (A1..E1)
--   200 ns : GO='1' (le front montant déclenche la FSM)
--   200 ns : GO='0'
--   400 ns : attente de fin de trame (8 bits × 20 ns ≈ 180 ns + marge)
-- Total par test : 1000 ns
--
-- Trames attendues sur DAT (vérifier dans EPWave sur CLKOUT) :
--   Test 1 : A1=1 B1=0 C1=1 D1=1 E1=0  =>  1 0 0 1 0 1 1 0
--   Test 2 : A1=1 B1=1 C1=1 D1=1 E1=1  =>  1 0 1 1 0 1 1 1
--   Test 3 : A1=0 B1=0 C1=0 D1=0 E1=0  =>  0 0 0 0 0 0 1 0
--                                                         ^-- bit 6 est TOUJOURS 1 (fixe)
--
-- Comment lire EPWave :
--   CLKOUT = '1' seulement pendant la transmission (8 coups d'horloge + flush)
--   DAT change sur front montant de CLKIN
--   Le récepteur doit lire DAT sur chaque front montant de CLKOUT
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

-- Entité vide : obligatoire pour un testbench (pas de ports)
entity SerialFrameGen_tb is
end SerialFrameGen_tb;

architecture Sim of SerialFrameGen_tb is

    -- Déclaration du composant à tester
    component SerialFrameGen is
        port (
            CLKIN  : in  std_logic;
            GO     : in  std_logic;
            A1     : in  std_logic;
            B1     : in  std_logic;
            C1     : in  std_logic;
            D1     : in  std_logic;
            E1     : in  std_logic;
            DAT    : out std_logic;
            CLKOUT : out std_logic
        );
    end component;

    -- Signaux internes du testbench (suffixe _in pour entrées, _out pour sorties)
    signal clkin_in   : std_logic := '0';
    signal go_in      : std_logic := '0';
    signal a1_in      : std_logic := '0';
    signal b1_in      : std_logic := '0';
    signal c1_in      : std_logic := '0';
    signal d1_in      : std_logic := '0';
    signal e1_in      : std_logic := '0';
    signal dat_out    : std_logic;
    signal clkout_out : std_logic;

begin

    -- Instanciation du composant (UUT = Unit Under Test)
    uut : SerialFrameGen port map (
        CLKIN  => clkin_in,
        GO     => go_in,
        A1     => a1_in,
        B1     => b1_in,
        C1     => c1_in,
        D1     => d1_in,
        E1     => e1_in,
        DAT    => dat_out,
        CLKOUT => clkout_out
    );

    -- Générateur d'horloge : période 20 ns (50 MHz), boucle infinie
    clk_proc : process
    begin
        loop
            clkin_in <= '0'; wait for 10 ns;   -- demi-période basse
            clkin_in <= '1'; wait for 10 ns;   -- demi-période haute (front montant)
        end loop;
    end process;

    -- Process de stimulus : envoie 3 trames différentes en boucle infinie
    stim_proc : process
    begin
        loop

            -- ================================================
            -- Test 1 : A1=1 B1=0 C1=1 D1=1 E1=0
            -- Trame attendue : 1  0  0  1  0  1  1  0
            --                  A1 0  B1 C1 0  D1 1  E1
            -- ================================================
            a1_in <= '1'; b1_in <= '0'; c1_in <= '1';
            d1_in <= '1'; e1_in <= '0';
            wait for 200 ns;   -- laisser les données se stabiliser

            go_in <= '1';      -- front montant de GO : déclenche la FSM
            wait for 20 ns;    -- une seule période d'horloge suffit (impulsion propre)
            go_in <= '0';      -- GO redescend, la trame est déjà lancée
            wait for 400 ns;   -- attente fin de trame (9 cycles × 20 ns + marge)

            wait for 200 ns;   -- retour en IDLE confirmé

            -- ================================================
            -- Test 2 : A1=1 B1=1 C1=1 D1=1 E1=1
            -- Trame attendue : 1  0  1  1  0  1  1  1
            --                  A1 0  B1 C1 0  D1 1  E1
            -- ================================================
            a1_in <= '1'; b1_in <= '1'; c1_in <= '1';
            d1_in <= '1'; e1_in <= '1';
            wait for 200 ns;

            go_in <= '1';
            wait for 20 ns;    -- impulsion propre : une période d'horloge
            go_in <= '0';
            wait for 400 ns;   -- attente fin de trame

            wait for 200 ns;

            -- ================================================
            -- Test 3 : A1=0 B1=0 C1=0 D1=0 E1=0
            -- Trame attendue : 0  0  0  0  0  0  1  0
            --                  A1 0  B1 C1 0  D1 1  E1
            -- ATTENTION : le bit 6 est TOUJOURS '1' (fixe dans la spec)
            --             même si toutes les données valent 0 !
            -- ================================================
            a1_in <= '0'; b1_in <= '0'; c1_in <= '0';
            d1_in <= '0'; e1_in <= '0';
            wait for 200 ns;

            go_in <= '1';
            wait for 20 ns;    -- impulsion propre : une période d'horloge
            go_in <= '0';
            wait for 400 ns;   -- attente fin de trame

            wait for 200 ns;

        end loop;
    end process;

end Sim;
