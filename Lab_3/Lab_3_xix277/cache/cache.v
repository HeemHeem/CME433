module cache( input clk, wren,
				  input wire [7:0] data,
				  input wire [4:0] rdoffset, wroffset,
				  output reg [7:0] q
);

reg [31:0] byteena_a;
wire [255:0] q_tmp;
always @ *
	byteena_a <= 32'b1 << wroffset;

always @ *
	q <= q_tmp[8*rdoffset +: 8];
	
	
ram_2port ram2port(
	.byteena_a(byteena_a),
	.clock(~clk),
	.data({32{data}}),
	.rdaddress(1'b0),
	.wraddress(1'b0),
	.q(q_tmp),
	.wren(wren)
);



endmodule
