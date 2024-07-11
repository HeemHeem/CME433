module program_sequencer(
	
	input wire clk, sync_reset,
	input reg [3:0] jmp_addr,
	input reg jmp, jmp_nz, dont_jmp,
	output reg [7:0] pm_addr, pc

);

//reg [7:0] pc; // program counter


always @ (posedge clk)
	pc <= pm_addr;


always @ *
	
	if(sync_reset == 1'b1)
		pm_addr <= 8'h0;
	
	else
		
		if(jmp == 1'b1)
			pm_addr <= {jmp_addr, 4'h0};
		
		else if((jmp_nz == 1'b1) && (dont_jmp ==1'b0))
			pm_addr <= {jmp_addr, 4'h0};
		
		else if ((jmp_nz == 1'b1) && (dont_jmp == 1'b1))
			pm_addr <= pc + 8'h01;
		
		else
			pm_addr <= pc + 8'h01;
			
endmodule

			

		
			
		
		
	

		