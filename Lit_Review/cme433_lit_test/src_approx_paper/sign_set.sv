module sign_set(
    input  bit        [15:0] unsigned_result,
    input  bit               result_sign,
    output bit signed [15:0] result
);

    assign result = result_sign ? (~unsigned_result + 16'b1) : unsigned_result;
endmodule
