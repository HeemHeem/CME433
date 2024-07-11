module program_sequencer(
	
	input wire clk, sync_reset,
	input reg [3:0] jmp_addr,
	input reg jmp, jmp_nz, dont_jmp,
	output reg [7:0] pc, //pm_addr
	// suspend output
	output reg hold_out, start_hold, end_hold, hold,
	output reg [2:0] hold_count,

	// cache outputs
	output reg cache_wren,
	output reg [0:0] cache_wrline, cache_rdline,
	output reg [2:0] cache_wroffset, cache_rdoffset,
	output reg [7:0] rom_address,
	
	// set outputs
	output reg cache_rdentry,cache_wrentry,
	
	//tagID and valid
	output reg [3:0] tagID [0:1][0:1],
	output reg valid [0:1][0:1]
);

//reg [7:0] pc; // program counter
reg [7:0] pm_addr;
/************************************ suspend ****************************/
// flags and counter
//reg start_hold, hold, end_hold;
//reg [4:0] hold_count;

// cache variables
reg sync_reset_1, reset_1shot;


//start_hold logic
always @ *
	if((tagID[pm_addr[3]][currdentry] != pm_addr[7:4]) || ((valid[pm_addr[3]][currdentry] == 1'b0) && (hold == 1'b0))) 
		start_hold <= 1'b1;
	else if(reset_1shot) // cache
		start_hold <= 1'b1;
	else
		start_hold <= 1'b0;

// hold_count logic
always @ (posedge clk)
	if(reset_1shot)
		hold_count <= 0;
	else if(start_hold)
		hold_count <= 0;
	else if(hold)
		hold_count <= hold_count + 1;
	else
		hold_count <= hold_count;

// end_hold logic
always @ *
	if(hold && hold_count == 5'd7)
		end_hold <= 1'b1;
	else
		end_hold <= 1'b0;

// hold logic
always @ (posedge clk)
	//if(sync_reset)
	//	hold <= 1'b0;
	if (end_hold)
		hold <= 1'b0;
	else if (start_hold)
		hold <= 1'b1;
	else
		hold <= hold;
		
// hold_out logic
always @ *
	if((start_hold || hold) && ~end_hold)
		hold_out <= 1'b1;
	else
		hold_out <= 1'b0;
		
/*****************************************end Suspend******************************/


//************************************set associative **************************/

// cache_rdentry logic
always @ *
	cache_rdentry <= currdentry;

// cache_wrentry logic
always  @ *
	cache_wrentry <= ~lastused[pm_addr[3]];



// search for current entry
(* keep *) reg currdentry;

always @ *
	if(pm_addr[3] == 1'b0)
		if(tagID[0][0] == pm_addr[7:4])
			currdentry <= 1'b0;
		else
			currdentry <= 1'b1;
	else
		if(tagID[1][0] == pm_addr[7:4])
			currdentry <= 1'b0;
		else
			currdentry <= 1'b1;

// last used
(* noprune *) reg lastused[0:1];
always @ (posedge clk)
	if(reset_1shot)
		lastused[0] <= 1'b1;
	else if (pm_addr[3] == 1'b0 && hold == 1'b0 && start_hold == 1'b0)
		lastused[0] <= currdentry;
	else if (pm_addr[3] == 1'b0 && end_hold == 1'b1)
		lastused[0] <= ~lastused[0];
	else
		lastused[0] <= lastused[0];

always @ (posedge clk)
	if(reset_1shot)
		lastused[1] <= 1'b1;
	else if (pm_addr[3] == 1'b1 && hold == 1'b0 && start_hold == 1'b0)
		lastused[1] <= currdentry;
	else if (pm_addr[3] == 1'b1 && end_hold == 1'b1)
		lastused[1] <= ~lastused[1];
	else
		lastused[1] <= lastused[1];

/***************************************Cache***************************/

// connect cache_wroffset to hold count
always @ *
	cache_wroffset <= hold_count;

// connect cache_rdoffset to pm_addr[4:0]
always @ *
	cache_rdoffset <= pm_addr[2:0];
	
// connect cache_wrline to pc[4:3]
always @ *
	cache_wrline <= pc[3:3];

// connect cache_rdline to pm_addr[4:3]
always @ *
	cache_rdline <= pm_addr[3:3];
	

// connect cache_wren to hold
always @ *
	cache_wren <= hold;

//delayed version of sync_reset
always @ (posedge clk)
	sync_reset_1 <= sync_reset;

// logic for reset_1shot
always @ *
	if(sync_reset && ~sync_reset_1)
		reset_1shot <= 1'b1;
	else
		reset_1shot <= 1'b0;

// rom_address logic
always @ *
	if(reset_1shot)
		rom_address <= 8'h0;
	else if (start_hold)
		rom_address <= {pm_addr[7:3], 3'd0};
	else if (sync_reset)
		rom_address <= {5'd0, hold_count + 3'd1};
	else
		rom_address <= {tagID[pc[3]][~lastused[pc[3]]], pc[3], hold_count + 3'd1};

// tagID logic
always @ (posedge clk)
	if(reset_1shot) begin
		tagID[0][0] <= 4'd0;
		tagID[0][1] <= 4'd0;
		tagID[1][0] <= 4'd0;
		tagID[1][1] <= 4'd0;
	end
	
	else if(start_hold)
		tagID[pm_addr[3]][~lastused[pm_addr[3]]] <= pm_addr[7:4];
	else begin
		tagID[0][0] <= tagID[0][0];
		tagID[0][1] <= tagID[0][1];
		tagID[1][0] <= tagID[1][0];
		tagID[1][1] <= tagID[1][1];	
	end

// valid logic
always @ (posedge clk)
	if(reset_1shot) begin
		valid[0][0] <= 1'b0;
		valid[0][1] <= 1'b0;
		valid[1][0] <= 1'b0;
		valid[1][1] <= 1'b0;
	end
	
	else if(end_hold)
		valid[pm_addr[3]][~lastused[pm_addr[3]]] <= 1'b1;
	else begin
		valid[0][0] <= valid[0][0];
		valid[0][1] <= valid[0][1];
		valid[1][0] <= valid[1][0];
		valid[1][1] <= valid[1][1];	
	end

	


/***************************************end Cache************************/
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
		
		else if((jmp_nz == 1'b1) && (dont_jmp == 1'b1))
			pm_addr <= pc + 8'h01;
		else
			pm_addr <= pc + 8'h01;
			
endmodule

			

		
			
		
		
	

		