module lod(
	input  bit [7:0] data,
	output bit		  zero_flag,
	output bit [2:0] pos,
	output bit [6:0] fraction
);	
	assign zero_flag = data == 8'b0;
	
	// pos
	always @ *
		if		  (data[7]) pos = 3'd7;
		else if (data[6]) pos = 3'd6;
		else if (data[5]) pos = 3'd5;
		else if (data[4]) pos = 3'd4;
		else if (data[3]) pos = 3'd3;
		else if (data[2]) pos = 3'd2;
		else if (data[1]) pos = 3'd1;
		else					pos = 3'd0;
		
	// fraction
	assign fraction = data[6:0] << (8 - pos - 1);
endmodule
