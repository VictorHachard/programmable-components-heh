library ieee;
use ieee.std_logic_1164.all;

entity FullAdd_tb is
end FullAdd_tb;

architecture testbench_arch of FullAdd_tb is

    component FullAdd
        port (
        	A, B, Cin  : in  std_logic;
            SUM, CARRY : out std_logic
        );
    end component;

    signal A_in      : std_logic := '0';
    signal B_in      : std_logic := '0';
    signal Cin_in    : std_logic := '0';
    signal SUM_out   : std_logic := '0';
    signal CARRY_out : std_logic := '0';

begin

    uut : FullAdd
    port map (
    	A => A_in,
        B => B_in,
        Cin => Cin_in,
        SUM => SUM_out,
        CARRY => CARRY_out
    );

    SimuEntrees : process  -- Process qui modifie les deux entrées pour la simulation
    begin
        boucle : loop
            wait for 200ns;
            A_in <= '0'; B_in <= '0'; Cin_in <= '1';
            wait for 200ns;
            A_in <= '0'; B_in <= '1'; Cin_in <= '0';
            wait for 200ns;
            A_in <= '0'; B_in <= '1'; Cin_in <= '1';
            wait for 200ns;
            A_in <= '1'; B_in <= '0'; Cin_in <= '0';
            wait for 200ns;
            A_in <= '1'; B_in <= '0'; Cin_in <= '1';
            wait for 200ns;
            A_in <= '1'; B_in <= '1'; Cin_in <= '0';
            wait for 200ns;
            A_in <= '1'; B_in <= '1'; Cin_in <= '1';
        end loop boucle;
    end process SimuEntrees;

end testbench_arch;