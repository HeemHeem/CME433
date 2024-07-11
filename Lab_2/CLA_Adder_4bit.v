module CLA_Adder_4bit(
	input wire cin,
	input [3:0] a, b,
	output wire G, P, Cout,
	output wire [3:0] sum
);

wire [3:0] p, g;
wire [2:0] c;


CLA_unit CLA_unit (.cin(cin), .p(p), .g(g), .cout(Cout), .P(P), .G(G), .c(c));

CLA_FA CLA_Adder [3:0] ( .cin({c,cin}), .p(p), .g(g), .s(sum), .a(a), .b(b));



endmodule
	



