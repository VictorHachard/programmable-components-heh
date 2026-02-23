library ieee;
use ieee.std_logic_1164.all;

entity DemiAdd is
    port (
        ENTREE1, ENTREE2 : in std_logic;
        SORTIE, CARRY : out std_logic
    );
end entity;

architecture arc of DemiAdd is
begin
    SORTIE <= ((not ENTREE1 and ENTREE2) or (ENTREE1 and not ENTREE2));
    CARRY <= (ENTREE1 and ENTREE2);
end arc;