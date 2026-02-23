library ieee;
use ieee.std_logic_1164.all;

entity DemiAdd_tb is
end DemiAdd_tb;

architecture testbench_arch of DemiAdd_tb is

    component DemiAdd
        port (  ENTREE1, ENTREE2 : in std_logic;
                SORTIE, CARRY : out std_logic);
    end component;

    signal ENTREE1_in : std_logic := '0';
    signal ENTREE2_in : std_logic := '0';
    signal SORTIE_out : std_logic := '0';
    signal CARRY_out : std_logic := '0';

begin

    uut : DemiAdd
    port map (ENTREE1 => ENTREE1_in, ENTREE2 => ENTREE2_in, SORTIE => SORTIE_out, CARRY => CARRY_out);

    SimuEntrees : process  -- Process qui modifie les deux entrées pour la simulation
    begin
        boucle : loop
            wait for 200ns;
            ENTREE1_in <= '1';
            wait for 200ns;
            ENTREE2_in <= '1';
            wait for 200ns;
            ENTREE1_in <= '0';
            wait for 200ns;
            ENTREE2_in <= 'X';
        end loop boucle;
    end process SimuEntrees;

end testbench_arch;