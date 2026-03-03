library ieee;
use ieee.std_logic_1164.all;

entity Decodeur7Seg_tb is
end Decodeur7Seg_tb;

architecture testbench_arch of Decodeur7Seg_tb is

    component Decodeur7Seg
        port (
            BP0, BP1, BP2, BP3       : in  std_logic;
            DP, G, F, E, D, C, B, A : out std_logic
        );
    end component;

    signal BP0s, BP1s, BP2s, BP3s   : std_logic := '0';
    signal DPs, Gs, Fs, Es, Ds, Cs, Bs, As : std_logic := '0';

    begin

    uut : Decodeur7Seg
    port map (
        BP0 => BP0s, BP1 => BP1s, BP2 => BP2s, BP3 => BP3s,
        DP  => DPs,  G   => Gs,   F   => Fs,   E   => Es,
        D   => Ds,   C   => Cs,   B   => Bs,   A   => As
    );

    SimuEntrees : process
        begin
            boucle : loop
                -- Les entrees sont actives-basses (BP=0 signifie enfonce)
                wait for 200ns; BP0s<='0'; BP1s<='0'; BP2s<='0'; BP3s<='0'; -- 0
                wait for 200ns; BP0s<='1'; BP1s<='0'; BP2s<='0'; BP3s<='0'; -- 1
                wait for 200ns; BP0s<='0'; BP1s<='1'; BP2s<='0'; BP3s<='0'; -- 2
                wait for 200ns; BP0s<='1'; BP1s<='1'; BP2s<='0'; BP3s<='0'; -- 3
                wait for 200ns; BP0s<='0'; BP1s<='0'; BP2s<='1'; BP3s<='0'; -- 4
                wait for 200ns; BP0s<='1'; BP1s<='0'; BP2s<='1'; BP3s<='0'; -- 5
                wait for 200ns; BP0s<='0'; BP1s<='1'; BP2s<='1'; BP3s<='0'; -- 6
                wait for 200ns; BP0s<='1'; BP1s<='1'; BP2s<='1'; BP3s<='0'; -- 7
                wait for 200ns; BP0s<='0'; BP1s<='0'; BP2s<='0'; BP3s<='1'; -- 8
                wait for 200ns; BP0s<='1'; BP1s<='0'; BP2s<='0'; BP3s<='1'; -- 9
                wait for 200ns; BP0s<='0'; BP1s<='1'; BP2s<='0'; BP3s<='1'; -- A(10)
                wait for 200ns; BP0s<='1'; BP1s<='1'; BP2s<='0'; BP3s<='1'; -- b(11)
                wait for 200ns; BP0s<='0'; BP1s<='0'; BP2s<='1'; BP3s<='1'; -- C(12)
                wait for 200ns; BP0s<='1'; BP1s<='0'; BP2s<='1'; BP3s<='1'; -- d(13)
                wait for 200ns; BP0s<='0'; BP1s<='1'; BP2s<='1'; BP3s<='1'; -- E(14)
                wait for 200ns; BP0s<='1'; BP1s<='1'; BP2s<='1'; BP3s<='1'; -- F(15)
            end loop boucle;
        end process SimuEntrees;

end testbench_arch;
