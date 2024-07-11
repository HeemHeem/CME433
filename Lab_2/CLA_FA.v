module CLA_FA(
	input wire a, b, cin,
	output wire s, p, g
);

assign p = a | b;
assign g = a & b;
assign s = a ^ b ^ cin;




endmodule
