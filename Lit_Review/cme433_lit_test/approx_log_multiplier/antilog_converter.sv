`include "parameters.sv"

module antilog_converter(
    input  bit [`T+3:0] log_result,
    output bit [15:0]   unsigned_result
    );

    bit [14+`T :0] temp_result;
    bit [3:0]      k;
    bit [`T-1:0]   x_t;

    assign k   = log_result[`T+3 -:4];
    assign x_t = log_result[`T-1:0];
    
    assign temp_result = x_t[`T-1] ? x_t << (k+1) : {1'b1, x_t[`T-2:0]} << k;
    assign unsigned_result = temp_result[14+`T : `T-1];
endmodule
