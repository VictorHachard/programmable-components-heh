library ieee;
use ieee.std_logic_1164.all;

entity Test1 is
    port (
        ENTREE1, ENTREE2 : in std_logic;
        SORTIE : out std_logic
    );
end entity;

architecture arc of Test1 is
begin
    SORTIE <= ENTREE1 and ENTREE2;
end arc;