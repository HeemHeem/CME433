module microprocessor(
	input wire clk, reset,
	input wire [3:0] i_pins,
	output wire [3:0] o_reg,
	output wire [7:0] pm_data,
	output wire [7:0] pc, from_PS, pm_addr, ir, from_ID, NOPC8, NOPCF, NOPD8, NOPDF, from_CU,
	output wire [8:0] reg_enables,
	output wire [3:0] x0, x1, y0, y1, r, m,
	output wire zero_flag

);

// wires
 
// program_memory
//wire [7:0] pm_data; 

// instruction_decoder
wire jump;
wire condtional_jump;
wire [3:0] LS_nibble_ir;
wire i_mux_select;
wire y_reg_select;
wire x_reg_select;
wire [3:0] source_select;
//wire [8:0] reg_enables;

// program_sequencer
//wire [7:0] pm_addr;

// Computational_unit
//wire zero_flag;
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
	.addr(pm_address),
	.data(pm_data)
	

);

//Instruction Decoder

Instruction_decoder instr_decoder(
	
	.clk(clk),
	.next_instr(pm_data),
	.sync_reset(sync_reset),
	.jmp(jump),
	.jmp_nz(conditional_jump),
	.ir_nibble(LS_nibble_ir),
	.i_sel(i_mux_select),
	.y_sel(y_reg_select),
	.x_sel(x_reg_select),
	.source_sel(source_select),
	.reg_en(reg_enables),
	.ir(ir),
	.from_ID(from_ID)
	
);


// Program Sequencer
program_sequencer prog_sequencer(

	.clk(clk),
	.sync_reset(sync_reset),
	.pm_addr(pm_address),
	.jmp(jump),
	.jmp_nz(conditional_jump),
	.jmp_addr(LS_nibble_ir),
	.dont_jmp(zero_flag),
	.pc(pc),
	.from_PS(from_PS)
	
);


// Computational Unit

Computational_unit comp_unit(

	.clk(clk),
	.sync_reset(sync_reset),
	.nibble_ir(LS_nibble_ir),
	.i_sel(i_mux_select),
	.y_sel(y_reg_select),
	.x_sel(x_reg_select),
	.source_sel(soure_select),
	.reg_en(reg_enables),
	.i_pins(i_pins),
	.r_eq_0(zero_flag),
	.i(data_mem_addr),
	.data_bus(data_bus),
	.dm(dm),
	.o_reg(o_reg),
	.x0(x0),
	.x1(x1),
	.y0(y0),
	.y1(y1),
	.r(r),
	.m(m),
	.from_CU(from_CU)

	
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




