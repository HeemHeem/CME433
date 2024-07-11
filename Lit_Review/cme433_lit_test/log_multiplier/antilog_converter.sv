module antilog_converter(
    input  bit [11:0] log_result,
    output bit [15:0] unsigned_result
    );

    bit [22:0] temp_result;
    bit [3:0]  k;
    bit [7:0]  x;

    assign k = log_result[11:8];
    assign x = log_result[7:0];

    assign temp_result = x[7] ? x << (k + 1) : {1'b1, x[6:0]} << k;
    assign unsigned_result = temp_result[22:7];
endmodule
