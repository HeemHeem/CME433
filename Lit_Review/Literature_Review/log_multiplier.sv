module log_multiplier(
	input  bit [7:0]	A, B,
	output bit		 	zero_flag_A, zero_flag_B,
	output bit [2:0]	leading_A, leading_B, 
	output bit [6:0]	fraction_A, fraction_B,
	output bit [9:0]	log_A, log_B,
	output bit			fraction_sum_carry,
	output bit [10:0]	log_result,
	output bit [15:0] result
	);
	
	// LOD
	lod lod_A(
		.data(A),
		.zero_flag(zero_flag_A),
		.pos(leading_A),
		.fraction(fraction_A)
	);
	
	lod lod_B(
		.data(B),
		.zero_flag(zero_flag_B),
		.pos(leading_B),
		.fraction(fraction_B)
	);
	
	// Logarithmic Converter
	log_converter log_converter_A(
		.k(leading_A),
		.x(fraction_A),
		.log_value(log_A)
	);
	
	log_converter log_converter_B(
		.k(leading_B),
		.x(fraction_B),
		.log_value(log_B)
	);
	
	// Adder
	adder adder(
		.op1(log_A),
		.op2(log_B),
		.fraction_sum_carry(fraction_sum_carry),
		.sum(log_result)
	);
	
	// Antilogarithmic Converter
	antilog_converter antilog_converter(
		.log_result(log_result),
		.fraction_sum_carry(fraction_sum_carry),
		.result(result)
	);
endmodule
