module adder(
	input  bit [9:0] op1, op2,
	output bit			fraction_sum_carry,
	output bit [10:0] sum
	);

	bit [7:0] fraction_sum;
	assign fraction_sum = op1[6:0] + op2[6:0];
	assign fraction_sum_carry = fraction_sum[7];
	
	assign sum = op1 + op2;

endmodule
