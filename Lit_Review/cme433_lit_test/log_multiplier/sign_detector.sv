module sign_detector(
    input  bit signed [7:0] A, B,
    output bit              zero_flag,
    output bit        [7:0] abs_A, abs_B,
    output bit              result_sign
    );

    assign zero_flag = (A == 8'b0) || (B == 8'b0);
    assign result_sign = A[7] ^ B[7];
    assign abs_A = A[7] ? (~A + 7'b1) : A;
    assign abs_B = B[7] ? (~B + 7'b1) : B;
endmodule
