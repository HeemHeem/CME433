`include "parameters.sv"

module approx_log_multiplier(
    input  bit                 clk,
    input  bit signed [7:0]    A, B,
    output bit signed [15:0]   result
    );

    bit signed [7:0]  sync_A, sync_B;
    bit        [7:0]    abs_A, abs_B;
    bit                 zero_flag, result_sign;
    bit        [2:0]    k1, k2;
    bit        [7:0]    x1, x2;
    bit        [`T-1:0] x1_t, x2_t;
    bit        [`T+2:0] log_A, log_B;
    bit        [`T+3:0] log_result;
    bit        [15:0]   unsigned_result;
    bit signed [15:0] async_result;

    bit flag_A, flag_B;
    bit [2:0] t1, t2;

    always @ (posedge clk) begin
        sync_A <= A;
        sync_B <= B;
        result <= async_result;
    end

    // Sign Detector
    sign_detector sign_detector(
        .A(sync_A),
        .B(sync_B),
        .zero_flag(zero_flag),
        .abs_A(abs_A),
        .abs_B(abs_B),
        .result_sign(result_sign)
    );

    // LOD
    lod lod_A(
        .data(abs_A),
        .k(k1),
        .x(x1)
        );

    lod lod_B(
        .data(abs_B),
        .k(k2),
        .x(x2)
        );

    // Dynamic Truncation
    dynamic_truncation dynamic_truncation_A(
        .x(x1),
        .x_t(x1_t),
        .flag(flag_A),
        .t(t1)
        );

    dynamic_truncation dynamic_truncation_B(
        .x(x2),
        .x_t(x2_t),
        .flag(flag_B),
        .t(t2)
    );
	
	// Logarithmic Converter
	log_converter log_converter_A(
		.k(k1),
		.x_t(x1_t),
		.log_value(log_A)
	);
	
	log_converter log_converter_B(
		.k(k2),
		.x_t(x2_t),
		.log_value(log_B)
	);
	
	// Adder
    bit [3:0] sum_t;
    assign sum_t = t1 + t2;
	adder adder(
		.op1(log_A),
		.op2(log_B),
        .flag(flag_A | flag_B),
        .t(sum_t[3]),
		.sum(log_result)
	);
	
	// Antilogarithmic Converter
	antilog_converter antilog_converter(
		.log_result(log_result),
		.unsigned_result(unsigned_result)
	);

    // Sign Set
    bit signed [15:0] temp_result;
    sign_set sign_set(
        .unsigned_result(unsigned_result),
        .result_sign(result_sign),
        .result(temp_result)
    );

    assign async_result = zero_flag ? 16'b0 : temp_result;
endmodule
