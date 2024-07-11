`include "parameters.sv"
module antilog_converter(
    input  bit [`T+2:0] log_result,
    output bit [15:0]   unsigned_result
    );

    bit [31:0] tmp;
    bit [3:0]   k;
    bit [`T-1:0] x_t;

    assign k   = log_result[`T+2:`T-1];
    assign x_t = {1'b1, log_result[`T-2:0]};
    
    assign tmp = x_t << k >> (`T-1);
    assign unsigned_result = tmp[15:0];
endmodule
