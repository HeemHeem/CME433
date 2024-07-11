module CLA_4bit( 
	input wire [3:0] p, g,
	input wire cin,
	output wire [2:0] c,
	output wire cout,
	output wire G, P
);

// P logic
assign P = p[0] & p[1] & p[2] & p[3];

// G logic
assign G = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]);

// cout logic
// c1
assign c[0] = g[0] | (p[0] & cin);
// c2
assign c[1] = g[1] | (p[1] & c[0]);
// c3
assign c[2] = g[2] | (p[2] & c[1]);
// cout
assign cout = g[3] | (p[3] & c[2]);

 


endmodule
