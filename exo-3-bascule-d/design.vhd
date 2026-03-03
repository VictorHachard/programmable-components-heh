library ieee;
use ieee.std_logic_1164.all;

entity BasculeD is
    port    (
        clk, D : in std_logic;
        q, nq : out std_logic := '0'
    );
end entity;

architecture ArchBasculeD of BasculeD is

    begin
        proc : process (clk)
        begin
            if(clk'event and clk = '1') then
                q <= D;
                nq <= not D;
            end if;
        end process proc;
    end ArchBasculeD;
