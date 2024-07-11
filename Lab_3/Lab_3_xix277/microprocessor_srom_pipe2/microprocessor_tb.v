`timescale 1us / 1ns

module microprocessor_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [3:0] i_pins;

	// Outputs
	wire [3:0] o_reg, r;
	wire [7:0] pc, ir;
	wire [7:0] data_pipe, sig_btwn_instr, address_pipe;
	wire flush_pipeline, prev_flush;

	// Instantiate the Unit Under Test (UUT)
	microprocessor uut (
		.clk(clk), 
		.reset(reset), 
        .i_pins(i_pins),
        .o_reg(o_reg),
	.r(r),
	.pc(pc),
	.ir(ir),
	.data_pipe(data_pipe),
	.address_pipe(address_pipe),
	.sig_btwn_instr(sig_btwn_instr),
	.flush_pipeline(flush_pipeline),
	.prev_flush(prev_flush)
	);

    // length of simulation
    initial #1000 $stop;

    initial
    begin
        clk = 1'b0;
    end

    always
        #0.5 clk = ~clk;

    initial
    begin
        reset = 1'b1;
        #3.2 reset = 1'b0;
        #63 reset = 1'b1;
        #3 reset = 1'b0;
        #91 reset = 1'b1;
        #3 reset = 1'b0;
        #103 reset = 1'b1;
        #101 reset = 1'b0;
    end

	initial begin
        // i_pins stimulus
        i_pins = 4'd5;
	end

endmodule

