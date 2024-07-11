module comb_logic( pm_in,
						 pm_out
);
(* noprune *) input wire [7:0] pm_in;
(* noprune *) output wire [7:0] pm_out;
wire [60:0][7:0] inter;
//reg [9:0] counter;

assign inter[0] = pm_in;
assign inter[60] = inter[59] & inter[59];
assign pm_out = inter[60];


genvar idx;	
generate

	for(idx = 1; idx < 60; idx = idx + 1) begin: loop
		assign inter[idx] = inter[idx-1] & inter[idx-1];
	end
endgenerate

endmodule
