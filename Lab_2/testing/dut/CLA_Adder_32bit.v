module CLA_Adder_32bit(
	input wire cin, clk,
	input [31:0] a, b,
	output reg G, P, Cout,
	output reg [31:0] sum
);
reg [31:0] ain, bin;
reg c0;
wire cout, Gout, Pout;
wire [31:0] sumout;
wire [7:0] p, g;
wire [6:0] c;

// outputs
always @ (posedge clk)
	G <= Gout;
	
always @ (posedge clk)
	P <= Pout;

always @ (posedge clk)
	Cout <= cout;
	
always @ (posedge clk)
	sum <= sumout;

// inputs
always @ (posedge clk)
	c0 <= cin;

always @ (posedge clk)
	ain <= a;

always @ (posedge clk)
	bin <= b;

CLA_unit_32 CLA_unit (.cin(c0), .p(p), .g(g), .cout(cout), .P(Pout), .G(Gout), .c(c));

CLA_Adder_4bit CLA_4bit_Adder [7:0] ( .cin({c,c0}), .P(p), .G(g), .sum(sumout), .a(ain), .b(bin));


endmodule
	



