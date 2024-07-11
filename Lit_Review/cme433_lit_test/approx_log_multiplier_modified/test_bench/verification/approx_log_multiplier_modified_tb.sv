`include "approx_log_multiplier_modified.sv"

module approx_log_multiplier_modified_tb;
    bit signed [7:0]  A, B;
    bit signed [15:0] result, expected_result;

    approx_log_multiplier_modified dut(
        .A(A),
        .B(B),
        .result(result)
    );

    /* ************
    TESTBENCH LOGIC
    **************/
    initial begin
        real dut_err, max_err;
        int low_err_count, med_err_count, high_err_count, sky_err_count;

        for(int i = 0; i < 256; i++) begin 
            for (int j = 0; j < 256; j++) begin
                A = i;
                B = j;
                expected_result = A*B;
                #5
                if (expected_result != 0) begin
                    dut_err = $itor(expected_result-result)/expected_result * 100;
                    if (dut_err < 0) dut_err = -dut_err;
                end
                else if (result != 0)
                    dut_err = 100;

                // Update max_err
                if (max_err < dut_err) begin max_err = dut_err; end

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
        $display("Low bracket:  %0d", low_err_count);
        $display("Med bracket:  %0d", med_err_count);
        $display("High bracket: %0d", high_err_count);
        $display("Sky bracket:  %0d", sky_err_count);

        $finish;
    end
endmodule
