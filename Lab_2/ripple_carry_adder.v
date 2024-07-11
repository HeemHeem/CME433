module ripple_carry_adder(
	input wire clk, Cin,
	input wire [31:0] A, B, 
	output reg [31:0] S, 
	output reg Cout);

reg C0; 
wire C32;
reg [31:0] Ain, Bin;
wire [31:0] Sout; 	
wire [30:0] C;

always @ (posedge clk)
	 S <= Sout;

always @ (posedge clk)
	Cout <= C32;
	
always @ (posedge clk)
	C0 <= Cin;
	
always @ (posedge clk)
	Ain <= A;
	
always @ (posedge clk)
	Bin <= B;


full_adder rpp_crry [31:0] (.A(Ain), .B(Bin), .Cin({C, C0}), .Cout({C32,C}), .S(Sout));

endmodule