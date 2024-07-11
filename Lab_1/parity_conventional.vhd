----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:51:46 10/07/2010 
-- Design Name: 
-- Module Name:    ko - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Parity_conventional is
port (D   : in std_logic_vector(6 downto 0);
      F   : out std_logic);
end Parity_conventional;

architecture Behavioral of Parity_conventional is

begin
	F <= (not(D(0)) and D(1) and not(D(2)) and D(3) and D(5)) xor
	     (D(2) and not(D(3)) and D(5)) xor
		  (D(0) and not(D(1)) and not(D(2)) and not(D(3)) and not(D(4)) and not(D(6))) xor
		  (D(0) and D(1) and D(2) and not(D(3)) and D(5)) xor 
		  (D(0) and not(D(1)) and not(D(3))) xor 
		  (not(D(0)) and D(1) and D(3) and D(5) and not(D(6))) xor 
		  (not(D(0)) and D(2) and D(3) and D(5) and not(D(6))) xor 
		  (not(D(0)) and D(1) and D(2) and not(D(3)) and not(D(4)) and not(D(5)) and D(6)) xor 
		  (not(D(0)) and D(2)) xor 
		  (not(D(0)) and D(1) and not(D(2)) and not(D(6))) xor 
		  (not(D(1)) and not(D(2)) and not(D(3)) and not(D(4)));

end Behavioral;

