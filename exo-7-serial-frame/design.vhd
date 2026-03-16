-- ============================================================
-- Exercice 7 : Générateur de trame série — version registre à décalage
-- ============================================================
-- But : transmettre un mot de 8 bits sur une ligne série (DAT)
--       synchronisé sur une horloge (CLKIN), déclenché par GO.
--
-- Ordre de transmission :
--   Position : 0    1    2    3    4    5    6    7
--   Bit envoyé: A1   0    B1   C1   0    D1   1    E1
--
-- Principe du registre à décalage (shift register) :
--   On charge la trame complète dans un std_logic_vector 8 bits :
--       shift_reg <= A1 & '0' & B1 & C1 & '0' & D1 & '1' & E1
--   Puis à chaque coup d'horloge on sort le MSB (bit 7) sur DAT
--   et on décale le registre d'un cran vers la gauche.
--   Avantage : plus de case/when, la trame est lisible en une seule ligne.
--
-- Machine d'états (FSM) à 2 états :
--   IDLE     -> attend le front montant de GO
--   TRANSMIT -> décale et sort les bits, puis cycle flush
--
-- Compteur bit_cnt (0 à 8) :
--   0..7 : décalage actif (un bit sorti par cycle)
--   8    : cycle flush — CLKOUT reste actif une dernière fois pour que
--          le récepteur puisse capturer E1 (placé sur DAT au cycle 7)
--
-- Chronogramme (N = front montant où GO est détecté) :
--   Front N   : GO détecté, shift_reg chargé, état -> TRANSMIT
--   Front N+1 : tx_active='1', DAT <- A1, décalage, cnt=1
--   Front N+2 : CLKOUT monte, récepteur lit A1 ;  DAT <- '0', cnt=2
--   Front N+3 : CLKOUT monte, récepteur lit '0';  DAT <- B1,  cnt=3
--   ...
--   Front N+8 : CLKOUT monte, récepteur lit '1';  DAT <- E1,  cnt=8
--   Front N+9 : CLKOUT monte, récepteur lit E1 (flush);
--               tx_active='0', état -> IDLE
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   -- pour le type unsigned (compteur)

entity SerialFrameGen is
    port (
        CLKIN  : in  std_logic;   -- horloge maître (toujours active)
        GO     : in  std_logic;   -- signal de départ (détection de front montant)
        A1     : in  std_logic;   -- bit de données, position 0 de la trame
        B1     : in  std_logic;   -- bit de données, position 2 de la trame
        C1     : in  std_logic;   -- bit de données, position 3 de la trame
        D1     : in  std_logic;   -- bit de données, position 5 de la trame
        E1     : in  std_logic;   -- bit de données, position 7 de la trame
        DAT    : out std_logic;   -- sortie série (données)
        CLKOUT : out std_logic    -- horloge de sortie (active seulement pendant la trame)
    );
end SerialFrameGen;

architecture Behavioral of SerialFrameGen is

    -- Machine d'états : deux états
    type state_t is (IDLE, TRANSMIT);
    signal state : state_t := IDLE;

    -- Détection du front montant de GO :
    -- on compare GO avec sa valeur du cycle précédent (go_prev).
    -- Front montant détecté quand GO='1' et go_prev='0'.
    signal go_prev : std_logic := '0';

    -- Registre à décalage 8 bits : contient la trame complète.
    -- Chargé au moment du GO, décalé d'un cran à gauche à chaque cycle.
    -- Le MSB (bit 7) est toujours le prochain bit à transmettre.
    signal shift_reg : std_logic_vector(7 downto 0) := (others => '0');

    -- Compteur de cycles : 0..7 = décalages actifs, 8 = flush.
    -- 4 bits suffisent pour compter jusqu'à 8.
    signal bit_cnt : unsigned(3 downto 0) := (others => '0');

    -- Registres de sortie (flip-flops) pour éviter les glitches
    signal dat_reg   : std_logic := '0';   -- alimente DAT
    signal tx_active : std_logic := '0';   -- '1' pendant la transmission, gate CLKOUT

begin

    DAT    <= dat_reg;
    -- CLKOUT = CLKIN masqué par tx_active (flip-flop) : sans glitch.
    -- CLKOUT = '0' en IDLE, CLKOUT = CLKIN en TRANSMIT.
    CLKOUT <= CLKIN and tx_active;

    process(CLKIN)
    begin
        if rising_edge(CLKIN) then

            go_prev <= GO;   -- retarder GO d'un cycle pour détecter le front montant

            case state is

                -- ==========================================
                -- IDLE : attente du front montant de GO
                -- ==========================================
                when IDLE =>
                    dat_reg   <= '0';
                    tx_active <= '0';
                    bit_cnt   <= (others => '0');

                    if GO = '1' and go_prev = '0' then
                        -- Front montant de GO détecté.
                        -- Charger la trame complète dans le registre à décalage.
                        -- L'opérateur & concatène les bits dans l'ordre de transmission :
                        --   shift_reg(7)=A1  shift_reg(6)='0'  shift_reg(5)=B1 ...
                        shift_reg <= A1 & '0' & B1 & C1 & '0' & D1 & '1' & E1;
                        state <= TRANSMIT;
                    end if;

                -- ==========================================
                -- TRANSMIT : décalage et envoi bit par bit
                -- ==========================================
                when TRANSMIT =>

                    tx_active <= '1';   -- CLKOUT suit CLKIN

                    if bit_cnt = 8 then
                        -- Cycle flush terminé : le récepteur a capturé E1.
                        -- Retour en IDLE.
                        state     <= IDLE;
                        tx_active <= '0';
                        bit_cnt   <= (others => '0');

                    else
                        -- Sortir le MSB sur DAT (c'est le prochain bit à transmettre)
                        dat_reg <= shift_reg(7);

                        -- Décaler le registre d'un cran vers la gauche :
                        -- shift_reg(7) est consommé, shift_reg(6) devient le nouveau MSB,
                        -- on insère '0' à droite (valeur indifférente, la trame est déjà dans les bits hauts)
                        shift_reg <= shift_reg(6 downto 0) & '0';

                        bit_cnt <= bit_cnt + 1;
                    end if;

            end case;
        end if;
    end process;

end Behavioral;
