library ieee;
use ieee.std_logic_1164.all;

entity Decodeur7Seg is
    port    (
        BP0, BP1, BP2, BP3 : in std_logic;
        DP, G, F, E, D, C, B, A : out std_logic
    );
end entity;

architecture ArchDecodeur7Seg of Decodeur7Seg is

    signal SS      : std_logic_vector (7 downto 0);
    signal Boutons : std_logic_vector (3 downto 0);

    begin

        A  <= SS(0);
        B  <= SS(1);
        C  <= SS(2);
        D  <= SS(3);
        E  <= SS(4);
        F  <= SS(5);
        G  <= SS(6);
        DP <= SS(7);

        Boutons(0) <= BP0;
        Boutons(1) <= BP1;
        Boutons(2) <= BP2;
        Boutons(3) <= BP3;

        with NOT Boutons select
            SS <=   NOT "00111111" when "0000", -- 0
                    NOT "00000110" when "0001", -- 1
                    NOT "01011011" when "0010", -- 2
                    NOT "01001111" when "0011", -- 3
                    NOT "01100110" when "0100", -- 4
                    NOT "01101101" when "0101", -- 5
                    NOT "01111101" when "0110", -- 6
                    NOT "00000111" when "0111", -- 7
                    NOT "01111111" when "1000", -- 8
                    NOT "01101111" when "1001", -- 9
                    NOT "01110111" when "1010", -- A (10)
                    NOT "01011110" when "1011", -- b (11)
                    NOT "00111001" when "1100", -- C (12)
                    NOT "01111100" when "1101", -- d (13)
                    NOT "01111001" when "1110", -- E (14)
                    NOT "01110001" when "1111", -- F (15)
                    "00000000"     when others;

    end ArchDecodeur7Seg;
