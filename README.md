# Composants Programmables — Aide-mémoire VHDL

## Structure d'un fichier VHDL

```vhdl
library ieee;
use ieee.std_logic_1164.all;   -- types std_logic / std_logic_vector
use ieee.numeric_std.all;      -- unsigned / signed (pour les calculs)
use ieee.std_logic_signed.all; -- +/- directement sur std_logic_vector

entity MonComposant is
    port (
        A, B  : in  std_logic;
        S     : out std_logic
    );
end entity;

architecture NomArchi of MonComposant is
    -- déclarations internes (signaux, composants...)
begin
    -- instructions concurrentes ou process
end NomArchi;
```

## Les niveaux de description

### Dataflow (flot de données)
Instructions **concurrentes**, pas de logique séquentielle.
Toutes les lignes s'exécutent "en même temps" (comme des fils).

```vhdl
S     <= A and B;
CARRY <= A xor B;
```

### Structurel
Décrit le **câblage** entre composants (netlist).
Nécessite : déclaration du composant + signaux internes + `port map`.

```vhdl
component HalfAdd
    port (A, B : in std_logic; SUM, CARRY : out std_logic);
end component;

signal S1, C1 : std_logic;   -- fils internes

inst1 : HalfAdd port map (A => X, B => Y, SUM => S1, CARRY => C1);
```

> Le sous-composant doit être déclaré **avant** l'entité qui l'utilise dans le même fichier.

### Comportemental
Utilise des **process** avec des instructions séquentielles.

```vhdl
process(clk)
begin
    if rising_edge(clk) then
        Q <= D;
    end if;
end process;
```

> Une architecture peut **mélanger** les trois niveaux.

## Le Process

| Règle | Détail |
|-------|--------|
| S'exécute quand | un signal de la **liste de sensibilité** change |
| Instructions internes | **séquentielles** (comme un programme) |
| Assignation des signaux | effective seulement **en fin de process** |
| Plusieurs process | s'exécutent en **parallèle** |
| Un signal | ne peut être piloté que par **un seul** process |

```vhdl
process(clk, reset)          -- liste de sensibilité
begin
    if reset = '0' then      -- reset asynchrone actif-bas
        Q <= '0';
    elsif rising_edge(clk) then
        Q <= D;              -- capturé au front montant
    end if;
end process;
```

Détection de front montant — deux syntaxes équivalentes :
```vhdl
if clk'event and clk = '1' then ...   -- ancienne syntaxe (cours)
if rising_edge(clk) then ...           -- syntaxe moderne (recommandée)
```

## Les objets VHDL

| Classe | Déclaré où | Opérateur | Usage |
|--------|-----------|-----------|-------|
| `constant` | entité, architecture, process | `:=` | valeur fixe |
| `signal` | architecture | `<=` | connexion physique entre composants |
| `variable` | process uniquement | `:=` | calcul interne, pas de représentation physique |

```vhdl
constant TAILLE : integer := 8;
signal   compteur : std_logic_vector(7 downto 0) := (others => '0');

process(clk)
    variable tmp : integer := 0;   -- variable locale au process
begin
    tmp := tmp + 1;    -- := immédiat (dans le process)
    S <= compteur(7);  -- <= différé (en fin de process)
end process;
```

> `signal <= ...` : la nouvelle valeur est visible au **prochain delta** (fin de process).
> `variable := ...` : la nouvelle valeur est **immédiate** dans le process.

## Les types courants

```vhdl
signal a : std_logic;                        -- 1 bit : '0' '1' 'X' 'Z'
signal b : std_logic_vector(7 downto 0);     -- bus 8 bits, b(7)=MSB
signal c : unsigned(3 downto 0);             -- 4 bits non signé (0..15)
signal d : integer range 0 to 255;           -- entier borné
```

Valeurs spéciales de `std_logic` : `'0'` `'1'` `'X'` (inconnu) `'Z'` (haute impédance) `'U'` (non initialisé)

## Les opérateurs

### Logiques
```vhdl
and  or  xor  nand  nor  not
S <= A and (B or not C);
```

### Arithmétiques (nécessite une librairie)
```vhdl
use ieee.numeric_std.all;
signal cnt : unsigned(7 downto 0);
cnt <= cnt + 1;   -- incrémentation
```

### Relationnels (dans les conditions)
```vhdl
if A = B then ...      -- égalité
if cnt /= 8 then ...   -- différent
if cnt >= 4 then ...
```

### Concaténation `&`
```vhdl
signal trame : std_logic_vector(7 downto 0);
trame <= A1 & '0' & B1 & C1 & '0' & D1 & '1' & E1;
--       [7]  [6]  [5]  [4]  [3]  [2]  [1]  [0]
```

### Décalage
```vhdl
sll  -- shift left logical  (rempli de '0' à droite)
srl  -- shift right logical
-- Ou avec slicing :
reg <= reg(6 downto 0) & '0';   -- décalage gauche manuel (plus portable)
```

### Association (port map)
```vhdl
inst : MonComp port map (EntiteAppelee => SignalLocal, ...);
--                       I2 => B  (I2: port de l'entité, B: signal du parent)
```

## Patterns fréquents à l'exam

### Bascule D simple
```vhdl
if rising_edge(clk) then
    Q <= D;
end if;
```

### Compteur avec reset asynchrone actif-bas
```vhdl
if reset = '0' then
    cnt <= (others => '0');
elsif rising_edge(clk) then
    cnt <= cnt + 1;
end if;
```

### Détection de front montant sur un signal quelconque
```vhdl
signal go_prev : std_logic := '0';
...
go_prev <= GO;                          -- retarder d'un cycle
if GO = '1' and go_prev = '0' then      -- front montant détecté
```

### Multiplexeur avec `with ... select`
```vhdl
with sel select
    S <= A when "00",
         B when "01",
         C when "10",
         D when others;
```

### Registre à décalage (shift register)
```vhdl
signal sr : std_logic_vector(7 downto 0);
sr   <= sr(6 downto 0) & '0';   -- décalage à gauche, MSB sorti
DAT  <= sr(7);                   -- sortir le MSB
```

### Machine d'états (FSM)
```vhdl
type state_t is (IDLE, ACTIF, DONE);
signal state : state_t := IDLE;

process(clk)
begin
    if rising_edge(clk) then
        case state is
            when IDLE  => if condition then state <= ACTIF; end if;
            when ACTIF => ... state <= DONE;
            when DONE  => state <= IDLE;
        end case;
    end if;
end process;
```

## Exercices du cours

| Dossier | Composant | Niveau | Concept clé |
|---------|-----------|--------|-------------|
| `exo-0-add` | Porte ET | Dataflow | affectation concurrente |
| `exo-1-demi-add` | Half Adder | Dataflow | XOR, AND |
| `exo-2-full-add` | Full Adder | Structurel | instanciation, signaux internes |
| `exo-3-bascule-d` | Bascule D | Comportemental | process, front montant |
| `exo-4-compteur` | Compteur 24 bits | Comportemental | compteur, LEDs ralentissement |
| `exo-5-decodeur-7seg` | Décodeur 7 seg | Dataflow | `with/select`, logique inversée |
| `exo-6-double-affichage` | Compteur + 7 seg | Structurel + Comportemental | reset asynchrone, instanciation |
| `exo-7-serial-frame` | Trame série | Comportemental | FSM, shift register, détection front |
