module CLA_unit_32( 
	input wire [7:0] p, g,
	input wire cin,
	output wire [6:0] c,
	output wire cout,
	output wire G, P
);

// P logic
assign P = p[0] & p[1] & p[2] & p[3] & p[4] & p[5] & p[6] & p[7];

// G logic
assign G =  g[7] |
				(g[6] & p[7]) |
				(g[5] & p[7] & p[6]) |
				(g[4] & p[7] & p[6] & p[5]) | 
				(g[3] & p[7] & p[6] & p[5] & p[4]) | 
				(g[2] & p[7] & p[6] & p[5] & p[4] & p[3]) |
				(g[1] & p[7] & p[6] & p[5] & p[4] & p[3] & p[2]) |
				(g[0] & p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1]);

// cout logic
// c1
assign c[0] = g[0] | (p[0] & cin);
// c2
assign c[1] = g[1] | (p[1] & c[0]);
// c3
assign c[2] = g[2] | (p[2] & c[1]);
// c4
assign c[3] = g[3] | (p[3] & c[2]);
// c5
assign c[4] = g[4] | (p[4] & c[3]);
// c6
assign c[5] = g[5] | (p[5] & c[4]);
// c7
assign c[6] = g[6] | (p[6] & c[5]);

// cout
assign cout = g[7] | (p[7] & c[6]);

 


endmodule