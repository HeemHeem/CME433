module antilog_converter(
	input  bit [10:0] log_result,
	input  bit        fraction_sum_carry,
	output bit [15:0] result
	);
	
	bit [22:0] temp_result;
	bit [3:0] k;
	bit [6:0] x;
	
	assign k = log_result[10:7];
	assign x = log_result[6:0];
	
	always @ *
		if (!fraction_sum_carry)
			temp_result = {1'b1, x} << k;
		else
			temp_result = {1'b1, x} << k;
			
	assign result = temp_result[22:7];
		
endmodule
