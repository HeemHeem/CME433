module program_sequencer(
	
	input wire clk, sync_reset,
	input reg [3:0] jmp_addr,
	input reg jmp, jmp_nz, dont_jmp,
	output reg [7:0] pm_addr, pc,
	// suspend output
	output reg hold_out, start_hold, end_hold, hold,
	output reg [4:0] hold_count
);

//reg [7:0] pc; // program counter

/************************************ suspend ****************************/
// flags and counter
//reg start_hold, hold, end_hold;
//reg [4:0] hold_count;

//start_hold logic
always @ *
	if(pc[7:5] != pm_addr[7:5])
		start_hold <= 1'b1;
	else
		start_hold <= 1'b0;

// hold_count logic
always @ (posedge clk)
	if (sync_reset)
		hold_count <= 0;
	else if (start_hold)
		hold_count <= 0;
	else if (hold)
		hold_count <= hold_count + 1;
	else
		hold_count <= hold_count;

// end_hold logic
always @ *
	if(hold && hold_count == 5'd31)
		end_hold <= 1'b1;
	else
		end_hold <= 1'b0;

// hold logic
always @ (posedge clk)
	if(sync_reset)
		hold <= 1'b0;
	else if (end_hold)
		hold <= 1'b0;
	else if (start_hold)
		hold <= 1'b1;
	else
		hold <= hold;
		
// hold_out logic
always @ *
	if ((start_hold || hold) && ~end_hold)
		hold_out <= 1'b1;
	else
		hold_out <= 1'b0;
		
/**************************************************************************/
always @ (posedge clk)
	pc <= pm_addr;

always @ *
	
	if(sync_reset == 1'b1)
		pm_addr <= 8'h0;
	else
		// hold micro
		if(hold)
			pm_addr <= pm_addr;
			
		else if(jmp == 1'b1)
			pm_addr <= {jmp_addr, 4'h0};
		
		else if((jmp_nz == 1'b1) && (dont_jmp ==1'b0))
			pm_addr <= {jmp_addr, 4'h0};
		
		else if ((jmp_nz == 1'b1) && (dont_jmp == 1'b1))
			pm_addr <= pc + 8'h01;
		else
			pm_addr <= pc + 8'h01;
			
endmodule

			

		
			
		
		
	

		