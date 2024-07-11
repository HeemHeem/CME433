module Instruction_decoder(
	input wire clk, sync_reset,
	input wire [7:0] next_instr,
	output reg jmp, jmp_nz, NOPC8,NOPCF, NOPD8, NOPDF,
	output reg [3:0] ir_nibble,
	output reg i_sel, y_sel, x_sel,
	output reg [3:0] source_sel,
	output reg [8:0] reg_en,
	output reg [7:0] ir, from_ID
);

always @ *
	from_ID = 8'h0; // for the exam
	//from_ID = reg_en[7:0]; // to test
//NOPS
always @ *
	if (ir == 8'hC8)
		NOPC8 = 1'b1;
	else
		NOPC8 = 1'b0;
always @ *
	if (ir == 8'hCF)
		NOPCF = 1'b1;
	else
		NOPCF = 1'b0;
always @ *
	if (ir == 8'hD8)
		NOPD8 = 1'b1;
	else
		NOPD8 = 1'b0;

always @ *
	if (ir == 8'hDF)
		NOPDF = 1'b1;
	else
		NOPDF = 1'b0;


									// instruction reg (ir)
//reg [7:0] ir;

always @ (posedge clk)
	ir <= next_instr;

always @ *
	ir_nibble <= ir[3:0];
	

									// constructing reg_enables

always @ * // build for x0 register
	if(sync_reset == 1'b1)
		reg_en[0] <= 1'b1;
		
	else if(ir[7:4] == 4'b0_000) // load data to x0
		reg_en[0] <= 1'b1;
		
	else if(ir[7:3] == 5'b10_000) // mov something to xo
		reg_en[0] <= 1'b1;
		
	else
		reg_en[0] <= 1'b0;
		


always @ * // build for x1
	if(sync_reset == 1'b1)
		reg_en[1] <= 1'b1;
		
	else if(ir[7:4] == 4'b0_001) // load data to x1
		reg_en[1] <= 1'b1;
		
	else if(ir[7:3] == 5'b10_001) // mov something to x1
		reg_en[1] <= 1'b1;
		
	else
		reg_en[1] <= 1'b0;
		


always @ * // build for y0
	if(sync_reset == 1'b1)
		reg_en[2] <= 1'b1;
		
	else if(ir[7:4] == 4'b0_010) // load data to y0
		reg_en[2] <= 1'b1;
		
	else if(ir[7:3] == 5'b10_010) // mov something to y0
		reg_en[2] <= 1'b1;
		
	else
		reg_en[2] <= 1'b0;
		

		
always @ * // build for y1
	if(sync_reset == 1'b1)
		reg_en[3] <= 1'b1;
		
	else if(ir[7:4] == 4'b0_011) // load data to y1
		reg_en[3] <= 1'b1;
		
	else if(ir[7:3] == 5'b10_011) // mov something to y1
		reg_en[3] <= 1'b1;
		
	else
		reg_en[3] <= 1'b0;


		
always @ * // build for r	note: r can only be used as a source so no load or mov enables
	if(sync_reset == 1'b1)
		reg_en[4] <= 1'b1;
		
		// r is written on every ALU instruction and not written on any other type of instructions
	else if(ir[7:5] == 3'b110)
		reg_en[4] <= 1'b1;
		
	else
		reg_en[4] <= 1'b0;


		
always @ * // build for m 
	if(sync_reset == 1'b1)
		reg_en[5] <= 1'b1;
		
	else if(ir[7:4] == 4'b0_101) // load to m
		reg_en[5] <= 1'b1;
		
	else if(ir[7:3] == 5'b10_101) // mov somethign to m
		reg_en[5] <= 1'b1;
	
	else 
		reg_en[5] <= 1'b0;


		
always @ * // build combinational logic for the enable register for i register
	if(sync_reset == 1'b1)
		reg_en[6] <= 1'b1;
		
	else if(ir[7:3] == 5'b10_110) // mov ??? to i
		reg_en[6] <= 1'b1;
		
	else if(ir[7:4] == 4'b0_110) // load i
		reg_en[6] <= 1'b1;
		
	else if(ir[7:3] == 5'b10_111) // mov ??? to dm
		reg_en[6] <= 1'b1;
		
	else if(ir[7:4] == 4'b0_111) // load to dm
		reg_en[6] <= 1'b1;
		
	else if( (ir[7:6] == 2'b10) && (ir[2:0] == 3'b111)) // move instruction with dm as source
		reg_en[6] <= 1'b1;
		
	else
		reg_en[6] <= 1'b0;
	

	
always @ * // build for dm
	if(sync_reset == 1'b1)
		reg_en[7] <= 1'b1;
	
	else if(ir[7:4] == 4'b0_111)
		reg_en[7] <= 1'b1;
		
	else if(ir[7:3] == 5'b10_111)
		reg_en[7] <= 1'b1;
	
	else
		reg_en[7] <= 1'b0;

	
always @ * // build for o_reg
	if(sync_reset == 1'b1)
		reg_en[8] <= 1'b1;
		
		// o_reg can only be in the dst field
	else if(ir[7:4] == 4'b0_100) //load to o_reg
		reg_en[8] <= 1'b1;
		
	else if(ir[7:3] == 5'b10_100) // mov to o_reg
		reg_en[8] <= 1'b1;
	
	else
		reg_en[8] <= 1'b0;
		

		
									// Constructing source_sel

always @ * 
	if(sync_reset == 1'b1)
		source_sel <= 4'd10;
		
		// load instruction
	else if(ir[7] == 1'b0)
		source_sel <= 4'd8;
	
		//move instruction
	else if(ir[7:6] == 2'b10)
	
		if( (ir[5:3] & ir[2:0]) == 3'd4) // move r to o_reg
			source_sel <= {1'b0, ir[2:0]};
		
		else if(ir[5:3] == ir[2:0]) // move i pins if ID's are the same and not 3'd4
			source_sel <= 4'd9;
		
		else
			source_sel <= {1'b0, ir[2:0]}; // regular move
			
		
	else
		source_sel <= ir[3:0];


									// constructing i_sel

always @ *
	if (sync_reset)
		i_sel <= 1'b0;
		
	else if(ir[7:4] == 4'b0_110) // load instruction
		i_sel <= 1'b0;
	
	else if(ir[7:3] == 5'b10_110)
		i_sel <= 1'b0;
		
	else
		i_sel <= 1'b1;

									// constructing x_sel

always @ *
	if(sync_reset == 1'b1)
		x_sel <= 1'b0;
	
	else
		x_sel <= ir[4]; // doesn't matter what it is until ALU instruction


		

									// constructing y_sel
always @ *
	if(sync_reset == 1'b1)
		y_sel <= 1'b0;
		
	else
		y_sel <= ir[3];
	


									// constructing jmp
always @ *
	if(sync_reset == 1'b1)
		jmp <= 1'b0;
	
	else if(ir[7:4] == 4'b1110)
		jmp <= 1'b1;
	
	else
		jmp <= 1'b0;
		

									// constructing jmp_nz
always @ *
	if(sync_reset == 1'b1)
		jmp_nz <= 1'b0;
	
	else if(ir[7:4] == 4'b1111)
		jmp_nz <= 1'b1;
		
	else
		jmp_nz <= 1'b0;


	
		
		
endmodule
