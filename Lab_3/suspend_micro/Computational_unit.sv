module Computational_unit(
	
	input wire clk, sync_reset,
	input reg i_sel, y_sel, x_sel,
	input reg [3:0] source_sel, dm, i_pins, nibble_ir,
	input reg [8:0] reg_en,
	output reg [3:0] i, data_bus, o_reg, r,
	output reg r_eq_0
	//output reg [3:0] x0, x1, y0, y1, r, m,
	// output reg [7:0] from_CU
	
);

// always @ *
// 	 from_CU = 8'h00; //for exam
	//from_CU = {x1, x0};

reg [3:0] x0, x1, y0, y1, m;

// internal inputs/outputs
reg [3:0] pm_data, i_sel_mux, x, y;

// ir_nibble equals pm_data
always @ *
	pm_data <= nibble_ir;


													// source_sel for data_bus
always @ *
case(source_sel)
	4'd0: data_bus <= x0;
	4'd1: data_bus <= x1;
	4'd2: data_bus <= y0;
	4'd3: data_bus <= y1;
	4'd4: data_bus <= r;
	4'd5: data_bus <= m;
	4'd6: data_bus <= i;
	4'd7: data_bus <= dm;
	4'd8: data_bus <= pm_data;
	4'd9: data_bus <= i_pins;
	default: data_bus <= 4'h0;
endcase

													// m reg
always @ (posedge clk)
	if (reg_en[5] == 1'b1)
		m <= data_bus;
	else
		m <= m;

		
													// i mux
always @ *
	if (i_sel == 1'b1)
		i_sel_mux <= i + m;
		
	else
		i_sel_mux <= data_bus;

													// i reg
always @ (posedge clk)
	if (reg_en[6] == 1'b1)
		i <= i_sel_mux;
	
	else
		i <= i;
		
													// o_reg
always @ (posedge clk)
	if (reg_en[8] == 1'b1)
		o_reg <= data_bus;
	
	else
		o_reg <= o_reg;
			
													// x0 reg
always @ (posedge clk)
	if(reg_en[0] == 1'b1)
		x0 <= data_bus;
	else
		x0 <= x0;
		

													// x1 reg
always @ (posedge clk)
	if(reg_en[1] == 1'b1)
		x1 <= data_bus;
	else
		x1 <= x1;
		
													// y0 reg
always @ (posedge clk)
	if(reg_en[2] == 1'b1)
		y0 <= data_bus;
	else
		y0 <= y0;
		
													// y1 reg
always @ (posedge clk)
	if(reg_en[3] == 1'b1)
		y1 <= data_bus;
	else
		y1 <= y1;

		
													// x
always @ *
	if (x_sel == 1'b1)
		x <= x1;
	
	else
		x <= x0;
		
	
													// y
always @ *
	if (y_sel == 1'b1)
		y <= y1;
	
	else
		y <= y0;
		

													// ALU

reg[3:0] alu_out;
reg alu_out_eq_0;

reg [7:0] mult;
always @ *
	mult <= x*y;
	

// alu_out
always @ *
if (sync_reset == 1'b1)
	alu_out <= 4'h0;

else
	case(nibble_ir[2:0])

		3'b000: if(nibble_ir[3] == 1'b0)
						alu_out <= -x;
					else
						alu_out <= r;
		
		3'b001: alu_out <= x-y;
		
		3'b010: alu_out <= x + y;
		
		3'b011: alu_out <= mult[7:4];
		
		3'b100: alu_out <= mult[3:0];
		
		3'b101: alu_out <= x ^ y;
		
		3'b110: alu_out <= x & y;
		
		3'b111: if(nibble_ir[3] == 1'b0)
						alu_out <= ~x;
					else
						alu_out <= r;
	endcase


// alu_out_eq_0
always @ *
	if (sync_reset == 1'b1)
		alu_out_eq_0 <= 1'b1;
	
	else if (alu_out == 4'h0)
		alu_out_eq_0 <= 1'b1;
		
	else
		alu_out_eq_0 <= 1'b0;
		
													// zero_flag reg/r_eq_0
always @ (posedge clk)
	if (reg_en[4] == 1'b1)
		r_eq_0 <= alu_out_eq_0;
	
	else
		r_eq_0 <= r_eq_0;
		
													// r reg
always @ (posedge clk)
	if(reg_en[4] == 1'b1)
		r <= alu_out;
	
	else
		r <= r;

	
					
		

		


endmodule
