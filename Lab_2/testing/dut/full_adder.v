module full_adder( 
	input wire A, B, Cin,
	output reg S, Cout);

always @ *
 S = (A ^ B) ^ Cin;

always @ *
Cout = (A & B) | (Cin & (A ^ B));
	
	
endmodule
