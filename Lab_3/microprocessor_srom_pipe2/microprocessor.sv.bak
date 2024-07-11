module microprocessor(
	input wire clk, reset,
	input wire [3:0] i_pins,
	output wire [3:0] o_reg, r,
	output wire [7:0] pc, ir,
	
	// pipeline
	output reg [7:0] data_pipe, sig_btwn_instr,
	output reg flush_pipeline
);

// wires

// pipeline registers and signals
//reg [7:0] data_pipe, sig_btwn_instr;
//reg flush_pipeline;

// program_memory
wire [7:0] pm_data;

// outputs of comb_logic
wire [7:0] pm_data_out, pm_address_out; 

// instruction_decoder
wire jump;
wire conditional_jump;
wire [3:0] LS_nibble_ir;
wire i_mux_select;
wire y_reg_select;
wire x_reg_select;
wire [3:0] source_select;
wire [8:0] reg_enables;

// program_sequencer
wire [7:0] pm_addr;

// Computational_unit
wire zero_flag;
wire [3:0] data_mem_addr;
wire [3:0] data_bus;

// data_memory
wire [3:0] dm;

// D flip flop
reg sync_reset;


/**********************************
		INSTANTIATIONS OF MODULES
***********************************/

// D Flip Flop
always @ (posedge clk)
	sync_reset = reset;


// Program Memory

program_memory prog_mem(
	
	.clk(~clk),
	.addr(pm_address_out),
	.data(pm_data)
	

);
// data_pipe register pipeline
always @ (posedge clk)
	data_pipe <= pm_data;

// Comb Logic Circuits

// comb logic between pm to ID
comb_logic pm_to_ID(
	.pm_in(data_pipe),
	.pm_out(pm_data_out)
);

// comb logic between pm to PS
comb_logic pm_to_PS(
	.pm_in(pm_addr),
	.pm_out(pm_address_out)
);

// comb logic for flush_pipeline placed between comb logic and instruction decode
always @ *
	if(ir[7:4] == 4'HE)
		flush_pipeline <= 1'b1;
	else if ((ir[7:4] == 4'HF) && (zero_flag == 1'b0))
		flush_pipeline <= 1'b1;
	else
		flush_pipeline <= 1'b0;



always @ *
	if(flush_pipeline)
		sig_btwn_instr <= 8'hC8;
	else
		sig_btwn_instr <= pm_data_out;



//Instruction Decoder

Instruction_decoder instr_decoder(
	
	.clk(clk),
	//.next_instr(pm_data_out),
	.next_instr(sig_btwn_instr),
	.sync_reset(sync_reset),
	.jmp(jump),
	.jmp_nz(conditional_jump),
	.ir_nibble(LS_nibble_ir),
	.i_sel(i_mux_select),
	.y_sel(y_reg_select),
	.x_sel(x_reg_select),
	.source_sel(source_select),
	.reg_en(reg_enables),
	.ir(ir)
	
);


// Program Sequencer
program_sequencer prog_sequencer(

	.clk(clk),
	.sync_reset(sync_reset),
	.pm_addr(pm_addr),
	.jmp(jump),
	.jmp_nz(conditional_jump),
	.jmp_addr(LS_nibble_ir),
	.dont_jmp(zero_flag),
	.pc(pc)
	
);


// Computational Unit

Computational_unit comp_unit(

	.clk(clk),
	.sync_reset(sync_reset),
	.nibble_ir(LS_nibble_ir),
	.i_sel(i_mux_select),
	.y_sel(y_reg_select),
	.x_sel(x_reg_select),
	.source_sel(source_select),
	.reg_en(reg_enables),
	.i_pins(i_pins),
	.r_eq_0(zero_flag),
	.i(data_mem_addr),
	.data_bus(data_bus),
	.dm(dm),
	.o_reg(o_reg),
	.r(r)
	
);


// Data Memory (RAM)

data_memory data_mem(

	.inclock(~clk),
	.address(data_mem_addr),
	.data(data_bus),
	.q(dm),
	.wren(reg_enables[7])

);


endmodule




