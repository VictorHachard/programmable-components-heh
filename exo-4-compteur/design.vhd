library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity Compteur is
    port    (
        clk : in std_logic;
        LED1, LED2, LED3, LED4, LED5 : out std_logic := '0'
    );
end entity;

architecture ArchCompteur of Compteur is

    signal Leds : std_logic_vector (23 downto 0);

    begin

        LED1 <= leds(23);
        LED2 <= leds(22);
        LED3 <= leds(21);
        LED4 <= leds(20);
        LED5 <= leds(19);

        proc : process (clk)
        begin
            if(clk'event and clk = '1') then
                Leds <= Leds + 1;
            end if;
        end process proc;

    end ArchCompteur;
