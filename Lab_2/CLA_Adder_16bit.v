module CLA_Adder_16bit(
	input cin,
	input [15:0] a, b,
	output [15:0] sum,
	output G, P, Cout

);
wire [3:0] p, g;
wire [2:0] c;

CLA_unit CLA_unit (.cin(cin), .p(p), .g(g), .cout(Cout), .P(P), .G(G), .c(c));

CLA_Adder_4bit CLA_4bit_Adder [3:0] ( .cin({c,cin}), .P(p), .G(g), .sum(sum), .a(a), .b(b));

endmodule
