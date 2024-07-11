module log_converter (
	input  bit [2:0] k,
	input  bit [7:0] x,
	output bit [10:0] log_value
	);
	
	assign log_value = {k, x};

endmodule
