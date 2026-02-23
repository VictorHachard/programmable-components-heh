library ieee;
use ieee.std_logic_1164.all;

entity HalfAdd is
    port (
        A, B  : in  std_logic;
        SUM   : out std_logic;
        CARRY : out std_logic
    );
end entity;

architecture arc of HalfAdd is
begin
    SUM   <= A xor B;
    CARRY <= A and B;
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity FullAdd is
    port (
        A, B, Cin : in  std_logic;
        SUM       : out std_logic;
        CARRY     : out std_logic
    );
end entity;

architecture structural of FullAdd is

    component HalfAdd
        port (
            A, B   : in  std_logic;
            SUM    : out std_logic;
            CARRY  : out std_logic
        );
    end component;

    signal S1  : std_logic;
    signal C1  : std_logic;
    signal C2  : std_logic;

begin
    HA1 : HalfAdd
        port map (
            A => A,
            B => B,
            SUM => S1,
            CARRY => C1
        );
    HA2 : HalfAdd
        port map (
            A => S1,
            B => Cin,
            SUM => SUM,
            CARRY => C2
        );

    -- Final carry
    CARRY <= C1 or C2;

end architecture;
