`include "parameters.sv"

module approx_log_multiplier_tb;
    bit clk;
    bit signed [7:0] A, B;
    bit [7:0] abs_A, abs_B;
    bit zero_flag, result_sign;
    bit [2:0] k1, k2;
    bit [7:0]    x1, x2;
    bit [`T-1:0] x1_t, x2_t;
    bit [`T+2:0] log_A, log_B;
    bit [`T+3:0] log_result;
    bit [15:0] unsigned_result;
    bit signed [15:0] result, expected_result;

    always #10 clk = ~clk;

    approx_log_multiplier dut (
        .clk(clk),
        .A(A),
        .B(B),
        // .abs_A(abs_A),
        // .abs_B(abs_B),
        // .zero_flag(zero_flag),
        // .result_sign(result_sign),
        // .k1(k1),
        // .k2(k2),
        // .x1(x1),
        // .x2(x2),
        // .x1_t(x1_t),
        // .x2_t(x2_t),
        // .log_A(log_A),
        // .log_B(log_B),
        // .log_result(log_result),
        // .unsigned_result(unsigned_result),
        .result(result)
    );

    /* ************
    TESTBENCH LOGIC
    **************/
    initial begin
        real dut_err, max_err;
        int low_err_count, med_err_count, high_err_count, sky_err_count;

        for(int i = -128; i < 128; i++) begin
            for (int j = -128; j < 128; j++) begin
                A = 8'(i);
                B = 8'(j);
                expected_result = A*B;

                repeat (2) @ (negedge clk);
                if (expected_result != 0) begin
                    dut_err = $itor(expected_result-result)/expected_result * 100;
                    if (dut_err < 0) dut_err = -dut_err;
                end
                else if (result != 0)
                    dut_err = 100;

                // Update max_err
                if (max_err < dut_err) begin
                    max_err = dut_err;
                    $display("%d * %d = %d. Expect %d. Error %f%%", A, B, result, expected_result, dut_err);
                end

                // Update the counts
                if      (dut_err < `LOW)  low_err_count++;
                else if (dut_err < `MED)  med_err_count++;
                else if (dut_err < `HIGH) begin high_err_count++; end
                else                      sky_err_count++;

                if (dut_err == 100)
                    $display("%d * %d = %d. Expect %d. Error %f%%", A, B, result, expected_result, dut_err);
                
                // $display("%d * %d = %d. Expect %d. Error %f%%", A, B, result, expected_result, dut_err);
            end
        end

        #100
        $display("Max error:    %0f%%", max_err);
        $display("Low bracket:  %0d \t- %f%%", low_err_count, $itor(low_err_count)/65536 * 100);
        $display("Med bracket:  %0d \t- %f%%", med_err_count, $itor(med_err_count)/65536 * 100);
        $display("High bracket: %0d \t- %f%%", high_err_count, $itor(high_err_count)/65536 * 100);
        $display("Sky bracket:  %0d \t- %f%%", sky_err_count, $itor(sky_err_count)/65536 * 100);

        $finish;
    end
endmodule
