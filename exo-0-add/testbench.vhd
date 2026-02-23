library ieee;
use ieee.std_logic_1164.all;

entity Test1_tb is
end Test1_tb;

architecture testbench_arch of Test1_tb is

    component Test1
        port (  ENTREE1, ENTREE2 : in std_logic;
                SORTIE : out std_logic);
    end component;

    signal ENTREE1_in : std_logic := '0';
    signal ENTREE2_in : std_logic := '0';
    signal SORTIE_out : std_logic := '0';

begin

    uut : Test1
    port map (ENTREE1 => ENTREE1_in, ENTREE2 => ENTREE2_in, SORTIE => SORTIE_out);

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