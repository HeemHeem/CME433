module log_multiplier_tb;
    /* ***************
    SIGNAL DEFINITIONS
    *****************/
    //DUT inputs
    bit [7:0] A, B;
    bit zero_flag_A, zero_flag_B;
    bit [2:0] k1, k2;

    //DUT intermediate taps
    bit [6:0]  x1, x2;
    bit [9:0] log_A, log_B;
    bit [10:0] log_result;

    bit fraction_sum_carry;
    bit [15:0] result;

    /* **************
    DUT INSTANTIATION
    ****************/
    log_multiplier dut (
        .A(A),
        .B(B),
        .zero_flag_A(zero_flag_A),
        .zero_flag_B(zero_flag_B),
        .leading_A(k1),
        .leading_B(k2),
        .fraction_A(x1),
        .fraction_B(x2),
        .log_A(log_A),
        .log_B(log_B),
        .fraction_sum_carry(fraction_sum_carry),
        .log_result(log_result),
        .result(result)
    );

    /* ************
    TESTBENCH LOGIC
    **************/
    initial begin
        #5
        assign A = 6;
        assign B = 6;

        #100
        $finish;
    end

endmodule