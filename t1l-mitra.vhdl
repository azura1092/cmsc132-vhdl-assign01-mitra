--JUN MITRA
--2009-14953 
--T-1L
--farm storage alarm circuit

--Library Statements
library IEEE; use IEEE.std_logic_1164.all;

--entity definition
entity alarm is
	port (alarmState: out std_logic;						-- alarm output
		in_buzzer: in std_logic_vector(2 downto 0);		-- in door alarms for boggis = in_buzzer(2), bunce = in_buzzer(1) and bean = in_door(0)
		out_buzzer: in std_logic_vector(2 downto 0));	 	-- out door alarms for boggis = out_buzzer(2), bunce = out_buzzer(1) and bean = out_door(0)					

	end entity alarm;

	--Architecture Definition
	architecture trigger of alarm is 
		signal a,b,c,d,e,f,g,h,i :std_logic;
		begin

			a <= in_buzzer(0) and out_buzzer(0);
			b <= out_buzzer(2) and in_buzzer(0) and (not out_buzzer(0));
			c <= out_buzzer(1) and in_buzzer(0);
			d <= out_buzzer(2) and in_buzzer(1) and (not in_buzzer(0));
			e <= in_buzzer(1) and out_buzzer(1);
			f <= in_buzzer(2) and (not in_buzzer(0)) and out_buzzer(0); 
			g <= in_buzzer(2) and (not in_buzzer(1)) and out_buzzer(1);
			h <= in_buzzer(2) and out_buzzer(2);
			i <= in_buzzer(1) and out_buzzer(0);
			alarmState <= a or b or c or d or e or f or g or h or i;
	end architecture trigger;