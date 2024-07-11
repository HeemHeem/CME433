module log_multiplier_tb;
    bit signed [7:0]  A, B;
    bit signed [15:0] result, expected_result;

    log_multiplier dut (
        .A(A),
        .B(B),
        .result(result)
    );

    /* ************
    TESTBENCH LOGIC
    **************/
    initial begin
        real dut_err, max_err;
        for(int i = 0; i < 1000000; i++) begin
            A = $random;
            B = $random;
            expected_result = A*B;
            #5
            if (expected_result != 0) begin
                if (expected_result > result)
                    dut_err = $bitstoreal(expected_result-result)/$bitstoreal(expected_result) * 100;
                else
                    dut_err = $bitstoreal(result-expected_result)/$bitstoreal(expected_result) * 100;
            end
            else if (result != 0)
                dut_err = 100;

            // $display("%d * %d = %d. Expect %d. Error %f%%", A, B, result, expected_result, dut_err);

            if (max_err < dut_err)
                max_err = dut_err;
        end
        #100
        $display("Max error: %f%%", max_err);
        $finish;
    end
endmodule
