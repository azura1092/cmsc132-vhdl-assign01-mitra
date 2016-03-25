--JUN MITRA
--2009-14953 
--T-1L
--farm storage alarm circuit bench test 

-- Library Statements
library IEEE; use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--Entity Definition
entity alarm_tb is -- constants are defined here
	constant MAX_COMB: integer := 16; -- number of input combination (4 bits)
	constant DELAY: time := 10 ns; -- delay value in testing
end entity alarm_tb;

architecture tb of alarm_tb is 
	signal alarmState: std_logic; 
	signal in_buzzer: std_logic_vector(2 downto 0);
	signal out_buzzer: std_logic_vector(2 downto 0);

	component alarm is 
		port(alarmState: out std_logic; -- tells if buzzer is on or off
			in_buzzer: in std_logic_vector(2 downto 0);		-- in door alarms for boggis = in_buzzer(2), bunce = in_buzzer(1) and bean = in_door(0)
			out_buzzer: in std_logic_vector(2 downto 0));	 	-- out door alarms for boggis = out_buzzer(2), bunce = out_buzzer(1) and bean = out_door(0)					
	end component alarm;

begin -- begin main body of the tb architecture
	-- instantiate the unit under test
	UUT: component alarm port map(alarmState, in_buzzer, out_buzzer);

	--main process : generate test vectors and check results 
	main: process is
		variable temp: unsigned(5 downto 0); --used in calculations
		variable expected_alarmState: std_logic;
		variable error_count: integer := 0; -- number of simulation errors

	begin
		report "Start simulation.";

		--generate all possible input values, since max = 63
		for count in 0 to 63 loop
			temp := TO_UNSIGNED(count,6);
			in_buzzer(2) <= std_logic(temp(5));
			out_buzzer(2) <= std_logic(temp(4));
			in_buzzer(1) <= std_logic(temp(3));
			out_buzzer(1) <= std_logic(temp(2));
			in_buzzer(0) <= std_logic(temp(1));
			out_buzzer(0) <= std_logic(temp(0));

			--compute expected value
			if( temp(0) = '1' or temp(2) = '1' or temp(4) = '1' ) then
				if( temp(1) = '1' or temp(3) = '1' or temp(5) = '1' ) then
					expected_alarmState := '1';
				else
					expected_alarmState := '0';
				end if;
			else
				expected_alarmState := '0';
			end if;

			wait for DELAY; -- wait, and then compare with UUT outputs

			-- check if output of circuit is the same as the expected value
			assert (expected_alarmState = alarmState)
				report "IN: " &
					std_logic'image(temp(5)) &
					std_logic'image(temp(3)) &
					std_logic'image(temp(1)) &
					"OUT: " &
					std_logic'image(temp(4)) &
					std_logic'image(temp(2)) &
					std_logic'image(temp(0)) &
					"ERROR Expected alarmState: " &
					std_logic'image(expected_alarmState) & " alarmState from component: " &
					std_logic'image(alarmState);

			if(expected_alarmState/=alarmState)
				then error_count := error_count + 1;
			end if;
		end loop;

		wait for DELAY;

		--report errors
		assert (error_count=0)
			report "ERROR: There were " & integer'image(error_count) & " errors!";

		-- there are no errors
		if(error_count = 0) then
			report "Simulation completed with NO errors!";
		end if;

		wait; -- terminate the simulation
	end process;
end architecture tb;


